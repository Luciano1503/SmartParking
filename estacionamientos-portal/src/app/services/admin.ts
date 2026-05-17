import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

import { API_CONFIG } from '../core/api.config';
import { InoperativeSensor, PendingCompany } from '../models/admin.models';

@Injectable({
  providedIn: 'root',
})
export class AdminService {
  constructor(private readonly http: HttpClient) {}

  getPendientes(): Observable<PendingCompany[]> {
    return this.http.get<PendingCompany[]>(`${API_CONFIG.baseUrl}/admin/pendientes`);
  }

  getSensoresInoperativos(): Observable<InoperativeSensor[]> {
    return this.http.get<InoperativeSensor[]>(
      `${API_CONFIG.baseUrl}/admin/sensores-inoperativos`,
    );
  }

  gestionarSolicitud(usuarioId: number, accion: 'aprobar' | 'rechazar'): Observable<{ mensaje?: string }> {
    return this.http.post<{ mensaje?: string }>(
      `${API_CONFIG.baseUrl}/admin/aprobar/${usuarioId}?accion=${accion}`,
      {},
    );
  }
}
