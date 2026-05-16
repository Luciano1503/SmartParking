import { Component, OnInit, OnDestroy } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router'; // 👈 IMPORTANTE: Importamos Router
import { AuthService } from '../auth.service';

export interface DivisionData {
  id: string;
  espacios: number;
}

export interface PisoData {
  divisiones: DivisionData[];
}

@Component({
  selector: 'app-parking',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './parking.html',
  styleUrl: './parking.css'
})
export class Parking implements OnInit, OnDestroy {

  // ── Variables del Sidebar ─────────────────────────────────────────
  sidebarExpanded: boolean = true;
  activeNavItem: string = 'crear';

  // ── Datos de empresa e ubicación ──────────────────────────────────
  empresa_id: number | null = null;
  empresa: string = '';
  descripcion: string = '';
  direccion: string = '';
  imagenUrl: string = '';
  coordX: number | null = null;
  coordY: number | null = null;

  // ── Estructura Base ───────────────────────────────────────────────
  pisos: number = 3;
  divisionesColumnas: number = 3;
  divisionesFilas: number = 4;
  espaciosPorDivision: number = 6;

  // ── Estado de Configuración ────────────────────
  configuracionIniciada: boolean = false;
  pisosConfig: PisoData[] = [];
  
  pisoActualConfigIndex: number = 0;
  pisoActivoCelular: number = 0;

  private readonly LETRAS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  private socket?: WebSocket; 

  constructor(
    private http: HttpClient,
    private authService: AuthService,
    private router: Router // 👈 Inyectamos Router
  ) {}

  ngOnInit(): void {
    this.empresa_id = this.authService.getEmpresaId();
    console.log("🏢 Empresa ID cargado:", this.empresa_id);
    
    if (!this.empresa_id || this.empresa_id === 0) {
      console.warn("⚠️ No se detectó sesión activa. Usando ID de prueba (5).");
      this.empresa_id = 5;
    }
    this.conectarWebSocket();
  }

  ngOnDestroy(): void {
    if (this.socket) {
      this.socket.close();
    }
  }

  // ── Acciones del Sidebar ──────────────────────────────────────────
  setActiveNav(nav: string) {
    this.activeNavItem = nav;
  }

  toggleSidebar() {
    this.sidebarExpanded = !this.sidebarExpanded;
  }

  cerrarSesion() {
    this.authService.limpiarSesion();
    this.router.navigate(['/login']); // Te regresa al login
  }

  // ── Lógica de WebSockets ──────────────────────────────────────────
  private conectarWebSocket() {
    this.socket = new WebSocket('ws://localhost:8000/ws/parking');
    this.socket.onmessage = (event) => {
      const data = JSON.parse(event.data);
      console.log("⚡ Cambio en tiempo real recibido desde Python:", data);
    };
    this.socket.onclose = () => {
      console.warn("🔌 Socket cerrado. Reintentando en 3 segundos...");
      setTimeout(() => this.conectarWebSocket(), 3000);
    };
    this.socket.onerror = (error) => {
      console.error("❌ Error de WebSocket:", error);
    };
  }

  // ── Cálculos Dinámicos ──
  get totalDivisiones(): number {
    const cols = Math.min(Number(this.divisionesColumnas) || 0, 4);
    return cols * (Number(this.divisionesFilas) || 0);
  }

  getLetra(index: number): string {
    if (index < 26) return this.LETRAS[index];
    return `Z${index - 25}`;
  }

  getArray(n: number): number[] {
    return Array.from({ length: Math.max(0, n || 0) });
  }

  get gridStyle() {
    const cols = Math.min(Number(this.divisionesColumnas) || 1, 4);
    return {
      'display': 'grid',
      'grid-template-columns': `repeat(${cols}, 1fr)`,
      'gap': '0.35rem'
    };
  }

  // ── Lógica de Generación de Estructura ──
  iniciarConfiguracion(): void {
    const p = Number(this.pisos);
    let cols = Number(this.divisionesColumnas);
    const filas = Number(this.divisionesFilas);
    const espaciosGlobales = Number(this.espaciosPorDivision) || 0;

    if (!p || p < 1) { alert('Ingresa al menos 1 piso.'); return; }
    if (cols > 4) { this.divisionesColumnas = 4; cols = 4; }

    this.pisosConfig = Array.from({ length: p }, () => ({
      divisiones: Array.from({ length: cols * filas }, (_, i) => ({
        id: this.getLetra(i),
        espacios: espaciosGlobales
      }))
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
    return this.pisosConfig[pisoIndex].divisiones.reduce((acc, div) => acc + (Number(div.espacios) || 0), 0);
  }

  get totalEspaciosGlobal(): number {
    return this.pisosConfig.reduce((acc, _, index) => acc + this.espaciosTotalesEnPiso(index), 0);
  }

  // ── Persistencia hacia FastAPI ─────────────────────────────────────
  guardarConfiguracionBaseDatos(): void {
    if (!this.empresa_id) {
      alert("❌ Error: No se pudo identificar la empresa. Por favor, inicia sesión nuevamente.");
      return;
    }

    const payload = {
      empresa_id: this.empresa_id,
      nombre: this.empresa,
      descripcion: this.descripcion,
      direccion: this.direccion,
      imagen_url: this.imagenUrl || null,
      latitud: this.coordX || 0,
      longitud: this.coordY || 0,
      columnas_diseno: this.divisionesColumnas,
      filas_diseno: this.divisionesFilas,
      pisos: this.pisosConfig
    };

    console.log("📤 Enviando datos masivos:", payload);

    this.http.post('http://localhost:8000/parking/configurar', payload)
      .subscribe({
        next: (response: any) => {
          console.log("✅ Servidor respondió:", response);
          alert(`¡Éxito! Estacionamiento '${this.empresa}' creado correctamente.`);
          this.configuracionIniciada = false;
        },
        error: (err) => {
          console.error("❌ Error en la petición:", err);
          const errorMsg = err.error?.detail || "No se pudo conectar con el backend.";
          alert("Error al guardar: " + errorMsg);
        }
      });
  }
}