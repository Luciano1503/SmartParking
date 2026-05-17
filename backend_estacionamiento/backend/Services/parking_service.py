from Database.session import db_cursor
from Repositories.parking_repository import ParkingRepository


class ParkingService:
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
                    zona_id = ParkingRepository.create_zone(cur, nivel_id, f"Zona {division.id}")

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

        return {"status": "success", "message": "Configuración guardada exitosamente"}

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
