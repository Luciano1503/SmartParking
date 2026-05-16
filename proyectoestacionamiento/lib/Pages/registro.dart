import 'package:flutter/material.dart';
import 'validacion.dart';
import '../Styles/registroStyles.dart';
import '../Widgets/registroWidgets.dart';
import '../Services/servicio_autenticacion.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController correoController = TextEditingController();
  
  bool _isLoading = false; 

  @override
  void dispose() {
    correoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          isLoading: _isLoading, 
                          onPressed: () async {
                            if (_isLoading) return;

                            final correo = correoController.text.trim();
                            if (correo.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Por favor ingresa un correo")),
                              );
                              return;
                            }

                            setState(() {
                              _isLoading = true;
                            });

                            final servicio = ServicioAutenticacion();
                            final exito = await servicio.registrarUsuario(correo);

                            if (!mounted) return;

                            setState(() {
                              _isLoading = false;
                            });

                            if (exito) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ValidacionPage(
                                    correo: correo,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Error al registrar usuario. Intenta nuevamente."),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "¿Ya tienes una cuenta? Inicia sesión",
                              style: RegistroStyles.loginHintTextStyle,
                            ),
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