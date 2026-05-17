import os
import smtplib
from email.header import Header
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from pathlib import Path
from typing import Iterable

from dotenv import load_dotenv

BACKEND_PATH = Path(__file__).resolve().parents[1]
ROOT_PATH = Path(__file__).resolve().parents[3]
ENV_PATH = ROOT_PATH / ".env"
LOGO_CANDIDATES = [
    BACKEND_PATH / "assets" / "smartparkingEmail.jpg",
    ROOT_PATH
    / "proyectoestacionamiento"
    / "assets"
    / "images"
    / "smartparkingEmail.jpg",
]
LOGO_PATH = next((path for path in LOGO_CANDIDATES if path.exists()), LOGO_CANDIDATES[0])
LOGO_CID = "smartparking-logo"
SMTP_HOST = "smtp.gmail.com"
SMTP_PORT = 465
DEFAULT_SENDER = "smartparkingsolutions0@gmail.com"
DEFAULT_PORTAL_URL = "https://smartparkingsolutions.com"

EMOJI_PARKING = "\U0001F17F\uFE0F"
EMOJI_CHECK = "\u2705"

HTML_PARKING = "&#127359;&#65039;"
HTML_CAR = "&#128663;"
HTML_WAVE = "&#128075;"
HTML_LOCK = "&#128274;"
HTML_CLOCK = "&#9201;&#65039;"
HTML_WARNING = "&#9888;&#65039;"
HTML_PARTY = "&#127881;"
HTML_SYNC = "&#128260;"
HTML_HOURGLASS = "&#9203;"
HTML_HANDSHAKE = "&#129309;"
HTML_CHECK = "&#9989;"
HTML_KEY = "&#128273;"
HTML_PIN = "&#128205;"
HTML_BUILDING = "&#127970;"
HTML_CHART = "&#128202;"
HTML_ROCKET = "&#128640;"
HTML_CROSS = "&#10060;"
HTML_DOC = "&#128196;"
HTML_SEARCH = "&#128269;"
HTML_CLIP = "&#128206;"
HTML_CHAT = "&#128172;"
HTML_RAISED = "&#128588;"
HTML_CONFETTI = "&#127882;"


def _smtp_credentials() -> tuple[str, str]:
    load_dotenv(ENV_PATH, override=True)
    sender = os.getenv("SMTP_EMAIL", DEFAULT_SENDER).strip()
    password = os.getenv("SMTP_APP_PASSWORD", "").strip()

    if not sender:
        raise RuntimeError("Falta SMTP_EMAIL en las variables de entorno.")
    if not password:
        raise RuntimeError("Falta SMTP_APP_PASSWORD en las variables de entorno.")

    return sender, password


def _portal_url() -> str:
    load_dotenv(ENV_PATH, override=True)
    return os.getenv("SMARTPARKING_PORTAL_URL", DEFAULT_PORTAL_URL).strip()


def _attach_logo(msg: MIMEMultipart) -> None:
    if not LOGO_PATH.exists():
        return

    with LOGO_PATH.open("rb") as logo_file:
        logo = MIMEImage(logo_file.read(), _subtype="jpeg")

    logo.add_header("Content-ID", f"<{LOGO_CID}>")
    logo.add_header("Content-Disposition", "inline", filename="smartparking.jpg")
    msg.attach(logo)


def _send_email(recipients: str | Iterable[str], subject: str, html_message: str) -> None:
    sender, password = _smtp_credentials()
    to_list = [recipients] if isinstance(recipients, str) else list(recipients)

    if not to_list:
        raise ValueError("No se indico destinatario para el correo.")

    msg = MIMEMultipart("related")
    msg["Subject"] = Header(subject, "utf-8")
    msg["From"] = sender
    msg["To"] = ", ".join(to_list)

    alternative = MIMEMultipart("alternative")
    alternative.attach(MIMEText(html_message.strip(), "html", "utf-8"))
    msg.attach(alternative)
    _attach_logo(msg)

    with smtplib.SMTP_SSL(SMTP_HOST, SMTP_PORT) as server:
        server.login(sender, password)
        server.sendmail(sender, to_list, msg.as_string())


def _header_html() -> str:
    if LOGO_PATH.exists():
        return f'''
                <tr>
                  <td style="background:#ffffff;padding:22px 32px;text-align:center;border-bottom:1px solid #eef2f7;">
                    <img src="cid:{LOGO_CID}" width="280" alt="SmartParking Solutions" style="display:block;margin:0 auto;width:280px;max-width:92%;height:auto;border:0;outline:none;text-decoration:none;border-radius:8px;">
                  </td>
                </tr>
        '''

    return '''
                <tr>
                  <td style="background:#1a1a2e;padding:28px 32px;text-align:center;">
                    <p style="margin:0;color:#ffffff;font-size:22px;font-weight:bold;letter-spacing:1px;">SmartParking Solutions</p>
                  </td>
                </tr>
    '''


def _email_shell(content: str, footer_title: str = "SmartParking Solutions") -> str:
    return f'''
    <html>
      <body style="margin:0;padding:0;background:#f4f4f4;font-family:Arial,sans-serif;">
        <table width="100%" cellpadding="0" cellspacing="0" style="background:#f4f4f4;padding:32px 0;">
          <tr>
            <td align="center">
              <table width="520" cellpadding="0" cellspacing="0" style="background:#ffffff;border-radius:12px;overflow:hidden;border:1px solid #e0e0e0;">
                {_header_html()}
                {content}
                <tr>
                  <td style="background:#f7f7f7;border-top:1px solid #eeeeee;padding:20px 40px;text-align:center;">
                    <p style="margin:0;font-size:13px;color:#999999;">{HTML_PARKING} <strong>{footer_title}</strong></p>
                    <p style="margin:4px 0 0;font-size:12px;color:#bbbbbb;">{HTML_CAR} Estaciona mas rapido, simple y seguro.</p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </body>
    </html>
    '''


def enviar_codigo(correo: str, codigo: str) -> None:
    content = f'''
    <tr>
      <td style="padding:36px 40px;">
        <p style="font-size:16px;color:#333333;margin:0 0 12px;">{HTML_WAVE} Hola!</p>
        <p style="font-size:15px;color:#555555;line-height:1.6;margin:0 0 28px;">
          Aqui esta tu codigo de verificacion para continuar con tu registro en <strong>SmartParking</strong>:
        </p>

        <table width="100%" cellpadding="0" cellspacing="0" style="margin-bottom:28px;">
          <tr>
            <td align="center" style="background:#f0f4ff;border:2px dashed #4a6cf7;border-radius:10px;padding:24px;">
              <p style="margin:0 0 6px;font-size:13px;color:#888;letter-spacing:2px;text-transform:uppercase;">Codigo de verificacion</p>
              <p style="margin:0;font-size:38px;font-weight:bold;color:#1a1a2e;letter-spacing:8px;">{HTML_LOCK} {codigo}</p>
            </td>
          </tr>
        </table>

        <table width="100%" cellpadding="0" cellspacing="0" style="margin-bottom:20px;">
          <tr>
            <td style="background:#fff8e1;border-left:4px solid #f59e0b;border-radius:0 8px 8px 0;padding:14px 16px;">
              <p style="margin:0;font-size:14px;color:#92610a;">{HTML_CLOCK} <strong>Este codigo expira en 10 minutos.</strong> Ingresalo antes de que venza.</p>
            </td>
          </tr>
        </table>

        <table width="100%" cellpadding="0" cellspacing="0">
          <tr>
            <td style="background:#f9f9f9;border-left:4px solid #cccccc;border-radius:0 8px 8px 0;padding:14px 16px;">
              <p style="margin:0;font-size:13px;color:#888888;">{HTML_WARNING} No solicitaste este registro? Puedes ignorar este correo con total tranquilidad.</p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    '''
    _send_email(
        correo,
        f"{EMOJI_PARKING} SmartParking - Tu codigo de verificacion",
        _email_shell(content),
    )


def enviar_aviso_empresa(correo: str) -> None:
    content = f'''
    <tr>
      <td style="padding:36px 40px;">
        <p style="font-size:16px;color:#333333;margin:0 0 12px;">{HTML_WAVE} Hola!</p>
        <p style="font-size:15px;color:#555555;line-height:1.6;margin:0 0 28px;">
          Recibimos correctamente tu solicitud para crear una <strong>cuenta empresarial</strong> en nuestra plataforma. {HTML_PARTY}
        </p>

        <table width="100%" cellpadding="0" cellspacing="0" style="margin-bottom:28px;">
          <tr>
            <td align="center" style="background:#fffbeb;border:1px solid #f59e0b;border-radius:10px;padding:20px;">
              <p style="margin:0 0 6px;font-size:12px;color:#92610a;letter-spacing:2px;text-transform:uppercase;">Estado de tu solicitud</p>
              <p style="margin:0;font-size:22px;font-weight:bold;color:#b45309;">{HTML_SYNC} EN EVALUACION</p>
            </td>
          </tr>
        </table>

        <p style="font-size:15px;color:#555555;line-height:1.6;margin:0 0 16px;">
          Nuestro equipo revisara la informacion proporcionada y te notificaremos con una respuesta en un plazo maximo de:
        </p>
        <table width="100%" cellpadding="0" cellspacing="0" style="margin-bottom:24px;">
          <tr>
            <td align="center" style="background:#f0f4ff;border-radius:8px;padding:16px;">
              <p style="margin:0;font-size:20px;font-weight:bold;color:#1a1a2e;">{HTML_HOURGLASS} 24 horas</p>
            </td>
          </tr>
        </table>

        <p style="font-size:14px;color:#777777;margin:0;">
          Gracias por tu paciencia y por querer formar parte de nuestra red de socios. {HTML_HANDSHAKE}
        </p>
      </td>
    </tr>
    '''
    _send_email(
        correo,
        f"{EMOJI_PARKING} SmartParking - Solicitud recibida y en evaluacion",
        _email_shell(content),
    )


def enviar_confirmacion_aprobacion(correo: str) -> None:
    portal_url = _portal_url()
    content = f'''
    <tr>
      <td style="padding:36px 40px;">
        <p style="font-size:22px;color:#333333;font-weight:bold;margin:0 0 8px;">{HTML_PARTY} Excelentes noticias!</p>
        <p style="font-size:15px;color:#555555;line-height:1.6;margin:0 0 28px;">
          Tu solicitud empresarial ha sido revisada y tenemos una actualizacion para ti.
        </p>

        <table width="100%" cellpadding="0" cellspacing="0" style="margin-bottom:28px;">
          <tr>
            <td align="center" style="background:#f0fdf4;border:1px solid #22c55e;border-radius:10px;padding:20px;">
              <p style="margin:0 0 6px;font-size:12px;color:#166534;letter-spacing:2px;text-transform:uppercase;">Estado de tu solicitud</p>
              <p style="margin:0;font-size:22px;font-weight:bold;color:#15803d;">{HTML_CHECK} APROBADA</p>
            </td>
          </tr>
        </table>

        <p style="font-size:15px;color:#555555;line-height:1.6;margin:0 0 20px;">
          Tu cuenta empresarial ha sido <strong>verificada y activada</strong>. Ya puedes ingresar al portal con tu correo corporativo y contrasena. {HTML_KEY}
        </p>

        <table width="100%" cellpadding="0" cellspacing="0" style="background:#f8faff;border-radius:10px;padding:20px;margin-bottom:28px;">
          <tr>
            <td>
              <p style="margin:0 0 12px;font-size:13px;color:#888;letter-spacing:1px;text-transform:uppercase;">Desde el portal podras:</p>
              <p style="margin:0 0 8px;font-size:14px;color:#444;">{HTML_PIN} Configurar tu estacionamiento</p>
              <p style="margin:0 0 8px;font-size:14px;color:#444;">{HTML_BUILDING} Registrar niveles y divisiones</p>
              <p style="margin:0 0 8px;font-size:14px;color:#444;">{HTML_PARKING} Gestionar tus espacios</p>
              <p style="margin:0;font-size:14px;color:#444;">{HTML_CHART} Monitorear tu operacion en tiempo real</p>
            </td>
          </tr>
        </table>

        <table width="100%" cellpadding="0" cellspacing="0">
          <tr>
            <td align="center">
              <a href="{portal_url}" style="display:inline-block;background:#1a1a2e;color:#ffffff;text-decoration:none;font-size:15px;font-weight:bold;padding:14px 36px;border-radius:8px;">
                {HTML_ROCKET} Ir al portal
              </a>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    '''
    _send_email(
        correo,
        f"{EMOJI_PARKING} SmartParking - Tu solicitud fue aprobada {EMOJI_CHECK}",
        _email_shell(content, f"{HTML_CONFETTI} Bienvenido a la familia SmartParking!"),
    )


def enviar_rechazo_empresa(correo: str) -> None:
    content = f'''
    <tr>
      <td style="padding:36px 40px;">
        <p style="font-size:16px;color:#333333;margin:0 0 12px;">{HTML_WAVE} Hola!</p>
        <p style="font-size:15px;color:#555555;line-height:1.6;margin:0 0 28px;">
          Revisamos cuidadosamente tu solicitud empresarial y lamentamos informarte que no pudo ser aprobada en esta ocasion.
        </p>

        <table width="100%" cellpadding="0" cellspacing="0" style="margin-bottom:28px;">
          <tr>
            <td align="center" style="background:#fef2f2;border:1px solid #f87171;border-radius:10px;padding:20px;">
              <p style="margin:0 0 6px;font-size:12px;color:#991b1b;letter-spacing:2px;text-transform:uppercase;">Estado de tu solicitud</p>
              <p style="margin:0;font-size:22px;font-weight:bold;color:#dc2626;">{HTML_CROSS} NO APROBADA</p>
            </td>
          </tr>
        </table>

        <table width="100%" cellpadding="0" cellspacing="0" style="background:#fafafa;border-radius:10px;padding:20px;margin-bottom:24px;">
          <tr>
            <td>
              <p style="margin:0 0 12px;font-size:13px;color:#888;letter-spacing:1px;text-transform:uppercase;">Esto puede ocurrir cuando:</p>
              <p style="margin:0 0 8px;font-size:14px;color:#555;">{HTML_DOC} La informacion enviada esta incompleta</p>
              <p style="margin:0 0 8px;font-size:14px;color:#555;">{HTML_SEARCH} Los datos no superaron la validacion</p>
              <p style="margin:0;font-size:14px;color:#555;">{HTML_CLIP} Falta documentacion requerida</p>
            </td>
          </tr>
        </table>

        <table width="100%" cellpadding="0" cellspacing="0" style="margin-bottom:20px;">
          <tr>
            <td style="background:#eff6ff;border-left:4px solid #3b82f6;border-radius:0 8px 8px 0;padding:16px;">
              <p style="margin:0 0 6px;font-size:14px;color:#1e40af;font-weight:bold;">Crees que es un error?</p>
              <p style="margin:0 0 4px;font-size:13px;color:#3b5998;">{HTML_CHAT} soporte@smartparking.com</p>
              <p style="margin:0;font-size:13px;color:#555555;">{HTML_SYNC} Puedes volver a enviar tu solicitud con datos actualizados.</p>
            </td>
          </tr>
        </table>

        <p style="font-size:14px;color:#777777;margin:0;">
          Agradecemos tu interes en SmartParking y esperamos poder trabajar contigo proximamente. {HTML_RAISED}
        </p>
      </td>
    </tr>
    '''
    _send_email(
        correo,
        f"{EMOJI_PARKING} SmartParking - Actualizacion sobre tu solicitud",
        _email_shell(content),
    )
