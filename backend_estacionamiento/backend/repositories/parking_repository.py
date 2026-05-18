class ParkingRepository:
    @staticmethod
    def list_parking_lots(cur):
        cur.execute(
            """
            SELECT
                e.id,
                e.nombre,
                e.descripcion,
                e.direccion,
                e.imagen_url,
                (
                    SELECT COUNT(*)
                    FROM nivel n
                    JOIN zona z ON z.nivel_id = n.id
                    JOIN espacio esp ON esp.zona_id = z.id
                    WHERE n.estacionamiento_id = e.id
                ) AS total_espacios
            FROM estacionamiento e
            ORDER BY e.id DESC;
            """
        )
        return cur.fetchall()

    @staticmethod
    def count_spaces(cur) -> int:
        cur.execute("SELECT COUNT(*) AS total FROM espacio;")
        return cur.fetchone()["total"]

    @staticmethod
    def create_parking_lot(
        cur,
        nombre: str,
        direccion: str,
        descripcion: str,
        imagen_url,
        latitud: float,
        longitud: float,
        empresa_id: int,
    ) -> int:
        cur.execute(
            """
            INSERT INTO estacionamiento
                (nombre, direccion, descripcion, imagen_url, latitud, longitud, empresa_id)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            RETURNING id;
            """,
            (nombre, direccion, descripcion, imagen_url, latitud, longitud, empresa_id),
        )
        return cur.fetchone()["id"]

    @staticmethod
    def create_level(cur, estacionamiento_id: int, nombre: str, numero: int, columnas: int, filas: int) -> int:
        cur.execute(
            """
            INSERT INTO nivel (estacionamiento_id, nombre, numero, columnas, filas)
            VALUES (%s, %s, %s, %s, %s)
            RETURNING id;
            """,
            (estacionamiento_id, nombre, numero, columnas, filas),
        )
        return cur.fetchone()["id"]

    @staticmethod
    def create_zone(cur, nivel_id: int, nombre: str) -> int:
        cur.execute(
            "INSERT INTO zona (nivel_id, nombre) VALUES (%s, %s) RETURNING id;",
            (nivel_id, nombre),
        )
        return cur.fetchone()["id"]

    @staticmethod
    def create_space(cur, zona_id: int, codigo: str, sensor_codigo: str) -> int:
        cur.execute(
            """
            INSERT INTO espacio (zona_id, codigo, sensor_codigo, estado_actual)
            VALUES (%s, %s, %s, 'libre')
            RETURNING id;
            """,
            (zona_id, codigo, sensor_codigo),
        )
        return cur.fetchone()["id"]

    @staticmethod
    def create_initial_status(cur, espacio_id: int):
        cur.execute(
            "INSERT INTO registro_estado (espacio_id, estado) VALUES (%s, 'libre');",
            (espacio_id,),
        )

    @staticmethod
    def list_levels(cur, estacionamiento_id: int):
        cur.execute(
            """
            SELECT id, nombre, numero, columnas, filas
            FROM nivel
            WHERE estacionamiento_id = %s
            ORDER BY numero;
            """,
            (estacionamiento_id,),
        )
        return cur.fetchall()

    @staticmethod
    def list_zones(cur, nivel_id: int):
        cur.execute(
            "SELECT id, nombre FROM zona WHERE nivel_id = %s;",
            (nivel_id,),
        )
        return cur.fetchall()

    @staticmethod
    def list_spaces(cur, zona_id: int):
        cur.execute(
            """
            SELECT id, codigo, estado_actual
            FROM espacio
            WHERE zona_id = %s
            ORDER BY codigo;
            """,
            (zona_id,),
        )
        return cur.fetchall()

    @staticmethod
    def find_space_by_sensor(cur, sensor_codigo: str, lock: bool = False):
        lock_clause = "FOR UPDATE OF e" if lock else ""
        cur.execute(
            f"""
            SELECT
                e.id AS espacio_id,
                e.codigo,
                e.estado_actual,
                e.sensor_codigo,
                est.id AS estacionamiento_id
            FROM espacio e
            JOIN zona z ON e.zona_id = z.id
            JOIN nivel n ON z.nivel_id = n.id
            JOIN estacionamiento est ON n.estacionamiento_id = est.id
            WHERE e.sensor_codigo = %s
            {lock_clause};
            """,
            (sensor_codigo,),
        )
        return cur.fetchone()

    @staticmethod
    def list_sensors(cur):
        cur.execute(
            """
            SELECT
                e.sensor_codigo,
                e.id AS espacio_id,
                e.codigo AS espacio,
                e.estado_actual,
                z.nombre AS zona,
                n.nombre AS nivel,
                est.nombre AS estacionamiento
            FROM espacio e
            JOIN zona z ON e.zona_id = z.id
            JOIN nivel n ON z.nivel_id = n.id
            JOIN estacionamiento est ON n.estacionamiento_id = est.id
            WHERE e.sensor_codigo IS NOT NULL
              AND TRIM(e.sensor_codigo) <> ''
            ORDER BY e.sensor_codigo
            LIMIT 300;
            """
        )
        return cur.fetchall()

    @staticmethod
    def update_space_status(cur, espacio_id: int, nuevo_estado: str, fecha):
        cur.execute(
            """
            UPDATE espacio
            SET estado_actual = %s, ultimo_update = %s
            WHERE id = %s;
            """,
            (nuevo_estado, fecha, espacio_id),
        )

    @staticmethod
    def create_open_movement(cur, espacio_id: int, fecha):
        cur.execute(
            """
            INSERT INTO movimiento_estacionamiento
                (espacio_id, fecha_inicio, metodo_deteccion, confirmado, confianza)
            SELECT %s, %s, 'auto', TRUE, 1.0
            WHERE NOT EXISTS (
                SELECT 1
                FROM movimiento_estacionamiento
                WHERE espacio_id = %s AND fecha_fin IS NULL
            );
            """,
            (espacio_id, fecha, espacio_id),
        )
        return cur.rowcount

    @staticmethod
    def close_open_movement(cur, espacio_id: int, fecha):
        cur.execute(
            """
            UPDATE movimiento_estacionamiento
            SET fecha_fin = %s,
                duracion = %s - fecha_inicio
            WHERE espacio_id = %s AND fecha_fin IS NULL;
            """,
            (fecha, fecha, espacio_id),
        )
        return cur.rowcount

    @staticmethod
    def update_last_status_record(cur, espacio_id: int, nuevo_estado: str, fecha):
        cur.execute(
            """
            UPDATE registro_estado
            SET estado = %s, fecha = %s
            WHERE id = (
                SELECT id
                FROM registro_estado
                WHERE espacio_id = %s
                ORDER BY id DESC
                LIMIT 1
            );
            """,
            (nuevo_estado, fecha, espacio_id),
        )
        return cur.rowcount

    @staticmethod
    def create_status_record(cur, espacio_id: int, nuevo_estado: str, fecha):
        cur.execute(
            """
            INSERT INTO registro_estado (espacio_id, estado, fecha)
            VALUES (%s, %s, %s);
            """,
            (espacio_id, nuevo_estado, fecha),
        )
