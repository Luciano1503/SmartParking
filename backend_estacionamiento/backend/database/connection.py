import os
from pathlib import Path

import psycopg2
from dotenv import load_dotenv
from psycopg2.extras import RealDictCursor

ENV_PATH = Path(__file__).resolve().parents[3] / ".env"


def get_connection():
    load_dotenv(ENV_PATH)

    db_url = os.getenv("DATABASE_URL")
    if db_url:
        return psycopg2.connect(db_url, cursor_factory=RealDictCursor)

    return psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        database=os.getenv("DB_NAME", "ProyectoIntegrador"),
        user=os.getenv("DB_USER", "postgres"),
        password=os.getenv("DB_PASSWORD"),
        cursor_factory=RealDictCursor,
    )
