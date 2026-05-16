import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { HttpClient, HttpClientModule } from '@angular/common/http';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule, HttpClientModule],
  templateUrl: './login.html',
  styleUrl: './login.css',
})
export class Login {
  datosLogin = {
    correo: '',
    contrasenia: ''
  };

  cargando: boolean = false;
  mensajeError: string = '';

  constructor(private http: HttpClient, private router: Router) {}

  onSubmit() {
    if (!this.datosLogin.correo || !this.datosLogin.contrasenia) {
      this.mensajeError = "Por favor, completa todos los campos.";
      return;
    }

    this.cargando = true;
    this.mensajeError = '';

    this.http.post('http://localhost:8000/login-web', this.datosLogin).subscribe({
      next: (res: any) => {
        this.cargando = false;
        
        if (res.status === 'success') {
          // Guardamos datos de sesión
          localStorage.setItem('tipo_usuario', res.tipo);
          
          // Redirección limpia con Angular Router
          if (res.tipo === 'admin') {
            this.router.navigate(['/admin-panel']); 
          } else {
            this.router.navigate(['/parking']);
          }
        } 
        else if (res.error) {
          // Manejo de errores controlados desde el backend
          this.mensajeError = res.error;
        }
      },
      error: (err) => {
        this.cargando = false;
        this.mensajeError = err.error?.error || "Error de conexión con el servidor.";
      }
    });
  }
}