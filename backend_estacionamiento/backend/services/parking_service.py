from datetime import datetime

from database.session import db_cursor
from repositories.parking_repository import ParkingRepository


class ParkingService:
    VALID_SENSOR_STATES = {"libre", "ocupado", "no operativo"}

    @staticmethod
    def _normalizar_estado(estado: str) -> str:
        return (estado or "").strip().lower().replace("_", " ")

    @staticmethod
    def listar_estacionamientos():
        with db_cursor() as (_, cur):
            return ParkingRepository.list_parking_lots(cur)

    @staticmethod
    def configurar_estacionamiento(config):
        with db_cursor() as (_, cur):
            contador_sensor = ParkingRepository.count_spaces(cur) + 1
            estacionamiento_id = ParkingRepository.create_parking_lot(
                cur,
                config.nombre,
                config.direccion,
                config.descripcion,
                config.imagen_url,
                config.latitud,
                config.longitud,
                config.empresa_id,
            )

            for index, piso_data in enumerate(config.pisos, start=1):
                nivel_id = ParkingRepository.create_level(
                    cur,
                    estacionamiento_id,
                    f"Nivel {index}",
                    index,
                    config.columnas_diseno,
                    config.filas_diseno,
                )

                for division in piso_data.divisiones:
                    zona_id = ParkingRepository.create_zone(
                        cur,
                        nivel_id,
                        f"Zona {division.id}",
                    )

                    for numero_espacio in range(1, division.espacios + 1):
                        codigo_espacio = f"{division.id}{numero_espacio}"
                        sensor_codigo = f"S-{contador_sensor:05d}"
                        contador_sensor += 1

                        espacio_id = ParkingRepository.create_space(
                            cur,
                            zona_id,
                            codigo_espacio,
                            sensor_codigo,
                        )
                        ParkingRepository.create_initial_status(cur, espacio_id)

        return {"status": "success", "message": "Configuracion guardada exitosamente"}

    @staticmethod
    def detalle_mapa(estacionamiento_id: int):
        with db_cursor() as (_, cur):
            niveles = ParkingRepository.list_levels(cur, estacionamiento_id)
            resultado = []

            for nivel in niveles:
                zonas_list = []
                zonas = ParkingRepository.list_zones(cur, nivel["id"])

                for zona in zonas:
                    espacios = ParkingRepository.list_spaces(cur, zona["id"])
                    zonas_list.append(
                        {
                            "nombre": zona["nombre"],
                            "espacios": [
                                {
                                    "id": espacio["id"],
                                    "codigo": espacio["codigo"],
                                    "estado_actual": espacio["estado_actual"],
                                }
                                for espacio in espacios
                            ],
                        }
                    )

                resultado.append(
                    {
                        "nivel": nivel["nombre"],
                        "columnas": nivel["columnas"],
                        "filas": nivel["filas"],
                        "zonas": zonas_list,
                    }
                )

            return resultado

    @staticmethod
    def obtener_sensor(sensor_codigo: str):
        with db_cursor() as (_, cur):
            espacio = ParkingRepository.find_space_by_sensor(cur, sensor_codigo)

        if not espacio:
            raise ValueError(f"No existe un espacio con sensor_codigo '{sensor_codigo}'.")

        return {
            "espacio_id": espacio["espacio_id"],
            "codigo": espacio["codigo"],
            "estado_actual": ParkingService._normalizar_estado(espacio["estado_actual"]),
            "sensor_codigo": espacio["sensor_codigo"],
            "estacionamiento_id": espacio["estacionamiento_id"],
        }

    @staticmethod
    def actualizar_estado_sensor(
        sensor_codigo: str,
        estado: str,
        origen: str | None = None,
    ):
        nuevo_estado = ParkingService._normalizar_estado(estado)
        if nuevo_estado not in ParkingService.VALID_SENSOR_STATES:
            raise ValueError("Estado invalido. Usa: libre, ocupado o no operativo.")

        fecha = datetime.now()

        with db_cursor() as (_, cur):
            espacio = ParkingRepository.find_space_by_sensor(cur, sensor_codigo, lock=True)
            if not espacio:
                raise ValueError(f"No existe un espacio con sensor_codigo '{sensor_codigo}'.")

            espacio_id = espacio["espacio_id"]
            estado_actual = ParkingService._normalizar_estado(espacio["estado_actual"])
            changed = estado_actual != nuevo_estado

            if changed:
                ParkingRepository.update_space_status(cur, espacio_id, nuevo_estado, fecha)

                if nuevo_estado == "ocupado":
                    ParkingRepository.create_open_movement(cur, espacio_id, fecha)
                elif nuevo_estado == "libre":
                    ParkingRepository.close_open_movement(cur, espacio_id, fecha)

                updated = ParkingRepository.update_last_status_record(
                    cur,
                    espacio_id,
                    nuevo_estado,
                    fecha,
                )
                if updated == 0:
                    ParkingRepository.create_status_record(
                        cur,
                        espacio_id,
                        nuevo_estado,
                        fecha,
                    )

        return {
            "ok": True,
            "changed": changed,
            "espacio_id": espacio_id,
            "codigo": espacio["codigo"],
            "sensor_codigo": sensor_codigo,
            "estado_anterior": estado_actual,
            "nuevo_estado": nuevo_estado,
            "estacionamiento_id": espacio["estacionamiento_id"],
            "fecha": fecha.isoformat(),
            "origen": origen or "arduino_gateway",
        }
