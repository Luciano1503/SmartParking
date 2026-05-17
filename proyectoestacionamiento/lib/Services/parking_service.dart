import 'dart:convert';

import '../Models/parking_model.dart';
import 'api_client.dart';

class ParkingService {
  final ApiClient _apiClient;

  const ParkingService({ApiClient apiClient = const ApiClient()})
    : _apiClient = apiClient;

  Future<List<Estacionamiento>> getEstacionamientos() async {
    try {
      final response = await _apiClient.get('/parking/lista');

      if (response.statusCode != 200) {
        throw Exception('Error al cargar datos del servidor');
      }

      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((item) => Estacionamiento.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw Exception('Error de conexion: $error');
    }
  }

  Future<List<dynamic>> getDetalleMapa(int estacionamientoId) async {
    try {
      final response = await _apiClient.get(
        '/parking/detalle/$estacionamientoId',
      );

      if (response.statusCode != 200) {
        throw Exception('Error al cargar el mapa del estacionamiento');
      }

      return jsonDecode(response.body) as List<dynamic>;
    } catch (error) {
      throw Exception('Error de conexion: $error');
    }
  }
}
