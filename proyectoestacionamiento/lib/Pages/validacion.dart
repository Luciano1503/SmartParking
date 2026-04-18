import 'package:flutter/material.dart';
import 'formulario.dart';
import '../Styles/validacionStyles.dart';
import '../Widgets/validacionWidgets.dart';
import '../Services/servicio_autenticacion.dart';

class ValidacionPage extends StatefulWidget {
  final String correo;

  const ValidacionPage({
    super.key,
    required this.correo,
  });

  @override
  State<ValidacionPage> createState() => _ValidacionPageState();
}

class _ValidacionPageState extends State<ValidacionPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _codigoController = TextEditingController();
  final List<TextEditingController> _digitControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: ValidacionStyles.animationDuration,
    );

    _fadeIn = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideUp = Tween<Offset>(
      begin: ValidacionStyles.slideBeginOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();

    for (final c in _digitControllers) {
      c.dispose();
    }

    for (final f in _focusNodes) {
      f.dispose();
    }

    _codigoController.dispose();
    super.dispose();
  }

  void _onDigitChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    _codigoController.text = _digitControllers.map((c) => c.text).join();
  }

  String _buildMaskedEmail(String email) {
    final atIndex = email.indexOf('@');

    if (atIndex > 2) {
      return '${email.substring(0, 2)}***${email.substring(atIndex)}';
    }

    return email;
  }

  Future<void> _validarCodigo() async {
    final servicio = ServicioAutenticacion();
    final exito = await servicio.verificarCodigo(
      widget.correo,
      _codigoController.text,
    );

    if (exito) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FormularioPage(correo: widget.correo),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Código inválido o expirado"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final maskedEmail = _buildMaskedEmail(widget.correo);

    return Scaffold(
      body: Stack(
        children: [
          const ValidationBackground(),
          Positioned(
            top: 40,
            right: -80,
            child: GlowCircle(
              size: 240,
              color: ValidacionStyles.glowCyan,
            ),
          ),
          Positioned(
            bottom: 40,
            left: -60,
            child: GlowCircle(
              size: 200,
              color: ValidacionStyles.glowBlue,
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: Column(
                  children: [
                    ValidationTopBar(
                      onBack: () => Navigator.pop(context),
                      currentStep: 2,
                      totalSteps: 2,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: ValidacionStyles.pagePadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            const ValidationBrandHeader(),
                            const SizedBox(height: 32),
                            const ValidationTitleSection(),
                            const SizedBox(height: 24),
                            EmailSentBanner(maskedEmail: maskedEmail),
                            const SizedBox(height: 28),
                            ValidationOtpCard(
                              digitControllers: _digitControllers,
                              focusNodes: _focusNodes,
                              onDigitChanged: _onDigitChanged,
                            ),
                            const SizedBox(height: 16),
                            const ResendCodeRow(),
                            const SizedBox(height: 28),
                            GradientActionButton(
                              label: "Validar usuario",
                              icon: Icons.verified_rounded,
                              onPressed: _validarCodigo,
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
