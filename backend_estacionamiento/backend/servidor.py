import asyncio
from contextlib import suppress
from datetime import datetime, timedelta

from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from starlette.websockets import WebSocketState

from database.session import db_cursor
from routes import auth, parking
from services.email_service import email_delivery_status
from services.realtime_service import manager

APP_VERSION = "railway-iot-gateway-mailtrap-api-2026-05-18"

app = FastAPI()
_realtime_db_task: asyncio.Task | None = None

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
async def start_realtime_db_watcher():
    print(f"[SmartParking] Backend version: {APP_VERSION}")
    global _realtime_db_task
    if _realtime_db_task is None or _realtime_db_task.done():
        _realtime_db_task = asyncio.create_task(_watch_parking_state_changes())


@app.on_event("shutdown")
async def stop_realtime_db_watcher():
    if _realtime_db_task:
        _realtime_db_task.cancel()
        with suppress(asyncio.CancelledError):
            await _realtime_db_task


async def _watch_parking_state_changes():
    last_seen = datetime.now() - timedelta(seconds=2)

    while True:
        await asyncio.sleep(1)
        if not manager.has_connections:
            last_seen = datetime.now() - timedelta(seconds=2)
            continue

        try:
            changes = await asyncio.to_thread(_fetch_parking_state_changes, last_seen)
            for change in changes:
                last_seen = max(last_seen, change.pop("_updated_at", last_seen))
                await manager.broadcast(change)
        except Exception as exc:
            print(f"[WS] Error revisando cambios de BD: {exc}")


def _fetch_parking_state_changes(last_seen: datetime) -> list[dict]:
    with db_cursor() as (_, cur):
        cur.execute(
            """
            SELECT
                e.id AS espacio_id,
                e.codigo AS codigo,
                e.estado_actual AS nuevo_estado,
                e.ultimo_update AS updated_at,
                est.id AS estacionamiento_id
            FROM espacio e
            JOIN zona z ON e.zona_id = z.id
            JOIN nivel n ON z.nivel_id = n.id
            JOIN estacionamiento est ON n.estacionamiento_id = est.id
            WHERE e.ultimo_update IS NOT NULL AND e.ultimo_update > %s
            ORDER BY e.ultimo_update ASC
            LIMIT 200;
            """,
            (last_seen,),
        )
        rows = cur.fetchall()

    changes = []
    for row in rows:
        payload = dict(row)
        updated_at = payload.pop("updated_at", None)
        payload["fecha"] = updated_at.isoformat() if updated_at else None
        payload["_updated_at"] = updated_at
        changes.append(payload)

    return changes


@app.get("/")
def root():
    return {
        "mensaje": "Backend de SmartParking Online con WebSockets",
        "version": APP_VERSION,
        "email": email_delivery_status(),
    }


@app.websocket("/ws/parking")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            try:
                await asyncio.wait_for(websocket.receive_text(), timeout=30)
            except asyncio.TimeoutError:
                if websocket.client_state != WebSocketState.CONNECTED:
                    break
    except WebSocketDisconnect:
        pass
    except Exception as exc:
        print(f"[WS] Conexion cerrada por el cliente: {exc}")
    finally:
        manager.disconnect(websocket)


@app.post("/notificar_cambio")
async def notificar_cambio(datos: dict):
    await manager.broadcast(enrich_realtime_payload(datos))
    return {"status": "notificado"}


def enrich_realtime_payload(datos: dict) -> dict:
    payload = dict(datos)
    espacio_id = payload.get("espacio_id")

    if espacio_id is None:
        return payload

    try:
        with db_cursor() as (_, cur):
            cur.execute(
                """
                SELECT
                    e.id AS espacio_id,
                    e.codigo AS codigo,
                    e.estado_actual AS nuevo_estado,
                    est.id AS estacionamiento_id
                FROM espacio e
                JOIN zona z ON e.zona_id = z.id
                JOIN nivel n ON z.nivel_id = n.id
                JOIN estacionamiento est ON n.estacionamiento_id = est.id
                WHERE e.id = %s;
                """,
                (int(espacio_id),),
            )
            espacio = cur.fetchone()

        if espacio:
            payload.update(dict(espacio))
    except Exception as exc:
        print(f"[WS] No se pudo enriquecer evento de espacio {espacio_id}: {exc}")

    return payload


app.include_router(auth.router)
app.include_router(parking.router)
