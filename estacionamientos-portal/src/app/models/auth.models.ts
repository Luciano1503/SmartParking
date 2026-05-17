export interface WebLoginRequest {
  correo: string;
  contrasenia: string;
}

export interface WebSession {
  status: 'success';
  tipo: 'admin' | 'empresa';
  correo: string;
  nombre: string;
  empresa_id: number | null;
}

export interface WebLoginError {
  error: string;
}

export type WebLoginResponse = WebSession | WebLoginError;

export interface CompanyRegisterRequest {
  nombre_representante: string;
  apellido_representante: string;
  correo: string;
  nombre_empresa: string;
  contrasenia: string;
}

export interface CompanyRegisterResponse {
  status: 'success' | 'error';
  mensaje?: string;
  detalle?: string;
  correo_enviado?: boolean;
  detalle_correo?: string | null;
}
