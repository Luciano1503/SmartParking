from typing import List, Optional

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from Services.parking_service import ParkingService

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
