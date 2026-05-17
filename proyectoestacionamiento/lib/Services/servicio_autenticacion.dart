import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../Models/usuario.dart';
import 'api_client.dart';
import 'sesion_usuario.dart';

class ServicioAutenticacion {
  final ApiClient _apiClient;

  const ServicioAutenticacion({ApiClient apiClient = const ApiClient()})
    : _apiClient = apiClient;

  Future<bool> registrarUsuario(String correo) async {
    try {
      final response = await _apiClient.post('/registro', {'correo': correo});
      return response.statusCode == 200;
    } catch (error) {
      debugPrint('Excepcion en registrarUsuario: $error');
      return false;
    }
  }

  Future<bool> verificarCodigo(String correo, String codigo) async {
    try {
      final response = await _apiClient.post('/verificar', {
        'correo': correo,
        'codigo': codigo,
      });
      return response.statusCode == 200;
    } catch (error) {
      debugPrint('Excepcion en verificarCodigo: $error');
      return false;
    }
  }

  Future<bool> completarFormulario(
    String correo,
    String nombre,
    String apellido,
    String telefono,
    String dni,
    String fechaNacimiento,
    String placa,
    String modelo,
    String contrasenia,
  ) async {
    try {
      final response = await _apiClient.post('/formulario', {
        'correo': correo,
        'nombre': nombre,
        'apellido': apellido,
        'telefono': telefono,
        'dni': dni,
        'fecha_nacimiento': fechaNacimiento,
        'placa': placa,
        'modelo': modelo,
        'contrasenia': contrasenia,
      });
      return response.statusCode == 200;
    } catch (error) {
      debugPrint('Excepcion en completarFormulario: $error');
      return false;
    }
  }

  Future<Usuario?> login(String correo, String contrasenia) async {
    try {
      final response = await _apiClient.post('/login', {
        'correo': correo,
        'contrasenia': contrasenia,
      });

      if (response.statusCode != 200) {
        debugPrint('Error en login: ${response.body}');
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data.containsKey('error')) {
        debugPrint('Error en login: ${data['error']}');
        return null;
      }

      final usuario = Usuario.fromJson(data);
      SesionUsuario.cargarDatos(data);
      return usuario;
    } catch (error) {
      debugPrint('Excepcion en login: $error');
      return null;
    }
  }
}
