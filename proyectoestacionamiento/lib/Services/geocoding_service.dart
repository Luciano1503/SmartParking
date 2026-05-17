import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Core/api_config.dart';

class GeocodingPlace {
  final double latitude;
  final double longitude;

  const GeocodingPlace({required this.latitude, required this.longitude});
}

class GeocodingServiceException implements Exception {
  final String message;

  const GeocodingServiceException(this.message);

  @override
  String toString() => message;
}

class GeocodingService {
  Future<GeocodingPlace> searchPlace(String query) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json'
      '?address=${Uri.encodeComponent(query)}&key=${ApiConfig.googleMapsApiKey}',
    );

    final response = await http
        .get(url)
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw const GeocodingServiceException(
            'La busqueda tardo demasiado. Verifica tu conexion.',
          ),
        );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final status = data['status']?.toString() ?? 'UNKNOWN';
    final results = data['results'] as List<dynamic>? ?? [];

    if (status == 'ZERO_RESULTS') {
      throw GeocodingServiceException('No se encontro: $query');
    }

    if (status != 'OK' || results.isEmpty) {
      throw GeocodingServiceException(
        'Error de busqueda ($status). Intenta de nuevo.',
      );
    }

    final location =
        results.first['geometry']['location'] as Map<String, dynamic>;
    return GeocodingPlace(
      latitude: (location['lat'] as num).toDouble(),
      longitude: (location['lng'] as num).toDouble(),
    );
  }
}
