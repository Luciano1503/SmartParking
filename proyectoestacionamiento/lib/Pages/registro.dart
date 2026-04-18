import 'package:flutter/material.dart';
import 'validacion.dart';
import '../Styles/registroStyles.dart';
import '../Widgets/registroWidgets.dart';
import '../Services/servicio_autenticacion.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController correoController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          const RegisterBackground(),
          Positioned(
            top: -60,
            left: -80,
            child: GlowCircle(
              size: 260,
              color: RegistroStyles.glowCyan,
            ),
          ),
          Positioned(
            bottom: 80,
            right: -60,
            child: GlowCircle(
              size: 200,
              color: RegistroStyles.glowBlue,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                RegisterTopBar(
                  onBack: () => Navigator.pop(context),
                  currentStep: 1,
                  totalSteps: 2,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: RegistroStyles.pagePadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        const RegisterBrandHeader(),
                        const SizedBox(height: 32),
                        const RegisterTitleSection(),
                        const SizedBox(height: 28),
                        const RegisterInfoBanner(),
                        const SizedBox(height: 28),
                        RegisterEmailCard(
                          controller: correoController,
                        ),
                        const SizedBox(height: 32),
                        GradientActionButton(
                          label: "Enviar código de verificación",
                          icon: Icons.send_rounded,
                          onPressed: () async {
                            final servicio = ServicioAutenticacion();
                            final exito = await servicio.registrarUsuario(
                              correoController.text,
                            );

                            if (exito) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ValidacionPage(
                                    correo: correoController.text,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Error al registrar usuario"),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            "¿Ya tienes una cuenta? Inicia sesión",
                            style: RegistroStyles.loginHintTextStyle,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
