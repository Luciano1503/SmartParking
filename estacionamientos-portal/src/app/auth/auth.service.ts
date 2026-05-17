import { Injectable } from '@angular/core';
import { WebSession } from '../models/auth.models';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private readonly sessionKey = 'usuario';
  private readonly typeKey = 'tipo_usuario';

  guardarSesion(usuario: WebSession): void {
    localStorage.setItem(this.sessionKey, JSON.stringify(usuario));
    localStorage.setItem(this.typeKey, usuario.tipo);
  }

  obtenerSesion(): WebSession | null {
    const data = localStorage.getItem(this.sessionKey);
    if (!data) return null;

    try {
      return JSON.parse(data) as WebSession;
    } catch {
      this.limpiarSesion();
      return null;
    }
  }

  estaAutenticado(): boolean {
    return this.obtenerSesion() !== null;
  }

  obtenerTipoUsuario(): 'admin' | 'empresa' | null {
    return this.obtenerSesion()?.tipo ?? null;
  }

  getEmpresaId(): number {
    return this.obtenerSesion()?.empresa_id ?? 0;
  }

  limpiarSesion(): void {
    localStorage.removeItem(this.sessionKey);
    localStorage.removeItem(this.typeKey);
  }
}
