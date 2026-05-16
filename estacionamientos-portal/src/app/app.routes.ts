import { Routes } from '@angular/router';
import { Login } from './auth/login/login';
import { Register } from './auth/register/register';
import { AdminPanel } from './components/admin-panel/admin-panel';
import { Parking } from './auth/parking/parking';

export const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'login', component: Login },
  { path: 'register', component: Register },
  { path: 'admin-panel', component: AdminPanel },
  { path: 'parking', component: Parking },
];