from fastapi import FastAPI
from Routes import auth


app = FastAPI()

# Endpoint raíz
@app.get("/")
def root():
    return {
        "mensaje": "Bienvenido al backend de SmartParking Solutions 🚗✨",
        "descripcion": "API para registro, verificación, formulario y login de usuarios.",
        "endpoints": [
            "/registro",
            "/verificar",
            "/formulario",
            "/login"
        ]
    }

# Incluir rutas de autenticación
app.include_router(auth.router)
