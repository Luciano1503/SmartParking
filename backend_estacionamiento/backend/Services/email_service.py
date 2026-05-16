import os
import smtplib
from email.mime.text import MIMEText

REMITENTE = os.getenv("SMTP_EMAIL", "smartparkingsolutions0@gmail.com")
CLAVE = os.getenv("SMTP_APP_PASSWORD")


def _login_smtp(server: smtplib.SMTP_SSL):
    if not CLAVE:
        raise RuntimeError("Falta SMTP_APP_PASSWORD en las variables de entorno.")
    server.login(REMITENTE, CLAVE)


def enviar_codigo(correo: str, codigo: str):
    mensaje = f"""
    ¡Bienvenido a SmartParking Solutions! 🚗✨

    Para continuar con tu registro, utiliza el siguiente código de verificación:

    👉 {codigo}

    Este código expira en 10 minutos.
    """
    msg = MIMEText(mensaje, "plain", "utf-8")
    msg["Subject"] = "SmartParking - Código de verificación"
    msg["From"] = REMITENTE
    msg["To"] = correo

    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
        _login_smtp(server)
        server.sendmail(REMITENTE, [correo], msg.as_string())


def enviar_aviso_empresa(correo: str):
    mensaje = """
    ¡Hola! 👋✨

    Tu solicitud para crear una cuenta de modo empresa en SmartParking Solutions ya está en proceso de ser gestionada.

    En un plazo máximo de 24 horas podrá tener una respuesta de nuestro soporte técnico. 🚗🏢

    Agradecemos tu paciencia.
    """
    msg = MIMEText(mensaje, "plain", "utf-8")
    msg["Subject"] = "SmartParking - Solicitud de Empresa en Proceso"
    msg["From"] = REMITENTE
    msg["To"] = correo

    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
        _login_smtp(server)
        server.sendmail(REMITENTE, [correo], msg.as_string())


def enviar_confirmacion_aprobacion(correo: str):
    mensaje = """
    ¡Buenas noticias! 🚗✨
    Tu solicitud empresarial en SmartParking Solutions ha sido APROBADA.
    Ya puedes iniciar sesión con tu correo y contraseña corporativa en nuestro portal web para configurar tu estacionamiento.
    """
    msg = MIMEText(mensaje, "plain", "utf-8")
    msg["Subject"] = "SmartParking - Cuenta Activada"
    msg["From"] = REMITENTE
    msg["To"] = correo

    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
        _login_smtp(server)
        server.sendmail(REMITENTE, [correo], msg.as_string())


def enviar_rechazo_empresa(correo: str):
    mensaje = """
    Hola,
    Lamentamos informarte que tu solicitud empresarial en SmartParking Solutions no ha sido aprobada en esta ocasión debido a que no cumple con nuestros criterios de validación.
    Si consideras que es un error, por favor contáctanos.
    """
    msg = MIMEText(mensaje, "plain", "utf-8")
    msg["Subject"] = "SmartParking - Actualización de Solicitud"
    msg["From"] = REMITENTE
    msg["To"] = correo

    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
        _login_smtp(server)
        server.sendmail(REMITENTE, [correo], msg.as_string())
