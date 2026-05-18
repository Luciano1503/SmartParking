from typing import List, Optional

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from services.parking_service import ParkingService
from services.realtime_service import manager

router = APIRouter(prefix="/parking", tags=["Parking"])


class DivisionSchema(BaseModel):
    id: str
    espacios: int


class PisoSchema(BaseModel):
    divisiones: List[DivisionSchema]


class ParkingConfigSchema(BaseModel):
    empresa_id: int
    nombre: str
    descripcion: str
    direccion: str
    imagen_url: Optional[str] = None
    latitud: float
    longitud: float
    columnas_diseno: int
    filas_diseno: int
    pisos: List[PisoSchema]


class SensorStatusSchema(BaseModel):
    sensor_codigo: str
    estado: str
    origen: Optional[str] = None


@router.get("/lista")
def listar_estacionamientos():
    try:
        return ParkingService.listar_estacionamientos()
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc))


@router.post("/configurar")
def configurar_estacionamiento(config: ParkingConfigSchema):
    try:
        return ParkingService.configurar_estacionamiento(config)
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc))


@router.get("/detalle/{estacionamiento_id}")
def detalle_mapa(estacionamiento_id: int):
    try:
        return ParkingService.detalle_mapa(estacionamiento_id)
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc))


@router.get("/sensor/{sensor_codigo}")
def obtener_sensor(sensor_codigo: str):
    try:
        return ParkingService.obtener_sensor(sensor_codigo)
    except ValueError as exc:
        raise HTTPException(status_code=404, detail=str(exc))
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc))


@router.get("/sensores")
def listar_sensores():
    try:
        return ParkingService.listar_sensores()
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc))


@router.post("/sensor/estado")
async def actualizar_estado_sensor(data: SensorStatusSchema):
    try:
        result = ParkingService.actualizar_estado_sensor(
            data.sensor_codigo,
            data.estado,
            data.origen,
        )

        if result.get("changed"):
            await manager.broadcast(
                {
                    "espacio_id": result["espacio_id"],
                    "codigo": result["codigo"],
                    "nuevo_estado": result["nuevo_estado"],
                    "estacionamiento_id": result["estacionamiento_id"],
                    "fecha": result["fecha"],
                    "origen": result["origen"],
                }
            )

        return result
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc))
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc))
