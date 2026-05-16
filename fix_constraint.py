"""Script para limpiar filas duplicadas en registro_estado."""
import os
import psycopg2

conn = psycopg2.connect(
    host=os.getenv("DB_HOST", "localhost"),
    database=os.getenv("DB_NAME", "ProyectoIntegrador"),
    user=os.getenv("DB_USER", "postgres"),
    password=os.getenv("DB_PASSWORD")
)
conn.autocommit = True
cur = conn.cursor()

# Ver cuantas filas hay para espacio_id = 1
cur.execute("SELECT COUNT(*) FROM registro_estado WHERE espacio_id = 1")
total = cur.fetchone()[0]
print(f"Filas con espacio_id=1: {total}")

if total > 1:
    # Mantener solo la fila con el ID mas bajo, eliminar las demas
    cur.execute("""
        DELETE FROM registro_estado 
        WHERE espacio_id = 1 
        AND id NOT IN (
            SELECT MIN(id) FROM registro_estado WHERE espacio_id = 1
        )
    """)
    print(f"Eliminadas {cur.rowcount} filas duplicadas")

# Verificar
cur.execute("SELECT id, espacio_id, estado, fecha FROM registro_estado WHERE espacio_id = 1")
result = cur.fetchone()
print(f"Registro final: {result}")

cur.close()
conn.close()
print("LISTO!")


