import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';
import 'sesion_usuario.dart';

class ServicioAutenticacion {
  final String baseUrl = "http://10.0.2.2:8000";

  /// Registro de usuario (solo correo)
  Future<bool> registrarUsuario(String correo) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/registro"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"correo": correo}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error en registro: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Excepción en registrarUsuario: $e");
      return false;
    }
  }

  /// Verificación de código
  Future<bool> verificarCodigo(String correo, String codigo) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verificar"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"correo": correo, "codigo": codigo}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error en verificación: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Excepción en verificarCodigo: $e");
      return false;
    }
  }

  /// Completar formulario (datos + contraseña)
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
      final response = await http.post(
        Uri.parse("$baseUrl/formulario"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "correo": correo,
          "nombre": nombre,
          "apellido": apellido,
          "telefono": telefono,
          "dni": dni,
          "fecha_nacimiento": fechaNacimiento,
          "placa": placa,
          "modelo": modelo,
          "contrasenia": contrasenia,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error en formulario: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Excepción en completarFormulario: $e");
      return false;
    }
  }

  /// Login de usuario (correo + contraseña)
  Future<Usuario?> login(String correo, String contrasenia) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"correo": correo, "contrasenia": contrasenia}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey("error")) {
          print("Error en login: ${data["error"]}");
          return null;
        }
        final usuario = Usuario.fromJson(data);
        SesionUsuario.cargarDatos(data); // Guardar sesión
        return usuario;
      } else {
        print("Error en login: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Excepción en login: $e");
      return null;
    }
  }
}
