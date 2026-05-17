import { Injectable, signal } from '@angular/core';

export type AppTheme = 'light' | 'dark';

@Injectable({ providedIn: 'root' })
export class ThemeService {
  private readonly storageKey = 'smartparking.theme';
  private readonly themeSignal = signal<AppTheme>(this.getInitialTheme());

  readonly current = this.themeSignal.asReadonly();

  constructor() {
    this.applyTheme(this.themeSignal());
  }

  toggle(): void {
    this.setTheme(this.themeSignal() === 'light' ? 'dark' : 'light');
  }

  setTheme(theme: AppTheme): void {
    this.themeSignal.set(theme);
    this.applyTheme(theme);
    if (typeof window !== 'undefined') {
      window.localStorage.setItem(this.storageKey, theme);
    }
  }

  private getInitialTheme(): AppTheme {
    if (typeof window === 'undefined') return 'light';
    return window.localStorage.getItem(this.storageKey) === 'dark' ? 'dark' : 'light';
  }

  private applyTheme(theme: AppTheme): void {
    if (typeof document === 'undefined') return;
    document.documentElement.dataset['theme'] = theme;
  }
}
