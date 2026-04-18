from fastapi import APIRouter
import hashlib, random
from datetime import datetime, timedelta
from Database.connection import get_connection
from Services.email_service import enviar_codigo
from Models.usuario import UsuarioRegistro, UsuarioVerificacion, UsuarioFormulario, UsuarioLogin

router = APIRouter()

# Registro
@router.post("/registro")
def registrar_usuario(usuario: UsuarioRegistro):
    conn = get_connection()
    cur = conn.cursor()
    codigo = str(random.randint(100000, 999999))
    expiracion = datetime.now() + timedelta(minutes=10)

    try:
        cur.execute("INSERT INTO usuarios (correo) VALUES (%s) RETURNING id;", (usuario.correo,))
        nuevo_id = cur.fetchone()["id"]

        cur.execute("INSERT INTO verificacion (usuario_id, codigo, expiracion) VALUES (%s, %s, %s);",
                    (nuevo_id, codigo, expiracion))
        conn.commit()

        enviar_codigo(usuario.correo, codigo)
        return {"mensaje": "Usuario registrado. Código enviado al correo.", "id": nuevo_id}
    except Exception as e:
        conn.rollback()
        return {"error": str(e)}
    finally:
        cur.close()
        conn.close()

# Verificación
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
            return {"error": "Código inválido"}
        if datetime.now() > registro["expiracion"]:
            return {"error": "Código expirado"}

        cur.execute("UPDATE usuarios SET verificado = TRUE WHERE id = %s;", (registro["usuario_id"],))
        conn.commit()
        return {"mensaje": "Usuario verificado correctamente"}
    except Exception as e:
        conn.rollback()
        return {"error": str(e)}
    finally:
        cur.close()
        conn.close()

# Formulario
@router.post("/formulario")
def completar_formulario(data: UsuarioFormulario):
    conn = get_connection()
    cur = conn.cursor()
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

# Login
@router.post("/login")
def login_usuario(data: UsuarioLogin):
    conn = get_connection()
    cur = conn.cursor()
    try:
        cur.execute("SELECT id, contrasenia, verificado FROM usuarios WHERE correo = %s;", (data.correo,))
        usuario = cur.fetchone()

        if not usuario:
            return {"error": "Usuario no existe"}
        if not usuario["verificado"]:
            return {"error": "Usuario no verificado"}

        contrasenia_hash = hashlib.sha256(data.contrasenia.encode()).hexdigest()
        if usuario["contrasenia"] != contrasenia_hash:
            return {"error": "Contraseña incorrecta"}

        usuario_id = usuario["id"]
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
