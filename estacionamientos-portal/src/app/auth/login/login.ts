import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';

import { AuthService } from '../auth.service';
import { WebSession } from '../../models/auth.models';
import { AuthApiService } from '../../services/auth-api.service';
import { LanguageService } from '../../core/language.service';
import { TranslatePipe } from '../../core/translate.pipe';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule, TranslatePipe],
  templateUrl: './login.html',
  styleUrl: './login.css',
})
export class Login {
  datosLogin = {
    correo: '',
    contrasenia: '',
  };

  cargando = false;
  mensajeError = '';

  constructor(
    private readonly authApi: AuthApiService,
    private readonly authService: AuthService,
    private readonly language: LanguageService,
    private readonly router: Router,
  ) {}

  onSubmit(): void {
    if (!this.datosLogin.correo || !this.datosLogin.contrasenia) {
      this.mensajeError = this.language.t('login.complete_fields');
      return;
    }

    this.cargando = true;
    this.mensajeError = '';

    this.authApi.loginWeb(this.datosLogin).subscribe({
      next: (res) => {
        this.cargando = false;

        if ('status' in res && res.status === 'success') {
          this.authService.guardarSesion(res as WebSession);
          this.router.navigate([res.tipo === 'admin' ? '/admin-panel' : '/parking'], {
            replaceUrl: true,
          });
          return;
        }

        this.mensajeError = 'error' in res ? res.error : this.language.t('login.failed');
      },
      error: (err) => {
        this.cargando = false;
        this.mensajeError = err.error?.error || this.language.t('login.connection_error');
      },
    });
  }
}
