import { Component, signal } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { PreferencesControls } from './components/preferences-controls/preferences-controls';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, PreferencesControls],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App {
  protected readonly title = signal('estacionamientos-portal');
}
