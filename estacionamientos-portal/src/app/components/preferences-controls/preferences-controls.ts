import { Component } from '@angular/core';

import { LanguageService } from '../../core/language.service';
import { ThemeService } from '../../core/theme.service';

@Component({
  selector: 'app-preferences-controls',
  standalone: true,
  template: `
    <div class="preferences-controls" aria-label="Preferencias">
      <button type="button" (click)="theme.toggle()" [attr.aria-label]="themeLabel">
        <span aria-hidden="true">{{ theme.current() === 'light' ? '☀' : '☾' }}</span>
        <span>{{ themeLabel }}</span>
      </button>
      <button type="button" (click)="language.toggle()" [attr.aria-label]="languageLabel">
        <span aria-hidden="true">🌐</span>
        <span>{{ language.current().toUpperCase() }}</span>
      </button>
    </div>
  `,
})
export class PreferencesControls {
  constructor(
    readonly theme: ThemeService,
    readonly language: LanguageService,
  ) {}

  get themeLabel(): string {
    return this.theme.current() === 'light'
      ? this.language.t('common.light_mode')
      : this.language.t('common.dark_mode');
  }

  get languageLabel(): string {
    return this.language.current() === 'es'
      ? this.language.t('common.spanish')
      : this.language.t('common.english');
  }
}
