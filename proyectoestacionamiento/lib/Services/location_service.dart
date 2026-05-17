import 'package:geolocator/geolocator.dart';

class LocationServiceException implements Exception {
  final String message;

  const LocationServiceException(this.message);

  @override
  String toString() => message;
}

class LocationService {
  Future<Position> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceException(
        'Por favor, activa tu ubicacion para usar este apartado.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationServiceException('Permiso de ubicacion denegado.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationServiceException(
        'Activa el permiso de ubicacion desde ajustes.',
      );
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).timeout(
      const Duration(seconds: 15),
      onTimeout: () => throw const LocationServiceException(
        'Tiempo de espera agotado al obtener ubicacion.',
      ),
    );
  }
}
