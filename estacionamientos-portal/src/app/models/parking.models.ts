export interface DivisionData {
  id: string;
  espacios: number;
}

export interface PisoData {
  divisiones: DivisionData[];
}

export interface ParkingConfigPayload {
  empresa_id: number;
  nombre: string;
  descripcion: string;
  direccion: string;
  imagen_url: string | null;
  latitud: number;
  longitud: number;
  columnas_diseno: number;
  filas_diseno: number;
  pisos: PisoData[];
}

export interface ParkingRealtimeEvent {
  espacio_id: number;
  nuevo_estado: string;
  fecha?: string;
}
