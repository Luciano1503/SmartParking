from fastapi import APIRouter, HTTPException

from models.usuario import (
    EmpresaRegistro,
    UsuarioFormulario,
    UsuarioLogin,
    UsuarioRegistro,
    UsuarioVerificacion,
)
from services.admin_service import AdminService
from services.auth_service import AuthService

router = APIRouter()


@router.post("/registro")
def registrar_usuario(usuario: UsuarioRegistro):
    try:
        return AuthService.registrar_usuario(usuario.correo)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc))
    except RuntimeError as exc:
        raise HTTPException(status_code=503, detail=str(exc))
    except Exception as exc:
        raise HTTPException(status_code=500, detail=f"Error interno: {str(exc)}")


@router.post("/verificar")
def verificar_usuario(data: UsuarioVerificacion):
    try:
        return AuthService.verificar_usuario(data.correo, data.codigo)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc))
    except Exception as exc:
        raise HTTPException(status_code=500, detail=f"Error interno: {str(exc)}")


@router.post("/formulario")
def completar_formulario(data: UsuarioFormulario):
    return AuthService.completar_formulario(data)


@router.post("/login")
def login_usuario(data: UsuarioLogin):
    return AuthService.login_usuario(data.correo, data.contrasenia)


@router.post("/registro-empresa")
def registrar_empresa(data: EmpresaRegistro):
    return AuthService.registrar_empresa(data)


@router.get("/admin/pendientes")
def listar_pendientes():
    return AdminService.listar_pendientes()


@router.post("/admin/aprobar/{usuario_id}")
def aprobar_empresa(usuario_id: int, accion: str):
    return AdminService.aprobar_empresa(usuario_id, accion)


@router.post("/login-web")
def login_web(data: UsuarioLogin):
    return AuthService.login_web(data.correo, data.contrasenia)


@router.get("/admin/sensores-inoperativos")
def listar_sensores_inoperativos():
    return AdminService.listar_sensores_inoperativos()
