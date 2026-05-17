import { Injectable } from '@angular/core';
import { Observable, retry } from 'rxjs';

import { API_CONFIG } from '../core/api.config';
import { ParkingRealtimeEvent } from '../models/parking.models';

@Injectable({
  providedIn: 'root',
})
export class RealtimeService {
  parkingUpdates(): Observable<ParkingRealtimeEvent> {
    return new Observable<ParkingRealtimeEvent>((observer) => {
      const socket = new WebSocket(API_CONFIG.parkingSocketUrl);

      socket.onmessage = (event) => {
        observer.next(JSON.parse(event.data) as ParkingRealtimeEvent);
      };

      socket.onerror = (event) => {
        observer.error(event);
      };

      socket.onclose = () => {
        observer.error(new Error('WebSocket cerrado'));
      };

      return () => socket.close();
    }).pipe(retry({ delay: 3000 }));
  }
}
