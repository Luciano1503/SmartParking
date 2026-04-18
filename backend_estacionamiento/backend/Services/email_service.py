import smtplib
from email.mime.text import MIMEText

def enviar_codigo(correo: str, codigo: str):
    remitente = "smartparkingsolutions0@gmail.com"
    clave = "mlsb xowl yecf xuap"  # contraseña de aplicación

    mensaje = f"""
    ¡Bienvenido a SmartParking Solutions! 🚗✨

    Para continuar con tu registro, utiliza el siguiente código de verificación:

    👉 {codigo}

    Este código expira en 10 minutos.
    """

    msg = MIMEText(mensaje, "plain", "utf-8")
    msg["Subject"] = "SmartParking - Código de verificación"
    msg["From"] = remitente
    msg["To"] = correo

    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
        server.login(remitente, clave)
        server.sendmail(remitente, [correo], msg.as_string())
