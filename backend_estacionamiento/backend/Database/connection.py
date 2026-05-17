import os
from pathlib import Path

import psycopg2
from dotenv import load_dotenv
from psycopg2.extras import RealDictCursor

ENV_PATH = Path(__file__).resolve().parents[3] / ".env"

def get_connection():
    load_dotenv(ENV_PATH)
    
    # 1. Intentamos buscar la URL mágica de Railway primero
    db_url = os.getenv("DATABASE_URL")
    
    if db_url:
        # Si encuentra DATABASE_URL (está en la nube), se conecta directo
        return psycopg2.connect(db_url, cursor_factory=RealDictCursor)
    else:
        # Si NO la encuentra (estás en tu laptop), usa tus variables locales
        return psycopg2.connect(
            host=os.getenv("DB_HOST", "localhost"),
            database=os.getenv("DB_NAME", "ProyectoIntegrador"),
            user=os.getenv("DB_USER", "postgres"),
            password=os.getenv("DB_PASSWORD"),
            cursor_factory=RealDictCursor,
        )
