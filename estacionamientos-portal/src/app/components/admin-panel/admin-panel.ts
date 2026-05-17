import { CommonModule } from '@angular/common';
import { ChangeDetectorRef, Component, OnDestroy, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Subscription } from 'rxjs';

import { AuthService } from '../../auth/auth.service';
import { InoperativeSensor, PendingCompany } from '../../models/admin.models';
import { AdminService } from '../../services/admin';
import { RealtimeService } from '../../services/realtime.service';
import { LanguageService } from '../../core/language.service';
import { TranslatePipe } from '../../core/translate.pipe';

@Component({
  selector: 'app-admin-panel',
  standalone: true,
  imports: [CommonModule, TranslatePipe],
  templateUrl: './admin-panel.html',
})
export class AdminPanel implements OnInit, OnDestroy {
  pendientes: PendingCompany[] = [];
  sensoresInoperativos: InoperativeSensor[] = [];

  cargandoEmpresas = true;
  cargandoSensores = true;

  private realtimeSubscription?: Subscription;

  constructor(
    private readonly authService: AuthService,
    private readonly adminService: AdminService,
    private readonly realtimeService: RealtimeService,
    private readonly language: LanguageService,
    private readonly cdr: ChangeDetectorRef,
    private readonly router: Router,
  ) {}

  ngOnInit(): void {
    this.cargarPendientes();
    this.cargarSensoresInoperativos();
    this.realtimeSubscription = this.realtimeService.parkingUpdates().subscribe({
      next: () => this.cargarSensoresInoperativos(),
      error: (error) => console.error('Error en WebSocket admin:', error),
    });
  }

  ngOnDestroy(): void {
    this.realtimeSubscription?.unsubscribe();
  }

  cargarPendientes(): void {
    this.cargandoEmpresas = true;
    this.adminService.getPendientes().subscribe({
      next: (data) => {
        this.pendientes = Array.isArray(data) ? data : [];
        this.cargandoEmpresas = false;
        this.cdr.detectChanges();
      },
      error: (err) => {
        console.error('Error al cargar pendientes:', err);
        this.cargandoEmpresas = false;
        this.cdr.detectChanges();
      },
    });
  }

  cargarSensoresInoperativos(): void {
    this.cargandoSensores = true;
    this.adminService.getSensoresInoperativos().subscribe({
      next: (data) => {
        this.sensoresInoperativos = Array.isArray(data) ? data : [];
        this.cargandoSensores = false;
        this.cdr.detectChanges();
      },
      error: (err) => {
        console.error('Error al cargar sensores inoperativos:', err);
        this.cargandoSensores = false;
        this.cdr.detectChanges();
      },
    });
  }

  procesarSolicitud(id: number, accion: 'aprobar' | 'rechazar'): void {
    const translatedAction = this.language
      .t(accion === 'aprobar' ? 'admin.approve' : 'admin.reject')
      .toLowerCase();
    if (!confirm(this.language.t('admin.confirm_action', { action: translatedAction }))) return;

    this.adminService.gestionarSolicitud(id, accion).subscribe({
      next: (res) => {
        alert(res.mensaje || this.language.t('admin.success'));
        this.cargarPendientes();
      },
      error: (err) => {
        alert(this.language.t('admin.process_error'));
        console.error(err);
      },
    });
  }

  cerrarSesion(): void {
    this.authService.limpiarSesion();
    this.router.navigate(['/login'], { replaceUrl: true });
  }
}
