import { Routes } from '@angular/router';
import { Login } from './auth/login/login';
import { Register } from './auth/register/register';
import { AdminPanel } from './components/admin-panel/admin-panel';
import { Parking } from './auth/parking/parking';
import { authGuard, guestGuard } from './guards/auth.guard';

export const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'login', component: Login, canActivate: [guestGuard] },
  { path: 'register', component: Register, canActivate: [guestGuard] },
  { path: 'admin-panel', component: AdminPanel, canActivate: [authGuard], data: { role: 'admin' } },
  { path: 'parking', component: Parking, canActivate: [authGuard], data: { role: 'empresa' } },
  { path: '**', redirectTo: 'login' },
];
