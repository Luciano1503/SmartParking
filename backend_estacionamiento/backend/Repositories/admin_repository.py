class AdminRepository:
    @staticmethod
    def list_pending_companies(cur):
        cur.execute(
            """
            SELECT
                u.id,
                u.correo,
                COALESCE(e.nombre, 'Sin empresa registrada') AS empresa,
                COALESCE(p.nombre, 'Sin representante') AS representante
            FROM usuarios u
            LEFT JOIN empresa e ON u.id = e.usuario_id
            LEFT JOIN perfil_usuario p ON u.id = p.usuario_id
            WHERE u.verificado IS FALSE AND TRIM(u.tipo) = 'empresa';
            """
        )
        return cur.fetchall()

    @staticmethod
    def find_user_email(cur, usuario_id: int):
        cur.execute("SELECT correo FROM usuarios WHERE id = %s;", (usuario_id,))
        row = cur.fetchone()
        return row["correo"] if row else None

    @staticmethod
    def approve_company(cur, usuario_id: int):
        cur.execute(
            "UPDATE usuarios SET verificado = TRUE WHERE id = %s;",
            (usuario_id,),
        )

    @staticmethod
    def reject_company(cur, usuario_id: int):
        cur.execute("DELETE FROM usuarios WHERE id = %s;", (usuario_id,))

    @staticmethod
    def list_inoperative_sensors(cur):
        cur.execute(
            """
            SELECT
                e.id,
                est.nombre AS estacionamiento,
                est.direccion,
                n.nombre AS nivel,
                z.nombre AS zona,
                e.codigo AS espacio,
                e.sensor_codigo AS codigo_hardware
            FROM espacio e
            JOIN zona z ON e.zona_id = z.id
            JOIN nivel n ON z.nivel_id = n.id
            JOIN estacionamiento est ON n.estacionamiento_id = est.id
            WHERE LOWER(TRIM(e.estado_actual)) = 'no operativo';
            """
        )
        return cur.fetchall()
