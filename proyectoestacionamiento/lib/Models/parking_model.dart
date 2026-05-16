class Estacionamiento {
  final int id;
  final String nombre;
  final String descripcion;
  final String direccion;
  final String? imagenUrl;
  final int totalEspacios;

  Estacionamiento({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.direccion,
    this.imagenUrl,
    required this.totalEspacios,
  });

  factory Estacionamiento.fromJson(Map<String, dynamic> json) {
    return Estacionamiento(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      direccion: json['direccion'],
      imagenUrl: json['imagen_url'],
      totalEspacios: json['total_espacios'] ?? 0,
    );
  }
}