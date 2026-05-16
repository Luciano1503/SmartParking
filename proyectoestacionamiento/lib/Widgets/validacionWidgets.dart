import 'package:flutter/material.dart';
import '../Styles/validacionStyles.dart';

class ValidationBackground extends StatelessWidget {
  const ValidationBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ValidacionStyles.backgroundDecoration,
    );
  }
}

class GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const GlowCircle({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
        ),
      ),
    );
  }
}

class ValidationTopBar extends StatelessWidget {
  final VoidCallback onBack;
  final int currentStep;
  final int totalSteps;

  const ValidationTopBar({
    super.key,
    required this.onBack,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ValidacionStyles.topBarPadding,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: ValidacionStyles.mutedBlue,
              size: 20,
            ),
            onPressed: onBack,
          ),
          const Spacer(),
          StepIndicator(
            current: currentStep,
            total: totalSteps,
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class StepIndicator extends StatelessWidget {
  final int current;
  final int total;

  const StepIndicator({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ValidacionStyles.indicatorPadding,
      decoration: ValidacionStyles.stepIndicatorDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(total, (i) {
          final active = i + 1 == current;
          return Container(
            width: active ? 18 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: active
                  ? const LinearGradient(
                      colors: [
                        ValidacionStyles.primaryCyan,
                        ValidacionStyles.primaryBlue,
                      ],
                    )
                  : null,
              color: active ? null : ValidacionStyles.darkBorder,
            ),
          );
        }),
      ),
    );
  }
}

class ValidationBrandHeader extends StatelessWidget {
  const ValidationBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: ValidacionStyles.brandLogoDecoration,
          child: const Icon(
            Icons.local_parking_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  ValidacionStyles.primaryCyan,
                  ValidacionStyles.lightCyan,
                ],
              ).createShader(bounds),
              child: const Text(
                "SmartParking",
                style: ValidacionStyles.brandTitleStyle,
              ),
            ),
            const Text(
              "SOLUTIONS",
              style: ValidacionStyles.brandSubtitleStyle,
            ),
          ],
        ),
      ],
    );
  }
}

class ValidationTitleSection extends StatelessWidget {
  const ValidationTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Verificar cuenta",
          style: ValidacionStyles.pageTitleStyle,
        ),
        SizedBox(height: 6),
        Text(
          "Paso 2 de 2 — Ingresa tu código",
          style: ValidacionStyles.pageSubtitleStyle,
        ),
      ],
    );
  }
}

class EmailSentBanner extends StatelessWidget {
  final String maskedEmail;

  const EmailSentBanner({
    super.key,
    required this.maskedEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ValidacionStyles.emailBannerPadding,
      decoration: ValidacionStyles.emailBannerDecoration,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: ValidacionStyles.emailBannerIconDecoration,
            child: const Icon(
              Icons.mark_email_read_outlined,
              color: ValidacionStyles.primaryCyan,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Código enviado a",
                  style: ValidacionStyles.emailBannerLabelStyle,
                ),
                const SizedBox(height: 2),
                Text(
                  maskedEmail,
                  style: ValidacionStyles.emailBannerValueStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ValidationOtpCard extends StatelessWidget {
  final List<TextEditingController> digitControllers;
  final List<FocusNode> focusNodes;
  final void Function(String value, int index) onDigitChanged;

  const ValidationOtpCard({
    super.key,
    required this.digitControllers,
    required this.focusNodes,
    required this.onDigitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ValidacionStyles.otpCardPadding,
      decoration: ValidacionStyles.otpCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Código de verificación",
            style: ValidacionStyles.otpTitleStyle,
          ),
          const SizedBox(height: 4),
          const Text(
            "Ingresa los 6 dígitos recibidos en tu correo",
            style: ValidacionStyles.otpSubtitleStyle,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (i) {
              return OtpBox(
                controller: digitControllers[i],
                focusNode: focusNodes[i],
                onChanged: (val) => onDigitChanged(val, i),
              );
            }),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Icon(
                Icons.timer_outlined,
                color: ValidacionStyles.hintBlue,
                size: 14,
              ),
              SizedBox(width: 6),
              Text(
                "El código expira en 10 minutos",
                style: ValidacionStyles.expiryHintStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const OtpBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 52,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: ValidacionStyles.otpInputTextStyle,
        onChanged: onChanged,
        decoration: ValidacionStyles.otpInputDecoration,
      ),
    );
  }
}

class ResendCodeRow extends StatelessWidget {
  const ResendCodeRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "¿No recibiste el código? ",
          style: ValidacionStyles.resendBaseStyle,
        ),
        GestureDetector(
          onTap: () {
            // Lógica de reenvío
          },
          child: const Text(
            "Reenviar",
            style: ValidacionStyles.resendActionStyle,
          ),
        ),
      ],
    );
  }
}

class GradientActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  
  // 🔥 1. Agregado el indicador de carga
  final bool isLoading; 

  const GradientActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isLoading = false, // 🔥 2. Falso por defecto
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: ValidacionStyles.gradientButtonDecoration,
        child: ElevatedButton( // Cambiado a ElevatedButton normal para customizar el Row
          style: ValidacionStyles.transparentButtonStyle,
          onPressed: isLoading ? () {} : onPressed, // 🔥 3. Bloqueo
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: ValidacionStyles.buttonTextStyle,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}