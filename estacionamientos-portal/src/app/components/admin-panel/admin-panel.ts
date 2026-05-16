import { Component, OnInit, ChangeDetectorRef } from '@angular/core'; // 👈 1. Importamos ChangeDetectorRef
import { CommonModule } from '@angular/common';
import { HttpClient, HttpClientModule } from '@angular/common/http';


@Component({
  selector: 'app-admin-panel',
  standalone: true,
  imports: [CommonModule, HttpClientModule],
  templateUrl: './admin-panel.html',
})
export class AdminPanel implements OnInit {
  
  pendientes: any[] = [];
  sensoresInoperativos: any[] = [];

  private socket?: WebSocket;
  
  cargandoEmpresas: boolean = true;
  cargandoSensores: boolean = true;

  constructor(
    private http: HttpClient,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    this.cargarPendientes();
    this.cargarSensoresInoperativos();
    this.conectarWebSocket();
  }

  cargarPendientes() {
    this.cargandoEmpresas = true;
    this.http.get<any[]>('http://localhost:8000/admin/pendientes').subscribe({
      next: (data) => {
        this.pendientes = Array.isArray(data) ? data : [];
        this.cargandoEmpresas = false;
        this.cdr.detectChanges(); 
      },
      error: (err) => {
        console.error("Error al cargar pendientes:", err);
        this.cargandoEmpresas = false;
        this.cdr.detectChanges();
      }
    });
  }

  cargarSensoresInoperativos() {
    this.cargandoSensores = true;
    this.http.get<any>('http://localhost:8000/admin/sensores-inoperativos').subscribe({
      next: (data) => {
        console.log("🔥 DATA REAL RECIBIDA DEL BACKEND:", data);
        
        if (Array.isArray(data)) {
            this.sensoresInoperativos = data;
        } else if (data && data.sensores) {
            this.sensoresInoperativos = data.sensores;
        } else {
            this.sensoresInoperativos = [];
        }
        
        this.cargandoSensores = false;
        this.cdr.detectChanges(); // 👈 3. ¡Obligamos a repintar el HTML!
      },
      error: (err) => {
        console.error("❌ Error al cargar sensores inoperativos:", err);
        this.cargandoSensores = false;
        this.cdr.detectChanges(); // 👈 Repintamos incluso si hay error
      }
    });
  }

  procesarSolicitud(id: number, accion: string) {
    if (!confirm(`¿Estás seguro de que deseas ${accion} esta empresa?`)) return;

    this.http.post(`http://localhost:8000/admin/aprobar/${id}?accion=${accion}`, {}).subscribe({
      next: (res: any) => {
        alert(res.mensaje || "Operación exitosa.");
        this.cargarPendientes();
      },
      error: (err) => {
        alert("Error al procesar la solicitud");
        console.error(err);
      }
    });
  }

  private conectarWebSocket() {
    this.socket = new WebSocket('ws://localhost:8000/ws/parking');
    
    this.socket.onmessage = (event) => {
      console.log("⚡ [WS ADMIN] Alerta de hardware detectada. Recargando tabla...");
      // Si el WebSocket avisa que algo cambió, recargamos la lista silenciosamente
      this.cargarSensoresInoperativos(); 
    };

    this.socket.onclose = () => {
      console.warn("🔌 [WS ADMIN] Desconectado. Reintentando...");
      setTimeout(() => this.conectarWebSocket(), 3000);
    };
  }
}