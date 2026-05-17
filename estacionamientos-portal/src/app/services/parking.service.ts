import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

import { API_CONFIG } from '../core/api.config';
import { ParkingConfigPayload } from '../models/parking.models';

@Injectable({
  providedIn: 'root',
})
export class ParkingService {
  constructor(private readonly http: HttpClient) {}

  configureParking(payload: ParkingConfigPayload): Observable<unknown> {
    return this.http.post(`${API_CONFIG.baseUrl}/parking/configurar`, payload);
  }
}
