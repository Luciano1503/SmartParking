"""
================================================================
  Arduino Serial Bridge - SmartParking Solutions
  Lee datos del sensor HC-SR04 via puerto serial y actualiza
  la base de datos PostgreSQL en tiempo real.
  VERSIÃ“N BULLETPROOF: Auto-reconexiÃ³n ante fallos USB.
================================================================
"""

import serial
import serial.tools.list_ports
import psycopg2
from psycopg2.extras import RealDictCursor
import time
import sys
import os
from datetime import datetime
import requests

# Forzar encoding UTF-8 en la consola de Windows
if sys.platform == "win32":
    os.system("chcp 65001 >nul 2>&1")
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')

# ================================================================
# CONFIGURACION
# ================================================================

SERIAL_PORT = None
BAUD_RATE = 9600
SENSOR_CODIGO = "S-00001"
TIEMPO_CONFIRMACION = 15

DB_CONFIG = {
    "host": os.getenv("DB_HOST", "localhost"),
    "database": os.getenv("DB_NAME", "ProyectoIntegrador"),
    "user": os.getenv("DB_USER", "postgres"),
    "password": os.getenv("DB_PASSWORD"),
}

ESTADOS = {
    0: "libre",
    1: "ocupado",
    2: "no operativo",
}


def detectar_puerto_arduino():
    """Auto-detecta el puerto COM del Arduino."""
    print("\n[BUSCAR] Buscando Arduino conectado...")
    puertos = serial.tools.list_ports.comports()

    for puerto in puertos:
        desc = (puerto.description or "").lower()
        hwid = (puerto.hwid or "").lower()
        if any(palabra in desc for palabra in ["arduino", "ch340", "usb-serial", "usb serial"]):
            print(f"   [OK] Arduino detectado en: {puerto.device} ({puerto.description})")
            return puerto.device
        if "2341" in hwid or "1a86" in hwid:
            print(f"   [OK] Arduino detectado en: {puerto.device} (por VID)")
            return puerto.device

    print("\n   [!] No se detecto Arduino automaticamente.")
    print("   Puertos disponibles:")
    for p in puertos:
        print(f"      - {p.device} -- {p.description}")

    if puertos:
        seleccion = puertos[0].device
        print(f"\n   Usando el primero disponible: {seleccion}")
        return seleccion

    return None


def conectar_db():
    """Establece conexion con PostgreSQL. SIN autocommit para manejar transacciones."""
    try:
        conn = psycopg2.connect(
            **DB_CONFIG,
            cursor_factory=RealDictCursor
        )
        # NO autocommit - usamos transacciones explicitas
        conn.autocommit = False
        print("   [OK] Conexion a PostgreSQL establecida")
        return conn
    except Exception as e:
        print(f"   [ERROR] Error conectando a PostgreSQL: {e}")
        return None


def obtener_espacio_id(conn, sensor_codigo):
    """Obtiene el ID del espacio asociado al sensor."""
    cursor = conn.cursor()
    cursor.execute(
        "SELECT id, codigo, zona_id FROM espacio WHERE sensor_codigo = %s",
        (sensor_codigo,)
    )
    resultado = cursor.fetchone()
    cursor.close()
    conn.commit()

    if resultado:
        print(f"   [OK] Sensor {sensor_codigo} -> Espacio '{resultado['codigo'].strip()}' (ID: {resultado['id']}, Zona: {resultado['zona_id']})")
        return resultado['id']
    else:
        print(f"   [ERROR] No se encontro espacio con sensor_codigo = '{sensor_codigo}'")
        return None


def obtener_estado_actual_db(conn, espacio_id):
    """Obtiene el estado actual del espacio en la base de datos."""
    cursor = conn.cursor()
    cursor.execute(
        "SELECT estado_actual FROM espacio WHERE id = %s",
        (espacio_id,)
    )
    resultado = cursor.fetchone()
    cursor.close()
    conn.commit()
    return resultado['estado_actual'].strip() if resultado else None


def actualizar_estado(conn, espacio_id, nuevo_estado):
    """
    Actualiza el estado del espacio y gestiona el historial de movimientos.
    Detecta entradas (INSERT) y salidas (UPDATE con duraciÃ³n).
    AL FINAL: Notifica al servidor FastAPI vÃ­a Webhook para activar WebSockets.
    """
    estado_actual = obtener_estado_actual_db(conn, espacio_id)

    if estado_actual == nuevo_estado:
        return False  # Sin cambio

    ahora = datetime.now()
    cursor = conn.cursor()

    try:
        # 1) Actualizar tabla espacio (Estado actual para el mapa)
        cursor.execute(
            """
            UPDATE espacio
            SET estado_actual = %s, ultimo_update = %s
            WHERE id = %s
            """,
            (nuevo_estado, ahora, espacio_id)
        )
        print(f"\n   [DB] Espacio {espacio_id} cambiado a: {nuevo_estado}")

        # 2) LÃ³gica para la tabla movimiento_estacionamiento
        if nuevo_estado == "ocupado":
            # SE OCUPÃ“: Creamos un nuevo registro
            cursor.execute(
                """
                INSERT INTO movimiento_estacionamiento 
                (espacio_id, fecha_inicio, metodo_deteccion, confirmado, confianza)
                VALUES (%s, %s, 'auto', TRUE, 1.0)
                """,
                (espacio_id, ahora)
            )
            print("   [DB] Movimiento: Registro de entrada CREADO.")

        elif nuevo_estado == "libre" and estado_actual == "ocupado":
            # SE LIBERÃ“: Actualizamos el registro abierto
            cursor.execute(
                """
                UPDATE movimiento_estacionamiento 
                SET fecha_fin = %s, 
                    duracion = %s - fecha_inicio
                WHERE espacio_id = %s AND fecha_fin IS NULL
                """,
                (ahora, ahora, espacio_id)
            )
            print("   [DB] Movimiento: Registro de salida ACTUALIZADO.")

        # 3) Mantener registro_estado (AuditorÃ­a)
        cursor.execute(
            """
            UPDATE registro_estado
            SET estado = %s, fecha = %s
            WHERE id = (
                SELECT id FROM registro_estado 
                WHERE espacio_id = %s 
                ORDER BY id ASC 
                LIMIT 1
            )
            """,
            (nuevo_estado, ahora, espacio_id)
        )

        # COMMIT - Guardamos fÃ­sicamente en la base de datos
        conn.commit()
        cursor.close()

        # ================================================================
        # NUEVO: DISPARADOR DE TIEMPO REAL (WEBHOOK)
        # ================================================================
        try:
            # URL de tu backend de FastAPI que creamos en el paso anterior
            url_backend = "http://localhost:8000/notificar_cambio"
            
            payload = {
                "espacio_id": espacio_id,
                "nuevo_estado": nuevo_estado,
                "fecha": ahora.strftime("%Y-%m-%d %H:%M:%S")
            }
            
            # Enviamos la seÃ±al al servidor para que el broadcast ocurra
            response = requests.post(url_backend, json=payload, timeout=2)
            
            if response.status_code == 200:
                print(f"   [WS] NotificaciÃ³n de tiempo real enviada con Ã©xito.")
            else:
                print(f"   [!] El servidor respondiÃ³ con error: {response.status_code}")
                
        except Exception as e:
            print(f"   [!] Error al conectar con el servidor para WebSocket: {e}")
        # ================================================================

        return True

    except Exception as e:
        conn.rollback()
        print(f"\n   [ERROR] Error en la transacciÃ³n: {e}")
        cursor.close()
        return False

def imprimir_banner():
    """Imprime el banner de inicio."""
    print("\n" + "=" * 60)
    print("  [P] SmartParking -- Arduino Serial Bridge")
    print("  Sensor HC-SR04 -> PostgreSQL (Bulletproof Mode)")
    print("=" * 60)


def imprimir_estado(estado_num, estado_texto, tiempo_deteccion=None):
    """Imprime el estado actual del sensor de forma visual."""
    iconos = {0: "[VERDE]", 1: "[ROJO]", 2: "[AMARILLO]"}
    icono = iconos.get(estado_num, "[?]")

    if estado_num == 1 and tiempo_deteccion is not None:
        barra_progreso = int((tiempo_deteccion / TIEMPO_CONFIRMACION) * 20)
        barra = "#" * min(barra_progreso, 20) + "." * max(20 - barra_progreso, 0)
        print(f"   {icono} {estado_texto.upper():15s} [{barra}] {tiempo_deteccion:.0f}/{TIEMPO_CONFIRMACION}s", end="\r")
    else:
        print(f"   {icono} {estado_texto.upper():15s}                                        ", end="\r")


def iniciar_puente():
    imprimir_banner()

    # --- Bucle de Supervivencia (Bulletproof) ---
    while True:
        arduino = None
        conn = None
        
        try:
            # --- Determinar puerto serial ---
            puerto = SERIAL_PORT or detectar_puerto_arduino()
            if not puerto:
                print("\n[ERROR] No se pudo encontrar el Arduino. Reintentando en 3s...")
                time.sleep(3)
                continue

            # --- Conectar a PostgreSQL ---
            print("\n[DB] Conectando a la base de datos...")
            conn = conectar_db()
            if not conn:
                print("\n[ERROR] Sin Base de Datos. Reintentando en 3s...")
                time.sleep(3)
                continue

            # --- Obtener ID del espacio ---
            print(f"\n[SENSOR] Buscando espacio para sensor: {SENSOR_CODIGO}")
            espacio_id = obtener_espacio_id(conn, SENSOR_CODIGO)
            if not espacio_id:
                print("\n[ERROR] Sensor no registrado en BD. Reintentando en 3s...")
                time.sleep(3)
                continue

            # --- Conectar al Arduino ---
            print(f"\n[SERIAL] Conectando al Arduino en {puerto} @ {BAUD_RATE} baud...")
            arduino = serial.Serial(puerto, BAUD_RATE, timeout=1)
            time.sleep(2) # Darle tiempo al Arduino para resetearse
            print(f"   [OK] Arduino conectado en {puerto}")

            # --- Variables de estado ---
            estado_anterior_db = obtener_estado_actual_db(conn, espacio_id)
            tiempo_inicio_deteccion = None
            ocupado_confirmado = False
            lecturas_error = 0
            UMBRAL_ERROR = 5 

            print(f"\n   Estado actual en BD: {estado_anterior_db}")
            print(f"   Tiempo de confirmacion: {TIEMPO_CONFIRMACION}s")
            print(f"   Umbral error sensor: {UMBRAL_ERROR} lecturas consecutivas")
            print("\n" + "-" * 60)
            print("   Monitoreando sensor en tiempo real...")
            print("   (Presiona Ctrl+C para detener)")
            print("-" * 60 + "\n")

            # --- Bucle de Lectura ---
            while True:
                if arduino.in_waiting > 0:
                    try:
                        linea = arduino.readline().decode("utf-8").strip()
                    except UnicodeDecodeError:
                        continue

                    # Mostrar datos crudos para debug
                    if linea and not linea.startswith("SmartParking") and not linea.startswith("Iniciando"):
                        pass  # Lineas validas

                    if not linea.startswith("ESTADO:"):
                        continue

                    try:
                        estado_num = int(linea.split(":")[1])
                    except (ValueError, IndexError):
                        continue

                    ahora = time.time()

                    # === MAQUINA DE ESTADOS ===

                    if estado_num == 1:
                        # --- Sensor detecta presencia (rojo) ---
                        lecturas_error = 0 

                        if tiempo_inicio_deteccion is None:
                            tiempo_inicio_deteccion = ahora
                            ocupado_confirmado = False

                        tiempo_transcurrido = ahora - tiempo_inicio_deteccion
                        imprimir_estado(1, "detectando...", tiempo_transcurrido)

                        if tiempo_transcurrido >= TIEMPO_CONFIRMACION and not ocupado_confirmado:
                            if actualizar_estado(conn, espacio_id, "ocupado"):
                                ocupado_confirmado = True
                                print(f"\n   [ROJO] OCUPADO! Estado actualizado en BD  [{datetime.now().strftime('%H:%M:%S')}]")
                            else:
                                print(f"\n   [!] Fallo al actualizar a ocupado")

                        elif ocupado_confirmado:
                            imprimir_estado(1, "OCUPADO", TIEMPO_CONFIRMACION)

                    elif estado_num == 0:
                        # --- Espacio libre (verde) ---
                        tiempo_inicio_deteccion = None
                        ocupado_confirmado = False
                        lecturas_error = 0 
                        imprimir_estado(0, "LIBRE")

                        if actualizar_estado(conn, espacio_id, "libre"):
                            print(f"\n   [VERDE] LIBRE -- Estado actualizado en BD  [{datetime.now().strftime('%H:%M:%S')}]")

                    elif estado_num == 2:
                        # --- Error del sensor (amarillo) ---
                        tiempo_inicio_deteccion = None
                        ocupado_confirmado = False
                        lecturas_error += 1

                        imprimir_estado(2, f"ERROR ({lecturas_error}/{UMBRAL_ERROR})")

                        if lecturas_error >= UMBRAL_ERROR:
                            if actualizar_estado(conn, espacio_id, "no operativo"):
                                print(f"\n   [AMARILLO] NO OPERATIVO -- Estado actualizado en BD  [{datetime.now().strftime('%H:%M:%S')}]")
                                lecturas_error = 0 

                time.sleep(0.1)

        except serial.SerialException as e:
            print(f"\n\n   [!] CONEXIÃ“N PERDIDA CON EL USB: {e}")
            print("   ðŸ”„ Forzando cierre del puerto y reintentando en 3 segundos...")
            time.sleep(3)
        except psycopg2.OperationalError as e:
            print(f"\n\n   [!] CONEXIÃ“N PERDIDA CON POSTGRESQL: {e}")
            print("   ðŸ”„ Reintentando en 3 segundos...")
            time.sleep(3)
        except KeyboardInterrupt:
            print("\n\n" + "=" * 60)
            print("   [STOP] Monitoreo detenido por el usuario")
            print("=" * 60)
            break # Salimos del bucle infinito si el usuario presiona Ctrl+C
        except Exception as e:
            print(f"\n\n   [ERROR] Error inesperado crÃ­tico: {e}")
            print("   ðŸ”„ Reintentando en 3 segundos...")
            time.sleep(3)
        finally:
            # LIMPIEZA CRÃTICA: Aseguramos soltar el puerto y la BD
            if 'arduino' in locals() and arduino and arduino.is_open:
                arduino.close()
                print("   [CLEANUP] Puerto serial cerrado forzosamente.")
            if 'conn' in locals() and conn and not conn.closed:
                conn.close()
                print("   [CLEANUP] ConexiÃ³n BD cerrada forzosamente.")


if __name__ == "__main__":
    iniciar_puente()

