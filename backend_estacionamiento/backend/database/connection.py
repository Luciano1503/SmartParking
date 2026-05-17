import os
from pathlib import Path

import psycopg2
from dotenv import load_dotenv
from psycopg2.extras import RealDictCursor


def _find_env_path() -> Path:
    current_file = Path(__file__).resolve()
    for parent in current_file.parents:
        env_path = parent / ".env"
        if env_path.exists():
            return env_path
    if len(current_file.parents) > 1:
        return current_file.parents[1] / ".env"
    return current_file.parent / ".env"


ENV_PATH = _find_env_path()

DATABASE_URL_ENV_NAMES = (
    "DATABASE_URL",
    "DATABASE_PRIVATE_URL",
    "POSTGRES_URL",
    "POSTGRES_PRIVATE_URL",
    "POSTGRES_DATABASE_URL",
    "POSTGRES_URL_NON_POOLING",
)


def _first_env(names: tuple[str, ...]) -> str | None:
    for name in names:
        value = os.getenv(name)
        if value and value.strip():
            return value.strip()
    return None


def _is_railway_environment() -> bool:
    return any(
        os.getenv(name)
        for name in (
            "RAILWAY_ENVIRONMENT",
            "RAILWAY_ENVIRONMENT_ID",
            "RAILWAY_PROJECT_ID",
            "RAILWAY_SERVICE_ID",
        )
    )


def _database_url() -> str | None:
    return _first_env(DATABASE_URL_ENV_NAMES)


def _database_config() -> dict:
    host = _first_env(("DB_HOST", "PGHOST", "POSTGRES_HOST"))
    database = _first_env(("DB_NAME", "PGDATABASE", "POSTGRES_DB", "POSTGRES_DATABASE"))
    user = _first_env(("DB_USER", "PGUSER", "POSTGRES_USER"))
    password = _first_env(("DB_PASSWORD", "PGPASSWORD", "POSTGRES_PASSWORD"))
    port = _first_env(("DB_PORT", "PGPORT", "POSTGRES_PORT"))

    if _is_railway_environment() and not host:
        raise RuntimeError(
            "No se encontro configuracion de PostgreSQL para Railway. "
            "Agrega DATABASE_URL en las variables del servicio backend "
            "o referencia las variables PGHOST, PGPORT, PGUSER, PGPASSWORD y PGDATABASE "
            "desde tu servicio PostgreSQL."
        )

    config = {
        "host": host or "localhost",
        "database": database or "ProyectoIntegrador",
        "user": user or "postgres",
        "password": password,
        "cursor_factory": RealDictCursor,
    }

    if port:
        config["port"] = int(port)

    return config


def get_connection():
    load_dotenv(ENV_PATH)

    db_url = _database_url()
    if db_url:
        return psycopg2.connect(db_url, cursor_factory=RealDictCursor)

    return psycopg2.connect(**_database_config())
