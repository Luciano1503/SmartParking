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
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      direccion: json['direccion'] as String,
      imagenUrl: json['imagen_url'] as String?,
      totalEspacios: (json['total_espacios'] as num?)?.toInt() ?? 0,
    );
  }
}
