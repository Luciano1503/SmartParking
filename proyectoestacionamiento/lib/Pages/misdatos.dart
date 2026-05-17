import 'package:flutter/material.dart';
import '../Core/app_localizations.dart';
import '../Styles/misdatos_styles.dart';
import '../Widgets/misdatos_widgets.dart';
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
        title: Text(context.tr('profile.title')),
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
              nombre: SesionUsuario.usuario?.nombre ?? context.tr('profile.unavailable'),
              apellido: SesionUsuario.usuario?.apellido ?? "",
              correo: SesionUsuario.usuario?.correo ?? context.tr('profile.unavailable'),
            ),

            const SizedBox(height: 14),

            // Datos personales
            InfoPersonalCard(
              nombre: SesionUsuario.usuario?.nombre ?? context.tr('profile.unavailable'),
              apellido: SesionUsuario.usuario?.apellido ?? "",
              dni: SesionUsuario.usuario?.dni ?? context.tr('profile.unavailable'),
              telefono: SesionUsuario.usuario?.telefono ?? context.tr('profile.unavailable'),
              fechaNacimiento:
                  SesionUsuario.usuario?.fechaNacimiento ??
                  context.tr('profile.unavailable'),
            ),

            const SizedBox(height: 12),

            // Datos del vehículo
            VehiculoCard(
              placa: SesionUsuario.usuario?.placa ?? context.tr('profile.unavailable'),
              modelo: SesionUsuario.usuario?.modelo ?? context.tr('profile.unavailable'),
            ),

            const SizedBox(height: 24),

            PrimaryButton(
              label: context.tr('profile.edit'),
              icon: Icons.edit_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.tr('profile.in_development'))),
                );
              },
            ),
            const SizedBox(height: 10),
            SecondaryButton(
              label: context.tr('profile.logout'),
              icon: Icons.logout_rounded,
              onPressed: () {
                SesionUsuario.limpiar();
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
