import 'package:flutter/material.dart';
import 'validacion.dart';
import '../Core/app_localizations.dart';
import '../Styles/registro_styles.dart';
import '../Widgets/legal_links.dart';
import '../Widgets/registro_widgets.dart';
import '../Widgets/preferences_controls.dart';
import '../Services/servicio_autenticacion.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final ServicioAutenticacion _authService = const ServicioAutenticacion();
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
            child: GlowCircle(size: 260, color: RegistroStyles.glowCyan),
          ),
          Positioned(
            bottom: 80,
            right: -60,
            child: GlowCircle(size: 200, color: RegistroStyles.glowBlue),
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
                        RegisterEmailCard(controller: correoController),
                        const SizedBox(height: 16),
                        const LegalLinksCard(),
                        const SizedBox(height: 32),
                        GradientActionButton(
                          label: context.tr('register.send_code'),
                          icon: Icons.send_rounded,
                          isLoading: _isLoading,
                          onPressed: () async {
                            if (_isLoading) return;

                            final correo = correoController.text.trim();
                            if (correo.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    context.tr('register.enter_email'),
                                  ),
                                ),
                              );
                              return;
                            }

                            setState(() {
                              _isLoading = true;
                            });

                            final exito = await _authService.registrarUsuario(
                              correo,
                            );

                            if (!context.mounted) return;

                            setState(() {
                              _isLoading = false;
                            });

                            if (exito) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ValidacionPage(correo: correo),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(context.tr('register.error')),
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
                              context.tr('register.already_account'),
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
          const Positioned(
            top: 10,
            right: 12,
            child: SafeArea(child: PreferencesControls(compact: true)),
          ),
        ],
      ),
    );
  }
}
