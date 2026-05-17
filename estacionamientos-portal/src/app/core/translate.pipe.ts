import { Pipe, PipeTransform } from '@angular/core';

import { LanguageService } from './language.service';

@Pipe({
  name: 'tr',
  standalone: true,
  pure: false,
})
export class TranslatePipe implements PipeTransform {
  constructor(private readonly language: LanguageService) {}

  transform(key: string): string {
    return this.language.t(key);
  }
}
