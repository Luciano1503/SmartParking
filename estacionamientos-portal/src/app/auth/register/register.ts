import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';

import { CompanyRegisterRequest } from '../../models/auth.models';
import { AuthApiService } from '../../services/auth-api.service';
import { LanguageService } from '../../core/language.service';
import { TranslatePipe } from '../../core/translate.pipe';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, TranslatePipe],
  templateUrl: './register.html',
  styleUrl: './register.css',
})
export class Register {
  registerForm: FormGroup;
  mensaje = '';
  cargando = false;
  legalModalOpen = false;
  legalTitle = '';
  legalContent = '';
  legalLoading = false;

  constructor(
    private readonly fb: FormBuilder,
    private readonly authApi: AuthApiService,
    private readonly language: LanguageService,
  ) {
    this.registerForm = this.fb.group(
      {
        nombre_representante: ['', [Validators.required, Validators.minLength(2)]],
        apellido_representante: ['', [Validators.required, Validators.minLength(2)]],
        correo: ['', [Validators.required, Validators.email]],
        nombre_empresa: ['', [Validators.required]],
        contrasenia: ['', [Validators.required, Validators.minLength(8)]],
        confirmar_contrasenia: ['', [Validators.required]],
        aceptar_terminos: [false, [Validators.requiredTrue]],
      },
      {
        validators: this.passwordMatchValidator,
      },
    );
  }

  passwordMatchValidator(group: FormGroup) {
    return group.get('contrasenia')?.value === group.get('confirmar_contrasenia')?.value
      ? null
      : { mismatch: true };
  }

  onSubmit(): void {
    if (!this.registerForm.valid) {
      alert(this.language.t('register.complete_fields'));
      return;
    }

    this.cargando = true;
    const { confirmar_contrasenia, aceptar_terminos, ...payload } = this.registerForm.value;

    this.authApi.registerCompany(payload as CompanyRegisterRequest).subscribe({
      next: (res) => {
        if (res.status === 'error') {
          this.mensaje = res.detalle ?? this.language.t('register.error');
          this.cargando = false;
          return;
        }

        this.mensaje = res.correo_enviado === false
          ? this.language.t('register.sent_email_warning')
          : res.mensaje ?? this.language.t('register.sent');
        this.cargando = false;
        this.registerForm.reset();
      },
      error: (err) => {
        console.error(err);
        this.mensaje = this.language.t('register.error');
        this.cargando = false;
      },
    });
  }

  async openLegal(type: 'terms' | 'privacy', event: Event): Promise<void> {
    event.preventDefault();

    const language = this.language.current();
    const titleKey = type === 'terms' ? 'legal.terms_title' : 'legal.privacy_title';
    const fileName = type === 'terms' ? `terms_${language}.txt` : `privacy_${language}.txt`;

    this.legalTitle = this.language.t(titleKey);
    this.legalContent = this.language.t('legal.loading');
    this.legalLoading = true;
    this.legalModalOpen = true;

    try {
      const response = await fetch(`/legal/${fileName}`, { cache: 'no-store' });
      if (!response.ok) throw new Error(`Legal document not found: ${fileName}`);
      this.legalContent = await response.text();
    } catch (error) {
      console.error(error);
      this.legalContent = this.language.t('legal.load_error');
    } finally {
      this.legalLoading = false;
    }
  }

  closeLegal(): void {
    this.legalModalOpen = false;
  }
}
