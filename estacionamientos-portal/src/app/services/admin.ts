import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AdminService {
  // Asegúrate de que este puerto coincida con tu FastAPI
  private API_URL = 'http://localhost:8000/admin'; 

  constructor(private http: HttpClient) { }

  // Obtiene las empresas con verificado = FALSE
  getPendientes(): Observable<any[]> {
    return this.http.get<any[]>(`${this.API_URL}/pendientes`);
  }

  // Ejecuta la aprobación o rechazo
  gestionarSolicitud(usuarioId: number, accion: 'aprobar' | 'rechazar'): Observable<any> {
    return this.http.post(`${this.API_URL}/aprobar/${usuarioId}?accion=${accion}`, {});
  }
}