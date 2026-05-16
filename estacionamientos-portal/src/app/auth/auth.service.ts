import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  // Guarda el usuario en el navegador para que no se borre al refrescar
  guardarSesion(usuario: any) {
    localStorage.setItem('usuario', JSON.stringify(usuario));
  }

  // Recupera el ID de la empresa vinculado al usuario
  getEmpresaId(): number {
    const data = localStorage.getItem('usuario');
    if (data) {
      const user = JSON.parse(data);
      return user.empresa_id; // Este es el que necesitamos en Parking
    }
    return 0; 
  }

  limpiarSesion() {
    localStorage.removeItem('usuario');
  }
}