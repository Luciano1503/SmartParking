class AuthRepository:
    @staticmethod
    def find_user_verification_state(cur, correo: str):
        cur.execute(
            "SELECT id, verificado, tipo FROM usuarios WHERE correo = %s;",
            (correo,),
        )
        return cur.fetchone()

    @staticmethod
    def find_user_account(cur, correo: str):
        cur.execute(
            "SELECT id, verificado, tipo FROM usuarios WHERE correo = %s;",
            (correo,),
        )
        return cur.fetchone()

    @staticmethod
    def create_user(cur, correo: str) -> int:
        cur.execute(
            "INSERT INTO usuarios (correo) VALUES (%s) RETURNING id;",
            (correo,),
        )
        return cur.fetchone()["id"]

    @staticmethod
    def replace_verification_code(cur, usuario_id: int, codigo: str, expiracion):
        cur.execute("DELETE FROM verificacion WHERE usuario_id = %s;", (usuario_id,))
        cur.execute(
            """
            INSERT INTO verificacion (usuario_id, codigo, expiracion)
            VALUES (%s, %s, %s);
            """,
            (usuario_id, codigo, expiracion),
        )

    @staticmethod
    def find_verification_record(cur, correo: str, codigo: str):
        cur.execute(
            """
            SELECT v.id, v.expiracion, u.id AS usuario_id
            FROM verificacion v
            JOIN usuarios u ON v.usuario_id = u.id
            WHERE u.correo = %s AND v.codigo = %s;
            """,
            (correo, codigo),
        )
        return cur.fetchone()

    @staticmethod
    def mark_user_verified(cur, usuario_id: int):
        cur.execute(
            "UPDATE usuarios SET verificado = TRUE WHERE id = %s;",
            (usuario_id,),
        )

    @staticmethod
    def find_verified_user_id(cur, correo: str):
        cur.execute(
            "SELECT id FROM usuarios WHERE correo = %s AND verificado = TRUE;",
            (correo,),
        )
        return cur.fetchone()

    @staticmethod
    def update_password(cur, usuario_id: int, password_hash: str):
        cur.execute(
            "UPDATE usuarios SET contrasenia = %s WHERE id = %s;",
            (password_hash, usuario_id),
        )

    @staticmethod
    def create_profile(
        cur,
        usuario_id: int,
        nombre: str,
        apellido: str,
        telefono: str,
        dni: str,
        fecha_nacimiento: str,
        placa: str,
        modelo: str,
    ):
        cur.execute(
            """
            INSERT INTO perfil_usuario
                (usuario_id, nombre, apellido, telefono, dni, fecha_nacimiento, placa, modelo)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s);
            """,
            (
                usuario_id,
                nombre,
                apellido,
                telefono,
                dni,
                fecha_nacimiento,
                placa,
                modelo,
            ),
        )

    @staticmethod
    def find_login_user(cur, correo: str):
        cur.execute(
            "SELECT id, contrasenia, verificado FROM usuarios WHERE correo = %s;",
            (correo,),
        )
        return cur.fetchone()

    @staticmethod
    def find_profile(cur, usuario_id: int):
        cur.execute(
            """
            SELECT nombre, apellido, telefono, dni, fecha_nacimiento, placa, modelo
            FROM perfil_usuario
            WHERE usuario_id = %s;
            """,
            (usuario_id,),
        )
        return cur.fetchone()

    @staticmethod
    def create_company_user(cur, correo: str, password_hash: str) -> int:
        cur.execute(
            """
            INSERT INTO usuarios (correo, contrasenia, tipo, verificado)
            VALUES (%s, %s, 'empresa', FALSE)
            RETURNING id;
            """,
            (correo, password_hash),
        )
        return cur.fetchone()["id"]

    @staticmethod
    def create_company_profile(cur, usuario_id: int, nombre: str, apellido: str):
        cur.execute(
            """
            INSERT INTO perfil_usuario (usuario_id, nombre, apellido)
            VALUES (%s, %s, %s);
            """,
            (usuario_id, nombre, apellido),
        )

    @staticmethod
    def create_company(cur, nombre: str, usuario_id: int):
        cur.execute(
            """
            INSERT INTO empresa (nombre, usuario_id)
            VALUES (%s, %s);
            """,
            (nombre, usuario_id),
        )

    @staticmethod
    def find_web_login_user(cur, correo: str):
        cur.execute(
            """
            SELECT id, contrasenia, verificado, tipo
            FROM usuarios
            WHERE correo = %s;
            """,
            (correo,),
        )
        return cur.fetchone()

    @staticmethod
    def find_company_id(cur, usuario_id: int):
        cur.execute(
            "SELECT id FROM empresa WHERE usuario_id = %s;",
            (usuario_id,),
        )
        row = cur.fetchone()
        return row["id"] if row else None
