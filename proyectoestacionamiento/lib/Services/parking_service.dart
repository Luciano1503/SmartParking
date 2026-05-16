import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/parking_model.dart';

class ParkingService {
  final String baseUrl = "http://10.131.131.148:8000"; 

  Future<List<Estacionamiento>> getEstacionamientos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/parking/lista'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Estacionamiento.fromJson(item)).toList();
      } else {
        throw Exception('Error al cargar datos del servidor');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}