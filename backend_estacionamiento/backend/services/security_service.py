import hashlib


class SecurityService:
    """Encapsula el hashing actual para poder migrarlo sin tocar rutas ni repositorios."""

    @staticmethod
    def hash_password(password: str) -> str:
        return hashlib.sha256(password.encode("utf-8")).hexdigest()

    @staticmethod
    def verify_password(password: str, password_hash: str) -> bool:
        return SecurityService.hash_password(password) == str(password_hash).strip()
