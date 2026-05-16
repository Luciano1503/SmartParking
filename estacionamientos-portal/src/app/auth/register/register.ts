import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { HttpClientModule, HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, HttpClientModule],
  templateUrl: './register.html',
  styleUrl: './register.css',
})
export class Register {
  registerForm: FormGroup;
  mensaje: string = '';
  cargando: boolean = false;

  constructor(private fb: FormBuilder, private http: HttpClient) {
    // Definimos el formulario con validaciones senior
    this.registerForm = this.fb.group({
      nombre_representante: ['', [Validators.required, Validators.minLength(2)]],
      apellido_representante: ['', [Validators.required, Validators.minLength(2)]],
      correo: ['', [Validators.required, Validators.email]],
      nombre_empresa: ['', [Validators.required]],
      contrasenia: ['', [Validators.required, Validators.minLength(8)]],
      confirmar_contrasenia: ['', [Validators.required]],
      aceptar_terminos: [false, [Validators.requiredTrue]]
    }, {
      validators: this.passwordMatchValidator // Validación personalizada para repetir clave
    });
  }

  // Helper para validar que las contraseñas coincidan
  passwordMatchValidator(g: FormGroup) {
    return g.get('contrasenia')?.value === g.get('confirmar_contrasenia')?.value
      ? null : { 'mismatch': true };
  }

  onSubmit() {
    if (this.registerForm.valid) {
      this.cargando = true;
      const datos = this.registerForm.value;

      // Llamada al backend de FastAPI
      this.http.post('http://localhost:8000/registro-empresa', datos)
        .subscribe({
          next: (res: any) => {
            this.mensaje = res.mensaje;
            this.cargando = false;
            this.registerForm.reset();
          },
          error: (err) => {
            console.error(err);
            this.mensaje = "Error al enviar la solicitud. Intenta de nuevo.";
            this.cargando = false;
          }
        });
    } else {
      alert("Por favor, completa correctamente todos los campos.");
    }
  }
}