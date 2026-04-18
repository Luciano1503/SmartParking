import psycopg2
from psycopg2.extras import RealDictCursor

def get_connection():
    return psycopg2.connect(
        host="localhost",
        database="ProyectoIntegrador",
        user="postgres",
        password="Romel2004",
        cursor_factory=RealDictCursor
    )
