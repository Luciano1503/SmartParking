# Arquitectura del monorepo SmartParking

## Backend FastAPI

```text
Routes -> Services -> Repositories -> Database
             |
             +-> email / realtime / security
```

- `Routes/`: expone endpoints HTTP y WebSocket.
- `Services/`: contiene reglas de negocio y orquestación.
- `Repositories/`: centraliza SQL y acceso a PostgreSQL.
- `Database/`: crea conexiones y controla transacciones.

## Portal Angular

```text
Components -> Services -> API / WebSocket / LocalStorage
```

- Los componentes solo coordinan estado de pantalla.
- Los servicios concentran autenticación, administración, estacionamientos y tiempo real.
- Los modelos tipan respuestas y payloads.

## App Flutter

```text
Pages -> Services -> API / Geolocalización / WebSocket
        \-> Models
```

- Las páginas mantienen interacción y navegación.
- Los servicios concentran red, ubicación, geocodificación y WebSocket.
- `Core/api_config.dart` centraliza URLs y configuración externa.

## Regla de evolución

Al agregar una funcionalidad nueva:

1. La pantalla no debe consultar HTTP ni SQL directamente.
2. La lógica de negocio va a un servicio.
3. El acceso a datos del backend va a un repositorio.
4. Los contratos públicos existentes deben conservarse salvo migración explícita.
