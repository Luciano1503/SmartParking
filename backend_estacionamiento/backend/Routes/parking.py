from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import List, Optional
from Database.connection import get_connection

router = APIRouter(prefix="/parking", tags=["Parking"])

# --- MODELOS DE ENTRADA (Validación Pydantic) ---
class DivisionSchema(BaseModel):
    id: str
    espacios: int

class PisoSchema(BaseModel):
    divisiones: List[DivisionSchema]

class ParkingConfigSchema(BaseModel):
    empresa_id: int
    nombre: str
    descripcion: str
    direccion: str
    imagen_url: Optional[str] = None
    latitud: float
    longitud: float
    columnas_diseno: int
    filas_diseno: int
    pisos: List[PisoSchema]

# --- ENDPOINT 1: LISTAR (Para Flutter) ---
@router.get("/lista")
def listar_estacionamientos():
    conn = get_connection()
    cur = conn.cursor()
    try:
        # Consulta que trae info básica y cuenta los espacios totales vinculados
        cur.execute("""
            SELECT 
                e.id, 
                e.nombre, 
                e.descripcion, 
                e.direccion, 
                e.imagen_url,
                (SELECT COUNT(*) 
                 FROM nivel n 
                 JOIN zona z ON z.nivel_id = n.id 
                 JOIN espacio esp ON esp.zona_id = z.id 
                 WHERE n.estacionamiento_id = e.id) as total_espacios
            FROM estacionamiento e
            ORDER BY e.id DESC;
        """)
        
        rows = cur.fetchall()
        estacionamientos = []
        
        for row in rows:
            # Compatibilidad con RealDictCursor (dict) o Cursor estándar (tuple)
            if isinstance(row, dict):
                estacionamientos.append({
                    "id": row['id'],
                    "nombre": row['nombre'],
                    "descripcion": row['descripcion'],
                    "direccion": row['direccion'],
                    "imagen_url": row['imagen_url'],
                    "total_espacios": row['total_espacios']
                })
            else:
                estacionamientos.append({
                    "id": row[0], "nombre": row[1], "descripcion": row[2],
                    "direccion": row[3], "imagen_url": row[4], "total_espacios": row[5]
                })
                
        return estacionamientos

    except Exception as e:
        print(f"❌ Error en listar_estacionamientos: {e}")
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cur.close()
        conn.close()

# --- ENDPOINT 2: CONFIGURAR (Para Portal Web) ---
@router.post("/configurar")
def configurar_estacionamiento(config: ParkingConfigSchema):
    conn = get_connection()
    cur = conn.cursor()
    
    try:
        # 1. Obtener contador inicial para sensores (S-0000X)
        cur.execute("SELECT COUNT(*) AS total FROM espacio;")
        resultado_count = cur.fetchone()
        
        if isinstance(resultado_count, dict):
            total_previo = resultado_count.get('total', 0)
        elif isinstance(resultado_count, tuple):
            total_previo = resultado_count[0]
        else:
            total_previo = 0
            
        contador_sensor = total_previo + 1

        # 2. Insertar Estacionamiento Principal
        cur.execute("""
            INSERT INTO estacionamiento (nombre, direccion, descripcion, imagen_url, latitud, longitud, empresa_id)
            VALUES (%s, %s, %s, %s, %s, %s, %s) RETURNING id;
        """, (config.nombre, config.direccion, config.descripcion, config.imagen_url, 
              config.latitud, config.longitud, config.empresa_id))
        
        res_est = cur.fetchone()
        estacionamiento_id = res_est['id'] if isinstance(res_est, dict) else res_est[0]

        # 3. Iteración para Niveles, Zonas y Espacios (Inserción Masiva)
        for i, piso_data in enumerate(config.pisos):
            cur.execute("""
                INSERT INTO nivel (estacionamiento_id, nombre, numero, columnas, filas)
                VALUES (%s, %s, %s, %s, %s) RETURNING id;
            """, (estacionamiento_id, f"Nivel {i+1}", i + 1, config.columnas_diseno, config.filas_diseno))
            
            res_niv = cur.fetchone()
            nivel_id = res_niv['id'] if isinstance(res_niv, dict) else res_niv[0]

            for div in piso_data.divisiones:
                cur.execute("INSERT INTO zona (nivel_id, nombre) VALUES (%s, %s) RETURNING id;", 
                           (nivel_id, f"Zona {div.id}"))
                
                res_zona = cur.fetchone()
                zona_id = res_zona['id'] if isinstance(res_zona, dict) else res_zona[0]

                for j in range(div.espacios):
                    codigo_espacio = f"{div.id}{j+1}"
                    sensor_secuencial = f"S-{contador_sensor:05d}"
                    contador_sensor += 1
                    
                    cur.execute("""
                        INSERT INTO espacio (zona_id, codigo, sensor_codigo, estado_actual)
                        VALUES (%s, %s, %s, %s) RETURNING id;
                    """, (zona_id, codigo_espacio, sensor_secuencial, 'libre'))
                    
                    res_esp = cur.fetchone()
                    nuevo_espacio_id = res_esp['id'] if isinstance(res_esp, dict) else res_esp[0]

                    # 4. Registro inicial en historial
                    cur.execute("INSERT INTO registro_estado (espacio_id, estado) VALUES (%s, %s);", 
                               (nuevo_espacio_id, 'libre'))

        conn.commit()
        return {"status": "success", "message": "Configuración guardada exitosamente"}

    except Exception as e:
        if conn: conn.rollback()
        print("--------- ERROR EN DATABASE ---------")
        print(f"Tipo: {type(e).__name__} | Detalle: {str(e)}")
        print("-------------------------------------")
        raise HTTPException(status_code=500, detail=str(e))
    
    finally:
        if cur: cur.close()
        if conn: conn.close()


@router.get("/detalle/{estacionamiento_id}")
def detalle_mapa(estacionamiento_id: int):
    conn = get_connection()
    cur = conn.cursor()
    try:
        cur.execute("""
            SELECT id, nombre, numero, columnas, filas 
            FROM nivel 
            WHERE estacionamiento_id = %s 
            ORDER BY numero;
        """, (estacionamiento_id,))
        niveles = cur.fetchall()
        
        resultado = []
        for n in niveles:
            # Manejo por si el cursor devuelve diccionario o tupla
            n_id = n['id'] if isinstance(n, dict) else n[0]
            n_nombre = n['nombre'] if isinstance(n, dict) else n[1]
            # Extraemos los nuevos valores (índices 3 y 4 si es tupla)
            n_columnas = n['columnas'] if isinstance(n, dict) else n[3]
            n_filas = n['filas'] if isinstance(n, dict) else n[4]
            
            # 2. Traer Zonas por Nivel
            cur.execute("SELECT id, nombre FROM zona WHERE nivel_id = %s;", (n_id,))
            zonas = cur.fetchall()
            
            zonas_list = []
            for z in zonas:
                z_id = z['id'] if isinstance(z, dict) else z[0]
                z_nombre = z['nombre'] if isinstance(z, dict) else z[1]
                
                # 3. Traer Espacios por Zona (Aquí viene el estado del sensor IoT)
                cur.execute("SELECT id, codigo, estado_actual FROM espacio WHERE zona_id = %s ORDER BY codigo;", (z_id,))
                espacios = cur.fetchall()
                
                # Formateamos espacios para asegurar que el frontend lo lea bien
                espacios_format = []
                for e in espacios:
                    espacios_format.append({
                        "id": e['id'] if isinstance(e, dict) else e[0],
                        "codigo": e['codigo'] if isinstance(e, dict) else e[1],
                        "estado_actual": e['estado_actual'] if isinstance(e, dict) else e[2]
                    })
                
                zonas_list.append({
                    "nombre": z_nombre,
                    "espacios": espacios_format # Lista de diccionarios formateados
                })
            
            # Construimos la respuesta del nivel incluyendo horizontal y vertical
            resultado.append({
                "nivel": n_nombre,
                "columnas": n_columnas, # <-- AHORA EL FRONTEND RECIBIRÁ ESTO
                "filas": n_filas,     # <-- Y TAMBIÉN ESTO
                "zonas": zonas_list
            })
            
        return resultado
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cur.close()
        conn.close()