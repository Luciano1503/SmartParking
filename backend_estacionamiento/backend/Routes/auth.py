from fastapi import APIRouter, HTTPException
import hashlib, random
from datetime import datetime, timedelta
from Database.connection import get_connection
from Services.email_service import enviar_codigo, enviar_aviso_empresa, enviar_confirmacion_aprobacion, enviar_rechazo_empresa
from Models.usuario import UsuarioRegistro, UsuarioVerificacion, UsuarioFormulario, UsuarioLogin, EmpresaRegistro

router = APIRouter()

# ── REGISTRO CLIENTE ──────────────────────────────────────────
@router.post("/registro")
def registrar_usuario(usuario: UsuarioRegistro):
    conn = get_connection()
    cur = conn.cursor()
    codigo = str(random.randint(100000, 999999))
    expiracion = datetime.now() + timedelta(minutes=10)

    try:
        # 1. Verificamos si el correo ya existe y su estado
        cur.execute("SELECT id, verificado FROM usuarios WHERE correo = %s;", (usuario.correo,))
        registro_existente = cur.fetchone()
        
        nuevo_id = None
        
        if registro_existente:
            # Extraemos datos soportando tuplas o diccionarios
            usuario_id = registro_existente["id"] if isinstance(registro_existente, dict) else registro_existente[0]
            verificado = registro_existente["verificado"] if isinstance(registro_existente, dict) else registro_existente[1]
            
            if verificado:
                # Si ya es un usuario completo, lo bloqueamos
                raise HTTPException(status_code=400, detail="Este correo ya se encuentra registrado y verificado.")
            else:
                # Si no está verificado, le damos una segunda oportunidad (Reutilizamos su ID)
                nuevo_id = usuario_id
        else:
            # 2. Si no existe en absoluto, creamos el usuario
            cur.execute("INSERT INTO usuarios (correo) VALUES (%s) RETURNING id;", (usuario.correo,))
            resultado = cur.fetchone()
            nuevo_id = resultado["id"] if isinstance(resultado, dict) else resultado[0]

        # 3. Borramos códigos viejos atascados e insertamos el nuevo
        cur.execute("DELETE FROM verificacion WHERE usuario_id = %s;", (nuevo_id,))
        cur.execute("INSERT INTO verificacion (usuario_id, codigo, expiracion) VALUES (%s, %s, %s);",
                    (nuevo_id, codigo, expiracion))
        conn.commit()

        # 4. Enviamos el correo (Sin bloqueos lógicos falsos)
        enviar_codigo(usuario.correo, codigo)

        # Si todo fluyó, le decimos a Flutter que avance
        return {"mensaje": "Usuario registrado. Código enviado al correo.", "id": nuevo_id}

    except HTTPException as he:
        raise he
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=f"Error interno: {str(e)}")
    finally:
        cur.close()
        conn.close()

# ── VERIFICACIÓN ──────────────────────────────────────────────
@router.post("/verificar")
def verificar_usuario(data: UsuarioVerificacion):
    conn = get_connection()
    cur = conn.cursor()
    try:
        cur.execute("""
            SELECT v.id, v.expiracion, u.id as usuario_id
            FROM verificacion v
            JOIN usuarios u ON v.usuario_id = u.id
            WHERE u.correo = %s AND v.codigo = %s;
        """, (data.correo, data.codigo))
        registro = cur.fetchone()

        if not registro:
            raise HTTPException(status_code=400, detail="Código inválido")
            
        # Ajuste de extracción por si devuelve tupla o diccionario
        expiracion = registro["expiracion"] if isinstance(registro, dict) else registro[1]
        usuario_id = registro["usuario_id"] if isinstance(registro, dict) else registro[2]

        if datetime.now() > expiracion:
            raise HTTPException(status_code=400, detail="El código ha expirado")

        cur.execute("UPDATE usuarios SET verificado = TRUE WHERE id = %s;", (usuario_id,))
        conn.commit()
        return {"mensaje": "Usuario verificado correctamente"}
        
    except HTTPException as he:
        raise he
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=f"Error interno: {str(e)}")
    finally:
        cur.close()
        conn.close()

# ── FORMULARIO CLIENTE ────────────────────────────────────────
@router.post("/formulario")
def completar_formulario(data: UsuarioFormulario):
    conn = get_connection()
    cur = conn.cursor()
    # Método SHA-256 (Compatible con tu versión de Python)
    contrasenia_hash = hashlib.sha256(data.contrasenia.encode()).hexdigest()
    try:
        cur.execute("SELECT id FROM usuarios WHERE correo = %s AND verificado = TRUE;", (data.correo,))
        usuario = cur.fetchone()
        if not usuario:
            return {"error": "Usuario no verificado"}

        usuario_id = usuario["id"]
        cur.execute("UPDATE usuarios SET contrasenia = %s WHERE id = %s;", (contrasenia_hash, usuario_id))

        cur.execute("""
            INSERT INTO perfil_usuario (usuario_id, nombre, apellido, telefono, dni, fecha_nacimiento, placa, modelo)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s);
        """, (usuario_id, data.nombre, data.apellido, data.telefono, data.dni,
              data.fecha_nacimiento, data.placa, data.modelo))

        conn.commit()
        return {"mensaje": "Perfil completado y contraseña creada"}
    except Exception as e:
        conn.rollback()
        return {"error": str(e)}
    finally:
        cur.close()
        conn.close()

# ── LOGIN (TODOS) ─────────────────────────────────────────────
@router.post("/login")
def login_usuario(data: UsuarioLogin):
    conn = get_connection()
    cur = conn.cursor()
    try:
        # Buscar usuario por correo
        cur.execute("SELECT id, contrasenia, verificado FROM usuarios WHERE correo = %s;", (data.correo,))
        usuario = cur.fetchone()

        if not usuario:
            return {"error": "Usuario no existe"}

        if not usuario["verificado"]:
            return {"error": "Usuario no verificado"}

        # Validar contraseña (hash)
        contrasenia_hash = hashlib.sha256(data.contrasenia.encode()).hexdigest()
        if usuario["contrasenia"] != contrasenia_hash:
            return {"error": "Contraseña incorrecta"}

        usuario_id = usuario["id"]

        # Obtener datos del perfil
        cur.execute("""
            SELECT nombre, apellido, telefono, dni, fecha_nacimiento, placa, modelo
            FROM perfil_usuario
            WHERE usuario_id = %s;
        """, (usuario_id,))
        perfil = cur.fetchone()

        if not perfil:
            return {"error": "Perfil no encontrado"}

        return {
            "mensaje": "Login exitoso",
            "correo": data.correo,
            "nombre": perfil["nombre"],
            "apellido": perfil["apellido"],
            "telefono": perfil["telefono"],
            "dni": perfil["dni"],
            "fecha_nacimiento": str(perfil["fecha_nacimiento"]),
            "placa": perfil["placa"],
            "modelo": perfil["modelo"]
        }
    except Exception as e:
        conn.rollback()
        return {"error": str(e)}
    finally:
        cur.close()
        conn.close()

# ── REGISTRO EMPRESA (SHA-256) ────────────────────────────────
@router.post("/registro-empresa")
def registrar_empresa(data: EmpresaRegistro):
    conn = get_connection()
    cur = conn.cursor()
    
    # Encriptación compatible con Python 3.14
    contrasenia_hash = hashlib.sha256(data.contrasenia.encode()).hexdigest()
    
    try:
        # 1. Insertar en tabla 'usuarios' (verificado=False por defecto para admin)
        cur.execute("""
            INSERT INTO usuarios (correo, contrasenia, tipo, verificado) 
            VALUES (%s, %s, 'empresa', FALSE) RETURNING id;
        """, (data.correo, contrasenia_hash))
        
        usuario_id = cur.fetchone()["id"]

        # 2. Perfil del representante (Datos personales)
        cur.execute("""
            INSERT INTO perfil_usuario (usuario_id, nombre, apellido)
            VALUES (%s, %s, %s);
        """, (usuario_id, data.nombre_representante, data.apellido_representante))

        # 3. Datos de la empresa
        cur.execute("""
            INSERT INTO empresa (nombre, usuario_id)
            VALUES (%s, %s);
        """, (data.nombre_empresa, usuario_id))

        # Guardamos cambios en la base de datos
        conn.commit()
        
        # 4. Enviar correo informativo (usando la nueva función de aviso)
        try:
            enviar_aviso_empresa(data.correo)
        except Exception as e_mail:
            print(f"⚠️ Registro exitoso, pero falló el envío del correo: {e_mail}")

        return {
            "status": "success",
            "mensaje": "Solicitud enviada. Su cuenta será revisada por un administrador en 24h."
        }

    except Exception as e:
        conn.rollback() # Deshace todo si hay error (ej: correo ya registrado)
        print(f"❌ Error crítico en registro empresarial: {e}")
        return {"status": "error", "detalle": str(e)}
    finally:
        cur.close()
        conn.close()

# ── PANEL ADMIN ───────────────────────────────────────────────
@router.get("/admin/pendientes")
def listar_pendientes():
    try:
        conn = get_connection()
        cur = conn.cursor()
        
        cur.execute("""
            SELECT u.id, u.correo, 
                   COALESCE(e.nombre, 'Sin empresa registrada') as empresa, 
                   COALESCE(p.nombre, 'Sin representante') as representante
            FROM usuarios u
            LEFT JOIN empresa e ON u.id = e.usuario_id
            LEFT JOIN perfil_usuario p ON u.id = p.usuario_id
            WHERE u.verificado IS FALSE AND TRIM(u.tipo) = 'empresa';
        """)
        pendientes = cur.fetchall()
        
        cur.close()
        conn.close()
        return pendientes
    except Exception as e:
        return {"error": str(e)}


@router.post("/admin/aprobar/{usuario_id}")
def aprobar_empresa(usuario_id: int, accion: str):
    conn = get_connection()
    cur = conn.cursor()
    try:
        # 1. Obtener el correo antes de hacer nada
        cur.execute("SELECT correo FROM usuarios WHERE id = %s;", (usuario_id,))
        usuario_db = cur.fetchone()
        
        if not usuario_db:
            return {"error": "Usuario no encontrado"}
            
        correo = usuario_db["correo"]

        # 2. Tomar acción y enviar correo correspondiente
        if accion == "aprobar":
            cur.execute("UPDATE usuarios SET verificado = TRUE WHERE id = %s;", (usuario_id,))
            mensaje = "Empresa aprobada exitosamente."
            try:
                enviar_confirmacion_aprobacion(correo)
            except Exception as mail_err:
                print(f"Error al enviar correo de aprobación: {mail_err}")
        else:
            cur.execute("DELETE FROM usuarios WHERE id = %s;", (usuario_id,))
            mensaje = "Solicitud rechazada y datos eliminados."
            try:
                enviar_rechazo_empresa(correo)
            except Exception as mail_err:
                print(f"Error al enviar correo de rechazo: {mail_err}")
        
        conn.commit()
        return {"mensaje": mensaje}
    except Exception as e:
        conn.rollback()
        return {"error": str(e)}
    finally:
        cur.close()
        conn.close()

# ── LOGIN EXCLUSIVO WEB (ADMIN Y EMPRESAS) ─────────────────────
@router.post("/login-web")
def login_web(data: UsuarioLogin):
    conn = get_connection()
    cur = conn.cursor()
    try:
        cur.execute("SELECT id, contrasenia, verificado, tipo FROM usuarios WHERE correo = %s;", (data.correo,))
        usuario = cur.fetchone()

        if not usuario:
            return {"error": "Usuario no existe"}

        if usuario["tipo"] not in ['admin', 'empresa']:
            return {"error": "Acceso denegado: Plataforma exclusiva para empresas y administradores."}

        if usuario["tipo"] != 'admin' and not usuario["verificado"]:
            return {"error": "Su cuenta de empresa aún no ha sido verificada."}

        # VALIDACIÓN DE CONTRASEÑA (SHA-256) Limpia y segura
        contrasenia_hash = hashlib.sha256(data.contrasenia.encode('utf-8')).hexdigest()
        hash_en_bd = str(usuario["contrasenia"]).strip()

        if hash_en_bd != contrasenia_hash:
            return {"error": "Contraseña incorrecta"}

        cur.execute("SELECT nombre, apellido FROM perfil_usuario WHERE usuario_id = %s;", (usuario["id"],))
        perfil = cur.fetchone()

        return {
            "status": "success",
            "tipo": usuario["tipo"],
            "correo": data.correo,
            "nombre": perfil["nombre"] if perfil else "Admin"
        }
    except Exception as e:
        conn.rollback()
        return {"error": str(e)}
    finally:
        cur.close()
        conn.close()

# ── MONITOREO DE SENSORES (ADMIN) ─────────────────────────────
@router.get("/admin/sensores-inoperativos")
def listar_sensores_inoperativos():
    try:
        conn = get_connection()
        cur = conn.cursor()
        
        # Agregamos LOWER y TRIM para evitar bugs por espacios o mayúsculas invisibles
        cur.execute("""
            SELECT 
                e.id,
                est.nombre as estacionamiento,
                est.direccion,
                n.nombre as nivel,
                z.nombre as zona,
                e.codigo as espacio,
                e.sensor_codigo as codigo_hardware
            FROM espacio e
            JOIN zona z ON e.zona_id = z.id
            JOIN nivel n ON z.nivel_id = n.id
            JOIN estacionamiento est ON n.estacionamiento_id = est.id
            WHERE LOWER(TRIM(e.estado_actual)) = 'no operativo';
        """)
        rows = cur.fetchall()
        
        sensores = []
        for row in rows:
            if isinstance(row, dict):
                sensores.append(row)
            else:
                sensores.append({
                    "id": row[0],
                    "estacionamiento": row[1],
                    "direccion": row[2],
                    "nivel": row[3],
                    "zona": row[4],
                    "espacio": row[5],
                    "codigo_hardware": row[6]
                })
        
        # Print en la consola de Python para asegurarnos de que la BD sí responde
        print(f"🔍 Sensores inoperativos encontrados: {len(sensores)}")
        return sensores

    except Exception as e:
        print(f"❌ Error en listar_sensores_inoperativos: {e}")
        return {"error": str(e)}
    finally:
        if 'cur' in locals(): cur.close()
        if 'conn' in locals(): conn.close()