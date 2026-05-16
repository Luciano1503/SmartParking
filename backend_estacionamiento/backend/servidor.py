from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from Routes import auth, parking
from typing import List
import json

app = FastAPI()

# --- CONFIGURACIÓN DE CORS ---
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"], 
    allow_headers=["*"],  
)

# --- GESTOR DE WEBSOCKETS (ConnectionManager) ---
class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)
        print(f"[WS] Nueva conexión. Total: {len(self.active_connections)}")

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)
        print(f"[WS] Conexión cerrada. Total: {len(self.active_connections)}")

    async def broadcast(self, message: dict):
        # Envía el mensaje a todos los dispositivos conectados (Web y Móvil)
        for connection in self.active_connections:
            await connection.send_text(json.dumps(message))

manager = ConnectionManager()

# --- ENDPOINTS ---

@app.get("/")
def root():
    return {"mensaje": "Backend de SmartParking Online con WebSockets 🚀"}

# WebSocket Endpoint: Aquí se conectarán Angular y Flutter
@app.websocket("/ws/parking")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            # Mantener la conexión abierta
            await websocket.receive_text()
    except WebSocketDisconnect:
        manager.disconnect(websocket)

# Endpoint para que el script de Arduino notifique el cambio
@app.post("/notificar_cambio")
async def notificar_cambio(datos: dict):
    # 'datos' vendrá del script de arduino: {"espacio_id": 1, "estado": "ocupado"}
    await manager.broadcast(datos)
    return {"status": "notificado"}

app.include_router(auth.router)
app.include_router(parking.router)