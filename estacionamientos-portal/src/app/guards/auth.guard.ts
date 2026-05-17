import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../auth/auth.service';

export const authGuard: CanActivateFn = (route) => {
  const authService = inject(AuthService);
  const router = inject(Router);
  const expectedRole = route.data?.['role'] as 'admin' | 'empresa' | undefined;
  const session = authService.obtenerSesion();

  if (!session) {
    return router.createUrlTree(['/login']);
  }

  if (expectedRole && session.tipo !== expectedRole) {
    return router.createUrlTree([session.tipo === 'admin' ? '/admin-panel' : '/parking']);
  }

  return true;
};

export const guestGuard: CanActivateFn = () => {
  const authService = inject(AuthService);
  const router = inject(Router);
  const session = authService.obtenerSesion();

  if (!session) return true;

  return router.createUrlTree([session.tipo === 'admin' ? '/admin-panel' : '/parking']);
};
