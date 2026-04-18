class Usuario {
  final String correo;
  final String nombre;
  final String apellido;
  final String telefono;
  final String dni;
  final String fechaNacimiento;
  final String placa;
  final String modelo;

  Usuario({
    required this.correo,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.dni,
    required this.fechaNacimiento,
    required this.placa,
    required this.modelo,
  });

  /// Convertir JSON a objeto Usuario
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      correo: json["correo"],
      nombre: json["nombre"],
      apellido: json["apellido"],
      telefono: json["telefono"],
      dni: json["dni"],
      fechaNacimiento: json["fecha_nacimiento"],
      placa: json["placa"],
      modelo: json["modelo"],
    );
  }

  /// Convertir objeto Usuario a JSON
  Map<String, dynamic> toJson() {
    return {
      "correo": correo,
      "nombre": nombre,
      "apellido": apellido,
      "telefono": telefono,
      "dni": dni,
      "fecha_nacimiento": fechaNacimiento,
      "placa": placa,
      "modelo": modelo,
    };
  }
}
