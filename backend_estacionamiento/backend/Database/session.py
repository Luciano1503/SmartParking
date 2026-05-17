from contextlib import contextmanager
from typing import Iterator, Tuple

from Database.connection import get_connection


@contextmanager
def db_cursor() -> Iterator[Tuple[object, object]]:
    """Abre una conexión y garantiza commit/rollback + cierre de recursos."""
    conn = get_connection()
    cur = conn.cursor()
    try:
        yield conn, cur
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        cur.close()
        conn.close()
