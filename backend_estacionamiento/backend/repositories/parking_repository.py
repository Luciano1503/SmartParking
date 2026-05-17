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
