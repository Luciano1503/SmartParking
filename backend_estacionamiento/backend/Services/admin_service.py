from Database.session import db_cursor
from Repositories.admin_repository import AdminRepository
from Services.email_service import (
    enviar_confirmacion_aprobacion,
    enviar_rechazo_empresa,
)


class AdminService:
    @staticmethod
    def listar_pendientes():
        try:
            with db_cursor() as (_, cur):
                return AdminRepository.list_pending_companies(cur)
        except Exception as exc:
            return {"error": str(exc)}

    @staticmethod
    def aprobar_empresa(usuario_id: int, accion: str):
        try:
            with db_cursor() as (_, cur):
                correo = AdminRepository.find_user_email(cur, usuario_id)
                if not correo:
                    return {"error": "Usuario no encontrado"}

                if accion == "aprobar":
                    AdminRepository.approve_company(cur, usuario_id)
                    mensaje = "Empresa aprobada exitosamente."
                    email_sender = enviar_confirmacion_aprobacion
                else:
                    AdminRepository.reject_company(cur, usuario_id)
                    mensaje = "Solicitud rechazada y datos eliminados."
                    email_sender = enviar_rechazo_empresa

            try:
                email_sender(correo)
            except Exception as email_error:
                print(f"Error al enviar correo de {accion}: {email_error}")

            return {"mensaje": mensaje}
        except Exception as exc:
            return {"error": str(exc)}

    @staticmethod
    def listar_sensores_inoperativos():
        try:
            with db_cursor() as (_, cur):
                sensores = AdminRepository.list_inoperative_sensors(cur)

            print(f"Sensores inoperativos encontrados: {len(sensores)}")
            return sensores
        except Exception as exc:
            print(f"Error en listar_sensores_inoperativos: {exc}")
            return {"error": str(exc)}
