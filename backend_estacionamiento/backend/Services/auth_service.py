import random
from datetime import datetime, timedelta

from Database.session import db_cursor
from Repositories.auth_repository import AuthRepository
from Services.email_service import (
    enviar_aviso_empresa,
    enviar_codigo,
)
from Services.security_service import SecurityService


class AuthService:
    @staticmethod
    def registrar_usuario(correo: str):
        codigo = str(random.randint(100000, 999999))
        expiracion = datetime.now() + timedelta(minutes=10)

        with db_cursor() as (_, cur):
            registro_existente = AuthRepository.find_user_verification_state(cur, correo)

            if registro_existente and registro_existente["verificado"]:
                raise ValueError("Este correo ya se encuentra registrado y verificado.")

            usuario_id = (
                registro_existente["id"]
                if registro_existente
                else AuthRepository.create_user(cur, correo)
            )
            AuthRepository.replace_verification_code(cur, usuario_id, codigo, expiracion)

        enviar_codigo(correo, codigo)
        return {
            "mensaje": "Usuario registrado. Código enviado al correo.",
            "id": usuario_id,
        }

    @staticmethod
    def verificar_usuario(correo: str, codigo: str):
        with db_cursor() as (_, cur):
            registro = AuthRepository.find_verification_record(cur, correo, codigo)

            if not registro:
                raise ValueError("Código inválido")

            if datetime.now() > registro["expiracion"]:
                raise ValueError("El código ha expirado")

            AuthRepository.mark_user_verified(cur, registro["usuario_id"])

        return {"mensaje": "Usuario verificado correctamente"}

    @staticmethod
    def completar_formulario(data):
        try:
            with db_cursor() as (_, cur):
                usuario = AuthRepository.find_verified_user_id(cur, data.correo)
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

            return {"mensaje": "Perfil completado y contraseña creada"}
        except Exception as exc:
            return {"error": str(exc)}

    @staticmethod
    def login_usuario(correo: str, contrasenia: str):
        try:
            with db_cursor() as (_, cur):
                usuario = AuthRepository.find_login_user(cur, correo)
                if not usuario:
                    return {"error": "Usuario no existe"}

                if not usuario["verificado"]:
                    return {"error": "Usuario no verificado"}

                if not SecurityService.verify_password(contrasenia, usuario["contrasenia"]):
                    return {"error": "Contraseña incorrecta"}

                perfil = AuthRepository.find_profile(cur, usuario["id"])
                if not perfil:
                    return {"error": "Perfil no encontrado"}

            return {
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
            with db_cursor() as (_, cur):
                usuario_id = AuthRepository.create_company_user(
                    cur,
                    data.correo,
                    SecurityService.hash_password(data.contrasenia),
                )
                AuthRepository.create_company_profile(
                    cur,
                    usuario_id,
                    data.nombre_representante,
                    data.apellido_representante,
                )
                AuthRepository.create_company(cur, data.nombre_empresa, usuario_id)

            correo_enviado = True
            detalle_correo = None
            try:
                enviar_aviso_empresa(data.correo)
            except Exception as email_error:
                correo_enviado = False
                detalle_correo = str(email_error)
                print(f"Registro exitoso, pero fallo el envio del correo: {email_error}")

            return {
                "status": "success",
                "mensaje": "Solicitud enviada. Su cuenta sera revisada por un administrador en 24h.",
                "correo_enviado": correo_enviado,
                "detalle_correo": detalle_correo,
            }
        except Exception as exc:
            print(f"Error crítico en registro empresarial: {exc}")
            return {"status": "error", "detalle": str(exc)}

    @staticmethod
    def login_web(correo: str, contrasenia: str):
        try:
            with db_cursor() as (_, cur):
                usuario = AuthRepository.find_web_login_user(cur, correo)
                if not usuario:
                    return {"error": "Usuario no existe"}

                if usuario["tipo"] not in ["admin", "empresa"]:
                    return {
                        "error": "Acceso denegado: Plataforma exclusiva para empresas y administradores."
                    }

                if usuario["tipo"] != "admin" and not usuario["verificado"]:
                    return {"error": "Su cuenta de empresa aún no ha sido verificada."}

                if not SecurityService.verify_password(contrasenia, usuario["contrasenia"]):
                    return {"error": "Contraseña incorrecta"}

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
