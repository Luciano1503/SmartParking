import asyncio
import json
from typing import List

from fastapi import WebSocket
from starlette.websockets import WebSocketState


class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)
        print(f"[WS] Nueva conexion. Total: {len(self.active_connections)}")

    def disconnect(self, websocket: WebSocket):
        if websocket in self.active_connections:
            self.active_connections.remove(websocket)
            print(f"[WS] Conexion cerrada. Total: {len(self.active_connections)}")

    @property
    def has_connections(self) -> bool:
        return bool(self.active_connections)

    async def broadcast(self, message: dict):
        disconnected: List[WebSocket] = []

        for connection in list(self.active_connections):
            try:
                if connection.client_state != WebSocketState.CONNECTED:
                    disconnected.append(connection)
                    continue

                await asyncio.wait_for(
                    connection.send_text(json.dumps(message, ensure_ascii=False)),
                    timeout=2,
                )
            except Exception as exc:
                print(f"[WS] No se pudo enviar actualizacion: {exc}")
                disconnected.append(connection)

        for connection in disconnected:
            self.disconnect(connection)


manager = ConnectionManager()
