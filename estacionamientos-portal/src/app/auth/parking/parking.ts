import { CommonModule } from '@angular/common';
import { Component, OnDestroy, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { Subscription } from 'rxjs';

import { DivisionData, ParkingConfigPayload, PisoData } from '../../models/parking.models';
import { ParkingService } from '../../services/parking.service';
import { RealtimeService } from '../../services/realtime.service';
import { AuthService } from '../auth.service';
import { LanguageService } from '../../core/language.service';
import { TranslatePipe } from '../../core/translate.pipe';

@Component({
  selector: 'app-parking',
  standalone: true,
  imports: [CommonModule, FormsModule, TranslatePipe],
  templateUrl: './parking.html',
  styleUrl: './parking.css',
})
export class Parking implements OnInit, OnDestroy {
  sidebarExpanded = true;
  activeNavItem = 'crear';

  empresa_id: number | null = null;
  empresa = '';
  descripcion = '';
  direccion = '';
  imagenUrl = '';
  coordX: number | null = null;
  coordY: number | null = null;

  pisos = 3;
  divisionesColumnas = 3;
  divisionesFilas = 4;
  espaciosPorDivision = 6;

  configuracionIniciada = false;
  pisosConfig: PisoData[] = [];

  pisoActualConfigIndex = 0;
  pisoActivoCelular = 0;

  private readonly letras = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  private realtimeSubscription?: Subscription;

  constructor(
    private readonly authService: AuthService,
    private readonly parkingService: ParkingService,
    private readonly realtimeService: RealtimeService,
    private readonly language: LanguageService,
    private readonly router: Router,
  ) {}

  ngOnInit(): void {
    this.empresa_id = this.authService.getEmpresaId();
    this.realtimeSubscription = this.realtimeService.parkingUpdates().subscribe({
      next: (data) => console.log('Cambio en tiempo real recibido:', data),
      error: (error) => console.error('Error de WebSocket:', error),
    });
  }

  ngOnDestroy(): void {
    this.realtimeSubscription?.unsubscribe();
  }

  setActiveNav(nav: string): void {
    this.activeNavItem = nav;
  }

  toggleSidebar(): void {
    this.sidebarExpanded = !this.sidebarExpanded;
  }

  cerrarSesion(): void {
    this.authService.limpiarSesion();
    this.router.navigate(['/login'], { replaceUrl: true });
  }

  get totalDivisiones(): number {
    const cols = Math.min(Number(this.divisionesColumnas) || 0, 4);
    return cols * (Number(this.divisionesFilas) || 0);
  }

  getLetra(index: number): string {
    if (index < 26) return this.letras[index];
    return `Z${index - 25}`;
  }

  getArray(n: number): number[] {
    return Array.from({ length: Math.max(0, n || 0) });
  }

  get gridStyle() {
    const cols = Math.min(Number(this.divisionesColumnas) || 1, 4);
    return {
      display: 'grid',
      'grid-template-columns': `repeat(${cols}, 1fr)`,
      gap: '0.35rem',
    };
  }

  iniciarConfiguracion(): void {
    const pisos = Number(this.pisos);
    let columnas = Number(this.divisionesColumnas);
    const filas = Number(this.divisionesFilas);
    const espaciosGlobales = Number(this.espaciosPorDivision) || 0;

    if (!pisos || pisos < 1) {
      alert(this.language.t('parking.enter_one_floor'));
      return;
    }

    if (columnas > 4) {
      this.divisionesColumnas = 4;
      columnas = 4;
    }

    this.pisosConfig = Array.from({ length: pisos }, () => ({
      divisiones: Array.from({ length: columnas * filas }, (_, index) => ({
        id: this.getLetra(index),
        espacios: espaciosGlobales,
      })),
    }));

    this.configuracionIniciada = true;
    this.pisoActualConfigIndex = 0;
    this.pisoActivoCelular = 0;
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  get divisionesConfigActual(): DivisionData[] {
    return this.pisosConfig[this.pisoActualConfigIndex]?.divisiones || [];
  }

  siguientePiso(): void {
    if (this.pisoActualConfigIndex < this.pisos - 1) {
      this.pisoActualConfigIndex++;
      this.pisoActivoCelular = this.pisoActualConfigIndex;
    }
  }

  anteriorPiso(): void {
    if (this.pisoActualConfigIndex > 0) {
      this.pisoActualConfigIndex--;
      this.pisoActivoCelular = this.pisoActualConfigIndex;
    }
  }

  seleccionarPisoCelular(index: number): void {
    this.pisoActivoCelular = index;
  }

  get divisionesVisualizadas(): DivisionData[] {
    return this.pisosConfig[this.pisoActivoCelular]?.divisiones || [];
  }

  espaciosTotalesEnPiso(pisoIndex: number): number {
    if (!this.pisosConfig[pisoIndex]) return 0;
    return this.pisosConfig[pisoIndex].divisiones.reduce(
      (acc, division) => acc + (Number(division.espacios) || 0),
      0,
    );
  }

  get totalEspaciosGlobal(): number {
    return this.pisosConfig.reduce(
      (acc, _, index) => acc + this.espaciosTotalesEnPiso(index),
      0,
    );
  }

  guardarConfiguracionBaseDatos(): void {
    if (!this.empresa_id) {
      alert(this.language.t('parking.company_missing'));
      return;
    }

    const payload: ParkingConfigPayload = {
      empresa_id: this.empresa_id,
      nombre: this.empresa,
      descripcion: this.descripcion,
      direccion: this.direccion,
      imagen_url: this.imagenUrl || null,
      latitud: this.coordX || 0,
      longitud: this.coordY || 0,
      columnas_diseno: this.divisionesColumnas,
      filas_diseno: this.divisionesFilas,
      pisos: this.pisosConfig,
    };

    this.parkingService.configureParking(payload).subscribe({
      next: () => {
        alert(this.language.t('parking.created_success', { name: this.empresa }));
        this.configuracionIniciada = false;
      },
      error: (err) => {
        console.error('Error en la petición:', err);
        const errorMsg = err.error?.detail || this.language.t('parking.backend_error');
        alert(this.language.t('parking.save_error', { message: errorMsg }));
      },
    });
  }
}
