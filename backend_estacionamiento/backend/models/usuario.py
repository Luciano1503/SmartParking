from pydantic import BaseModel, EmailStr

class UsuarioRegistro(BaseModel):
    correo: str

class UsuarioVerificacion(BaseModel):
    correo: str
    codigo: str

class UsuarioFormulario(BaseModel):
    correo: str
    nombre: str
    apellido: str
    telefono: str
    dni: str
    fecha_nacimiento: str  # formato "YYYY-MM-DD"
    placa: str
    modelo: str
    contrasenia: str

class UsuarioLogin(BaseModel):
    correo: str
    contrasenia: str

    # Modelo para el registro inicial de empresa
class EmpresaRegistro(BaseModel):
    nombre_empresa: str
    nombre_representante: str
    apellido_representante: str
    correo: EmailStr
    contrasenia: str
