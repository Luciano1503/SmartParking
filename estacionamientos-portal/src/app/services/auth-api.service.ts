import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { timeout } from 'rxjs/operators';

import { API_CONFIG } from '../core/api.config';
import {
  CompanyRegisterRequest,
  CompanyRegisterResponse,
  WebLoginRequest,
  WebLoginResponse,
} from '../models/auth.models';

@Injectable({
  providedIn: 'root',
})
export class AuthApiService {
  constructor(private readonly http: HttpClient) {}

  loginWeb(payload: WebLoginRequest): Observable<WebLoginResponse> {
    return this.http
      .post<WebLoginResponse>(`${API_CONFIG.baseUrl}/login-web`, payload)
      .pipe(timeout(25000));
  }

  registerCompany(payload: CompanyRegisterRequest): Observable<CompanyRegisterResponse> {
    return this.http
      .post<CompanyRegisterResponse>(`${API_CONFIG.baseUrl}/registro-empresa`, payload)
      .pipe(timeout(25000));
  }
}
