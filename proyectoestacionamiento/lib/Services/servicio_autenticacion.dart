import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../Models/usuario.dart';
import 'api_client.dart';
import 'sesion_usuario.dart';

class AuthResult<T> {
  final bool ok;
  final String message;
  final T? data;

  const AuthResult({required this.ok, required this.message, this.data});

  const AuthResult.success({String message = 'Operacion exitosa', T? data})
    : this(ok: true, message: message, data: data);

  const AuthResult.failure(String message)
    : this(ok: false, message: message, data: null);
}

class ServicioAutenticacion {
  final ApiClient _apiClient;

  const ServicioAutenticacion({ApiClient apiClient = const ApiClient()})
    : _apiClient = apiClient;

  String _extractMessage(String body, String fallback) {
    try {
      final data = jsonDecode(body);
      if (data is Map<String, dynamic>) {
        final detail =
            data['detail'] ??
            data['detalle'] ??
            data['error'] ??
            data['mensaje'];
        if (detail is String && detail.trim().isNotEmpty) return detail;
      }
    } catch (_) {}
    return fallback;
  }

  Future<AuthResult<void>> registrarUsuario(String correo) async {
    try {
      final response = await _apiClient.post('/registro', {'correo': correo});
      if (response.statusCode == 200) {
        return const AuthResult.success(message: 'Codigo enviado al correo.');
      }
      return AuthResult.failure(
        _extractMessage(response.body, 'No se pudo enviar el codigo.'),
      );
    } catch (error) {
      debugPrint('Excepcion en registrarUsuario: $error');
      return const AuthResult.failure(
        'No se pudo conectar con el servidor. Intenta nuevamente.',
      );
    }
  }

  Future<AuthResult<void>> verificarCodigo(String correo, String codigo) async {
    try {
      final response = await _apiClient.post('/verificar', {
        'correo': correo,
        'codigo': codigo,
      });
      if (response.statusCode == 200) {
        return const AuthResult.success(message: 'Usuario verificado.');
      }
      return AuthResult.failure(
        _extractMessage(response.body, 'Codigo invalido o expirado.'),
      );
    } catch (error) {
      debugPrint('Excepcion en verificarCodigo: $error');
      return const AuthResult.failure(
        'No se pudo verificar el codigo. Intenta nuevamente.',
      );
    }
  }

  Future<AuthResult<void>> completarFormulario(
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

      if (response.statusCode != 200) {
        return AuthResult.failure(
          _extractMessage(response.body, 'No se pudo completar el registro.'),
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data.containsKey('error')) {
        return AuthResult.failure(data['error'].toString());
      }

      return const AuthResult.success(message: 'Registro completado.');
    } catch (error) {
      debugPrint('Excepcion en completarFormulario: $error');
      return const AuthResult.failure(
        'No se pudo guardar el formulario. Intenta nuevamente.',
      );
    }
  }

  Future<AuthResult<Usuario>> login(String correo, String contrasenia) async {
    try {
      final response = await _apiClient.post('/login', {
        'correo': correo,
        'contrasenia': contrasenia,
      });

      if (response.statusCode != 200) {
        debugPrint('Error en login: ${response.body}');
        return AuthResult.failure(
          _extractMessage(response.body, 'No se pudo iniciar sesion.'),
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data.containsKey('error')) {
        final message = data['error'].toString();
        debugPrint('Error en login: $message');
        return AuthResult.failure(message);
      }

      final usuario = Usuario.fromJson(data);
      SesionUsuario.cargarDatos(data);
      return AuthResult.success(message: 'Login exitoso.', data: usuario);
    } catch (error) {
      debugPrint('Excepcion en login: $error');
      return const AuthResult.failure(
        'No se pudo conectar con el servidor. Intenta nuevamente.',
      );
    }
  }
}
