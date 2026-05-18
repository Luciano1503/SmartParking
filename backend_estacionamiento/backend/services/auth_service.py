import random
import re
from datetime import datetime, timedelta

from database.session import db_cursor
from repositories.auth_repository import AuthRepository
from services.email_service import enviar_aviso_empresa, enviar_codigo
from services.security_service import SecurityService


class AuthService:
    @staticmethod
    def _normalizar_correo(correo: str) -> str:
        return (correo or "").strip().lower()

    @staticmethod
    def _validar_correo(correo: str) -> None:
        if not re.fullmatch(r"[^@\s]+@[^@\s]+\.[^@\s]+", correo):
            raise ValueError("Ingresa un correo valido.")

    @staticmethod
    def _validar_contrasenia(contrasenia: str) -> None:
        if len(contrasenia or "") < 8:
            raise ValueError("La contrasena debe tener minimo 8 caracteres.")
        if not re.search(r"[A-Za-z]", contrasenia) or not re.search(r"\d", contrasenia):
            raise ValueError("La contrasena debe incluir letras y numeros.")

    @staticmethod
    def registrar_usuario(correo: str):
        correo = AuthService._normalizar_correo(correo)
        AuthService._validar_correo(correo)

        codigo = str(random.randint(100000, 999999))
        expiracion = datetime.now() + timedelta(minutes=10)

        with db_cursor() as (_, cur):
            registro_existente = AuthRepository.find_user_verification_state(cur, correo)

            if registro_existente and registro_existente["tipo"] == "empresa":
                raise ValueError("Este correo ya esta vinculado a una cuenta empresarial.")

            if registro_existente and registro_existente["verificado"]:
                raise ValueError("Este correo ya se encuentra registrado y verificado.")

            usuario_id = (
                registro_existente["id"]
                if registro_existente
                else AuthRepository.create_user(cur, correo)
            )
            AuthRepository.replace_verification_code(cur, usuario_id, codigo, expiracion)

        try:
            enviar_codigo(correo, codigo)
        except Exception as exc:
            print(f"No se pudo enviar codigo de verificacion a {correo}: {exc}")
            raise RuntimeError(
                "No se pudo enviar el codigo al correo. Revisa el correo ingresado o intenta nuevamente."
            ) from exc

        return {
            "status": "success",
            "mensaje": "Usuario registrado. Codigo enviado al correo.",
            "id": usuario_id,
            "correo_enviado": True,
        }

    @staticmethod
    def verificar_usuario(correo: str, codigo: str):
        correo = AuthService._normalizar_correo(correo)
        with db_cursor() as (_, cur):
            registro = AuthRepository.find_verification_record(cur, correo, codigo)

            if not registro:
                raise ValueError("Codigo invalido")

            if datetime.now() > registro["expiracion"]:
                raise ValueError("El codigo ha expirado")

            AuthRepository.mark_user_verified(cur, registro["usuario_id"])

        return {"status": "success", "mensaje": "Usuario verificado correctamente"}

    @staticmethod
    def completar_formulario(data):
        try:
            correo = AuthService._normalizar_correo(data.correo)
            AuthService._validar_contrasenia(data.contrasenia)

            with db_cursor() as (_, cur):
                usuario = AuthRepository.find_verified_user_id(cur, correo)
                if not usuario:
                    return {"error": "Usuario no verificado"}

                usuario_id = usuario["id"]
                AuthRepository.update_password(
                    cur,
                    usuario_id,
                    SecurityService.hash_password(data.contrasenia),
                )
                AuthRepository.create_profile(
                    cur,
                    usuario_id,
                    data.nombre,
                    data.apellido,
                    data.telefono,
                    data.dni,
                    data.fecha_nacimiento,
                    data.placa,
                    data.modelo,
                )

            return {"status": "success", "mensaje": "Perfil completado y contrasena creada"}
        except Exception as exc:
            return {"error": str(exc)}

    @staticmethod
    def login_usuario(correo: str, contrasenia: str):
        try:
            correo = AuthService._normalizar_correo(correo)
            with db_cursor() as (_, cur):
                usuario = AuthRepository.find_login_user(cur, correo)
                if not usuario:
                    return {"error": "Usuario no existe"}

                if not usuario["verificado"]:
                    return {"error": "Usuario no verificado"}

                if not SecurityService.verify_password(contrasenia, usuario["contrasenia"]):
                    return {"error": "Contrasena incorrecta"}

                perfil = AuthRepository.find_profile(cur, usuario["id"])
                if not perfil:
                    return {"error": "Perfil no encontrado"}

            return {
                "status": "success",
                "mensaje": "Login exitoso",
                "correo": correo,
                "nombre": perfil["nombre"],
                "apellido": perfil["apellido"],
                "telefono": perfil["telefono"],
                "dni": perfil["dni"],
                "fecha_nacimiento": str(perfil["fecha_nacimiento"]),
                "placa": perfil["placa"],
                "modelo": perfil["modelo"],
            }
        except Exception as exc:
            return {"error": str(exc)}

    @staticmethod
    def registrar_empresa(data):
        try:
            correo = AuthService._normalizar_correo(str(data.correo))
            AuthService._validar_correo(correo)
            AuthService._validar_contrasenia(data.contrasenia)

            with db_cursor() as (_, cur):
                usuario_existente = AuthRepository.find_user_account(cur, correo)
                if usuario_existente:
                    tipo = usuario_existente["tipo"]
                    verificado = usuario_existente["verificado"]
                    if tipo == "empresa" and not verificado:
                        raise ValueError(
                            "Este correo ya tiene una solicitud empresarial pendiente de evaluacion."
                        )
                    if tipo == "empresa":
                        raise ValueError("Este correo ya esta vinculado a una empresa.")
                    if tipo == "admin":
                        raise ValueError("Este correo pertenece a un administrador.")
                    raise ValueError(
                        "Este correo ya esta registrado como usuario de la app. Usa otro correo corporativo."
                    )

                usuario_id = AuthRepository.create_company_user(
                    cur,
                    correo,
                    SecurityService.hash_password(data.contrasenia),
                )
                AuthRepository.create_company_profile(
                    cur,
                    usuario_id,
                    data.nombre_representante,
                    data.apellido_representante,
                )
                AuthRepository.create_company(cur, data.nombre_empresa, usuario_id)

            try:
                enviar_aviso_empresa(correo)
            except Exception as email_error:
                print(f"Registro exitoso, pero fallo el envio del correo: {email_error}")
                return {
                    "status": "success",
                    "mensaje": "Solicitud registrada. No se pudo enviar el correo de aviso, pero tu solicitud quedo pendiente de evaluacion.",
                    "correo_enviado": False,
                    "detalle_correo": str(email_error),
                }

            return {
                "status": "success",
                "mensaje": "Solicitud enviada. Su cuenta sera revisada por un administrador en 24h.",
                "correo_enviado": True,
                "detalle_correo": None,
            }
        except ValueError as exc:
            return {"status": "error", "detalle": str(exc)}
        except Exception as exc:
            print(f"Error critico en registro empresarial: {exc}")
            return {"status": "error", "detalle": str(exc)}

    @staticmethod
    def login_web(correo: str, contrasenia: str):
        try:
            correo = AuthService._normalizar_correo(correo)
            with db_cursor() as (_, cur):
                usuario = AuthRepository.find_web_login_user(cur, correo)
                if not usuario:
                    return {"error": "Usuario no existe"}

                if usuario["tipo"] not in ["admin", "empresa"]:
                    return {
                        "error": "Acceso denegado: Plataforma exclusiva para empresas y administradores."
                    }

                if usuario["tipo"] != "admin" and not usuario["verificado"]:
                    return {"error": "Su cuenta de empresa aun no ha sido verificada."}

                if not SecurityService.verify_password(contrasenia, usuario["contrasenia"]):
                    return {"error": "Contrasena incorrecta"}

                perfil = AuthRepository.find_profile(cur, usuario["id"])
                empresa_id = AuthRepository.find_company_id(cur, usuario["id"])

            return {
                "status": "success",
                "tipo": usuario["tipo"],
                "correo": correo,
                "nombre": perfil["nombre"] if perfil else "Admin",
                "empresa_id": empresa_id,
            }
        except Exception as exc:
            return {"error": str(exc)}
