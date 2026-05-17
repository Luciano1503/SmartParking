import '../Models/usuario.dart';

class SesionUsuario {
  static Usuario? usuario;

  /// Guardar datos del usuario después de login o registro
  static void cargarDatos(Map<String, dynamic> data) {
    usuario = Usuario.fromJson(data);
  }

  /// Limpiar sesión al cerrar sesión
  static void limpiar() {
    usuario = null;
  }

  /// Obtener nombre completo (para mostrar en MapaPage)
  static String nombreCompleto() {
    if (usuario != null) {
      return "${usuario!.nombre} ${usuario!.apellido}";
    }
    return "Usuario";
  }
}
