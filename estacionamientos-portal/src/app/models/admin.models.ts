export interface PendingCompany {
  id: number;
  correo: string;
  empresa: string;
  representante: string;
}

export interface InoperativeSensor {
  id: number;
  estacionamiento: string;
  direccion: string;
  nivel: string;
  zona: string;
  espacio: string;
  codigo_hardware: string;
}
