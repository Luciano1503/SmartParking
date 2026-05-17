import os
import sys
import time
from contextlib import suppress
from datetime import datetime
from pathlib import Path

import psycopg2
import requests
import serial
import serial.tools.list_ports
from dotenv import load_dotenv
from psycopg2.extras import RealDictCursor

load_dotenv(Path(__file__).resolve().parents[3] / ".env")

if sys.platform == "win32":
    os.system("chcp 65001 >nul 2>&1")
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

SERIAL_PORT = os.getenv("SERIAL_PORT") or None
BAUD_RATE = int(os.getenv("SERIAL_BAUD_RATE", "9600"))
SENSOR_CODIGO = os.getenv("SENSOR_CODIGO", "S-00001")
TIEMPO_CONFIRMACION = float(os.getenv("TIEMPO_CONFIRMACION_OCUPADO", "15"))
UMBRAL_ERROR = int(os.getenv("UMBRAL_ERROR_SENSOR", "5"))
UMBRAL_RECUPERACION = int(os.getenv("UMBRAL_RECUPERACION_SENSOR", "3"))
SERIAL_STALE_TIMEOUT = float(os.getenv("SERIAL_STALE_TIMEOUT", "12"))
BACKEND_NOTIFY_URL = os.getenv("BACKEND_NOTIFY_URL", "http://localhost:8000/notificar_cambio")

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


def _estado_normalizado(valor):
    return (valor or "").strip().lower().replace("_", " ")


def detectar_puerto_arduino():
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
    for puerto in puertos:
        print(f"      - {puerto.device} -- {puerto.description}")

    if puertos:
        seleccion = puertos[0].device
        print(f"\n   Usando el primero disponible: {seleccion}")
        return seleccion

    return None


def conectar_db():
    try:
        conn = psycopg2.connect(**DB_CONFIG, cursor_factory=RealDictCursor)
        conn.autocommit = False
        print("   [OK] Conexion a PostgreSQL establecida")
        return conn
    except Exception as exc:
        print(f"   [ERROR] Error conectando a PostgreSQL: {exc}")
        return None


def preparar_arduino(arduino):
    try:
        arduino.reset_input_buffer()
        arduino.reset_output_buffer()
    except Exception:
        pass

    try:
        arduino.dtr = False
        time.sleep(0.2)
        arduino.dtr = True
    except Exception:
        pass

    time.sleep(2)


def obtener_espacio_id(conn, sensor_codigo):
    with conn.cursor() as cursor:
        cursor.execute(
            "SELECT id, codigo, zona_id FROM espacio WHERE sensor_codigo = %s",
            (sensor_codigo,),
        )
        resultado = cursor.fetchone()
    conn.commit()

    if resultado:
        codigo = resultado["codigo"].strip()
        print(
            f"   [OK] Sensor {sensor_codigo} -> Espacio '{codigo}' "
            f"(ID: {resultado['id']}, Zona: {resultado['zona_id']})"
        )
        return resultado["id"]

    print(f"   [ERROR] No se encontro espacio con sensor_codigo = '{sensor_codigo}'")
    return None


def obtener_estado_actual_db(conn, espacio_id):
    with conn.cursor() as cursor:
        cursor.execute(
            "SELECT estado_actual FROM espacio WHERE id = %s",
            (espacio_id,),
        )
        resultado = cursor.fetchone()
    conn.commit()
    return _estado_normalizado(resultado["estado_actual"]) if resultado else None


def notificar_cambio(espacio_id, nuevo_estado, fecha):
    payload = {
        "espacio_id": espacio_id,
        "nuevo_estado": nuevo_estado,
        "fecha": fecha.strftime("%Y-%m-%d %H:%M:%S"),
        "origen": "arduino_serial",
    }

    try:
        response = requests.post(BACKEND_NOTIFY_URL, json=payload, timeout=2)
        if response.status_code == 200:
            print("   [WS] Notificacion de tiempo real enviada con exito.")
        else:
            print(f"   [!] Backend respondio con error: {response.status_code}")
    except Exception as exc:
        print(f"   [!] No se pudo notificar al WebSocket: {exc}")


def actualizar_estado(conn, espacio_id, nuevo_estado):
    nuevo_estado = _estado_normalizado(nuevo_estado)
    ahora = datetime.now()
    cursor = conn.cursor()

    try:
        cursor.execute(
            "SELECT estado_actual FROM espacio WHERE id = %s FOR UPDATE",
            (espacio_id,),
        )
        fila = cursor.fetchone()
        if not fila:
            conn.rollback()
            return {"ok": False, "changed": False, "estado": None}

        estado_actual = _estado_normalizado(fila["estado_actual"])
        if estado_actual == nuevo_estado:
            conn.commit()
            return {"ok": True, "changed": False, "estado": nuevo_estado}

        cursor.execute(
            """
            UPDATE espacio
            SET estado_actual = %s, ultimo_update = %s
            WHERE id = %s
            """,
            (nuevo_estado, ahora, espacio_id),
        )
        print(f"\n   [DB] Espacio {espacio_id} cambiado: {estado_actual} -> {nuevo_estado}")

        if nuevo_estado == "ocupado":
            cursor.execute(
                """
                INSERT INTO movimiento_estacionamiento
                    (espacio_id, fecha_inicio, metodo_deteccion, confirmado, confianza)
                SELECT %s, %s, 'auto', TRUE, 1.0
                WHERE NOT EXISTS (
                    SELECT 1
                    FROM movimiento_estacionamiento
                    WHERE espacio_id = %s AND fecha_fin IS NULL
                )
                """,
                (espacio_id, ahora, espacio_id),
            )
            if cursor.rowcount:
                print("   [DB] Movimiento: entrada creada.")
            else:
                print("   [DB] Movimiento: ya existia una entrada abierta.")

        elif nuevo_estado == "libre":
            cursor.execute(
                """
                UPDATE movimiento_estacionamiento
                SET fecha_fin = %s,
                    duracion = %s - fecha_inicio
                WHERE espacio_id = %s AND fecha_fin IS NULL
                """,
                (ahora, ahora, espacio_id),
            )
            if cursor.rowcount:
                print("   [DB] Movimiento: salida cerrada.")

        cursor.execute(
            """
            UPDATE registro_estado
            SET estado = %s, fecha = %s
            WHERE id = (
                SELECT id
                FROM registro_estado
                WHERE espacio_id = %s
                ORDER BY id DESC
                LIMIT 1
            )
            """,
            (nuevo_estado, ahora, espacio_id),
        )
        if cursor.rowcount == 0:
            cursor.execute(
                "INSERT INTO registro_estado (espacio_id, estado, fecha) VALUES (%s, %s, %s)",
                (espacio_id, nuevo_estado, ahora),
            )

        conn.commit()
        notificar_cambio(espacio_id, nuevo_estado, ahora)
        return {"ok": True, "changed": True, "estado": nuevo_estado}

    except (psycopg2.OperationalError, psycopg2.InterfaceError):
        with suppress(Exception):
            conn.rollback()
        raise
    except Exception as exc:
        with suppress(Exception):
            conn.rollback()
        print(f"\n   [ERROR] Error actualizando BD: {exc}")
        return {"ok": False, "changed": False, "estado": None}
    finally:
        with suppress(Exception):
            cursor.close()


def imprimir_banner():
    print("\n" + "=" * 60)
    print("  [P] SmartParking -- Arduino Serial Bridge")
    print("  Sensor HC-SR04 -> PostgreSQL + WebSocket")
    print("=" * 60)


def imprimir_estado(estado_num, estado_texto, tiempo_deteccion=None):
    iconos = {0: "[VERDE]", 1: "[ROJO]", 2: "[AMARILLO]"}
    icono = iconos.get(estado_num, "[?]")

    if estado_num == 1 and tiempo_deteccion is not None:
        barra_progreso = int((tiempo_deteccion / TIEMPO_CONFIRMACION) * 20)
        barra = "#" * min(barra_progreso, 20) + "." * max(20 - barra_progreso, 0)
        print(
            f"   {icono} {estado_texto.upper():15s} [{barra}] "
            f"{tiempo_deteccion:.0f}/{TIEMPO_CONFIRMACION:.0f}s",
            end="\r",
        )
    else:
        print(f"   {icono} {estado_texto.upper():24s}", end="\r")


def aplicar_resultado(resultado, estado_memoria):
    if resultado.get("ok") and resultado.get("estado"):
        return resultado["estado"]
    return estado_memoria


def iniciar_puente():
    imprimir_banner()

    while True:
        arduino = None
        conn = None

        try:
            puerto = SERIAL_PORT or detectar_puerto_arduino()
            if not puerto:
                print("\n[ERROR] No se pudo encontrar el Arduino. Reintentando en 3s...")
                time.sleep(3)
                continue

            print("\n[DB] Conectando a la base de datos...")
            conn = conectar_db()
            if not conn:
                print("\n[ERROR] Sin base de datos. Reintentando en 3s...")
                time.sleep(3)
                continue

            print(f"\n[SENSOR] Buscando espacio para sensor: {SENSOR_CODIGO}")
            espacio_id = obtener_espacio_id(conn, SENSOR_CODIGO)
            if not espacio_id:
                print("\n[ERROR] Sensor no registrado en BD. Reintentando en 3s...")
                time.sleep(3)
                continue

            print(f"\n[SERIAL] Conectando al Arduino en {puerto} @ {BAUD_RATE} baud...")
            arduino = serial.Serial(puerto, BAUD_RATE, timeout=1)
            preparar_arduino(arduino)
            print(f"   [OK] Arduino conectado en {puerto}")

            estado_db_actual = obtener_estado_actual_db(conn, espacio_id)
            tiempo_inicio_deteccion = None
            ocupado_confirmado = estado_db_actual == "ocupado"
            lecturas_error = 0
            lecturas_recuperacion = 0
            ultimo_estado_sensor = None
            ultimo_estado_valido = time.time()

            print(f"\n   Estado actual en BD: {estado_db_actual}")
            print(f"   Confirmacion ocupado: {TIEMPO_CONFIRMACION:.0f}s")
            print(f"   Error sensor: {UMBRAL_ERROR} lecturas consecutivas")
            print(f"   Recuperacion de no operativo: {UMBRAL_RECUPERACION} lecturas normales")
            print(f"   Reinicio automatico serial si no hay lecturas: {SERIAL_STALE_TIMEOUT:.0f}s")
            print("\n" + "-" * 60)
            print("   Monitoreando sensor en tiempo real...")
            print("   Presiona Ctrl+C para detener")
            print("-" * 60 + "\n")

            while True:
                if arduino.in_waiting <= 0:
                    if time.time() - ultimo_estado_valido > SERIAL_STALE_TIMEOUT:
                        raise serial.SerialException(
                            "Sin lecturas ESTADO validas desde el Arduino"
                        )
                    time.sleep(0.1)
                    continue

                try:
                    linea = arduino.readline().decode("utf-8", errors="ignore").strip()
                except UnicodeDecodeError:
                    continue

                if not linea.startswith("ESTADO:"):
                    continue

                try:
                    estado_num = int(linea.split(":", 1)[1])
                except (ValueError, IndexError):
                    continue

                if estado_num not in ESTADOS:
                    continue

                ultimo_estado_valido = time.time()

                if estado_num != ultimo_estado_sensor:
                    print(f"\n   [SENSOR] Lectura recibida: {ESTADOS[estado_num]}")
                    ultimo_estado_sensor = estado_num

                ahora = time.time()

                if estado_num == 2:
                    tiempo_inicio_deteccion = None
                    ocupado_confirmado = False
                    lecturas_recuperacion = 0
                    lecturas_error += 1

                    if estado_db_actual == "no operativo":
                        imprimir_estado(2, "NO OPERATIVO")
                        continue

                    imprimir_estado(2, f"ERROR ({min(lecturas_error, UMBRAL_ERROR)}/{UMBRAL_ERROR})")
                    if lecturas_error >= UMBRAL_ERROR:
                        resultado = actualizar_estado(conn, espacio_id, "no operativo")
                        estado_db_actual = aplicar_resultado(resultado, estado_db_actual)
                        if resultado.get("changed"):
                            print(
                                f"\n   [AMARILLO] NO OPERATIVO -- Estado confirmado "
                                f"[{datetime.now().strftime('%H:%M:%S')}]"
                            )
                        lecturas_error = UMBRAL_ERROR
                    continue

                lecturas_error = 0

                if estado_num == 0:
                    tiempo_inicio_deteccion = None
                    ocupado_confirmado = False

                    if estado_db_actual == "libre":
                        lecturas_recuperacion = 0
                        imprimir_estado(0, "LIBRE")
                        continue

                    if estado_db_actual == "no operativo":
                        lecturas_recuperacion += 1
                        imprimir_estado(0, f"RECUPERANDO ({lecturas_recuperacion}/{UMBRAL_RECUPERACION})")
                        if lecturas_recuperacion < UMBRAL_RECUPERACION:
                            continue
                    else:
                        lecturas_recuperacion = 0
                        imprimir_estado(0, "LIBRE")

                    resultado = actualizar_estado(conn, espacio_id, "libre")
                    estado_db_actual = aplicar_resultado(resultado, estado_db_actual)
                    if resultado.get("changed"):
                        print(
                            f"\n   [VERDE] LIBRE -- Estado sincronizado en BD "
                            f"[{datetime.now().strftime('%H:%M:%S')}]"
                        )
                    lecturas_recuperacion = 0
                    continue

                if estado_num == 1:
                    lecturas_recuperacion = 0

                    if tiempo_inicio_deteccion is None:
                        tiempo_inicio_deteccion = ahora
                        ocupado_confirmado = estado_db_actual == "ocupado"

                    tiempo_transcurrido = ahora - tiempo_inicio_deteccion

                    if ocupado_confirmado:
                        imprimir_estado(1, "OCUPADO", TIEMPO_CONFIRMACION)
                        continue

                    imprimir_estado(1, "detectando...", tiempo_transcurrido)
                    if tiempo_transcurrido >= TIEMPO_CONFIRMACION:
                        resultado = actualizar_estado(conn, espacio_id, "ocupado")
                        estado_db_actual = aplicar_resultado(resultado, estado_db_actual)
                        if resultado.get("ok") and estado_db_actual == "ocupado":
                            ocupado_confirmado = True
                            if resultado.get("changed"):
                                print(
                                    f"\n   [ROJO] OCUPADO -- Estado sincronizado en BD "
                                    f"[{datetime.now().strftime('%H:%M:%S')}]"
                                )

                time.sleep(0.1)

        except serial.SerialException as exc:
            print(f"\n\n   [!] Conexion perdida con USB: {exc}")
            print("   Reintentando en 3 segundos...")
            time.sleep(3)
        except (psycopg2.OperationalError, psycopg2.InterfaceError) as exc:
            print(f"\n\n   [!] Conexion perdida con PostgreSQL: {exc}")
            print("   Reintentando en 3 segundos...")
            time.sleep(3)
        except KeyboardInterrupt:
            print("\n\n" + "=" * 60)
            print("   [STOP] Monitoreo detenido por el usuario")
            print("=" * 60)
            break
        except Exception as exc:
            print(f"\n\n   [ERROR] Error inesperado: {exc}")
            print("   Reintentando en 3 segundos...")
            time.sleep(3)
        finally:
            if arduino and arduino.is_open:
                arduino.close()
                print("   [CLEANUP] Puerto serial cerrado.")
            if conn and not conn.closed:
                conn.close()
                print("   [CLEANUP] Conexion BD cerrada.")


if __name__ == "__main__":
    iniciar_puente()
