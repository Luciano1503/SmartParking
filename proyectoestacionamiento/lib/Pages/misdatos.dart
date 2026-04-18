import 'package:flutter/material.dart';
import '../Styles/misdatosStyles.dart';
import '../Widgets/misdatosWidgets.dart';
import '../Services/sesion_usuario.dart';
import '../Pages/main.dart';

class MisDatosPage extends StatelessWidget {
  const MisDatosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MisDatosStyles.lightBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Mis datos"),
        backgroundColor: MisDatosStyles.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: MisDatosStyles.pagePadding,
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Banner con nombre completo
            PerfilBanner(
              nombre: SesionUsuario.usuario?.nombre ?? "No disponible",
              apellido: SesionUsuario.usuario?.apellido ?? "",
              correo: SesionUsuario.usuario?.correo ?? "No disponible",
            ),

            const SizedBox(height: 14),

            // Datos personales
            InfoPersonalCard(
              nombre: SesionUsuario.usuario?.nombre ?? "No disponible",
              apellido: SesionUsuario.usuario?.apellido ?? "",
              dni: SesionUsuario.usuario?.dni ?? "No disponible",
              telefono: SesionUsuario.usuario?.telefono ?? "No disponible",
              fechaNacimiento: SesionUsuario.usuario?.fechaNacimiento ?? "No disponible",
            ),

            const SizedBox(height: 12),

            // Datos del vehículo
            VehiculoCard(
              placa: SesionUsuario.usuario?.placa ?? "No disponible",
              modelo: SesionUsuario.usuario?.modelo ?? "No disponible",
            ),

            const SizedBox(height: 24),

            PrimaryButton(
              label: "Modificar mis datos",
              icon: Icons.edit_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Funcionalidad en desarrollo")),
                );
              },
            ),
            const SizedBox(height: 10),
            SecondaryButton(
              label: "Cerrar sesión",
              icon: Icons.logout_rounded,
              onPressed: () {
                SesionUsuario.limpiar(); // ✅ limpiar datos
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
