import 'package:flutter/material.dart';
import '../Styles/registroStyles.dart';

class RegisterBackground extends StatelessWidget {
  const RegisterBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: RegistroStyles.backgroundDecoration,
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

class RegisterTopBar extends StatelessWidget {
  final VoidCallback onBack;
  final int currentStep;
  final int totalSteps;

  const RegisterTopBar({
    super.key,
    required this.onBack,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: RegistroStyles.topBarPadding,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: RegistroStyles.mutedBlue,
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
      padding: RegistroStyles.indicatorPadding,
      decoration: RegistroStyles.stepIndicatorDecoration,
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
                        RegistroStyles.primaryCyan,
                        RegistroStyles.primaryBlue,
                      ],
                    )
                  : null,
              color: active ? null : RegistroStyles.darkBorder,
            ),
          );
        }),
      ),
    );
  }
}

class RegisterBrandHeader extends StatelessWidget {
  const RegisterBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: RegistroStyles.brandLogoDecoration,
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
                  RegistroStyles.primaryCyan,
                  RegistroStyles.lightCyan,
                ],
              ).createShader(bounds),
              child: const Text(
                "SmartParking",
                style: RegistroStyles.brandTitleStyle,
              ),
            ),
            const Text(
              "SOLUTIONS",
              style: RegistroStyles.brandSubtitleStyle,
            ),
          ],
        ),
      ],
    );
  }
}

class RegisterTitleSection extends StatelessWidget {
  const RegisterTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Crear cuenta",
          style: RegistroStyles.pageTitleStyle,
        ),
        const SizedBox(height: 6),
        Text(
          "Paso 1 de 2 — Verificación de correo",
          style: RegistroStyles.pageSubtitleStyle,
        ),
      ],
    );
  }
}

class RegisterInfoBanner extends StatelessWidget {
  const RegisterInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: RegistroStyles.infoBannerPadding,
      decoration: RegistroStyles.infoBannerDecoration,
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: RegistroStyles.primaryCyan,
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Introduce tu correo electrónico para validar tu cuenta. Te enviaremos un código de verificación de 6 dígitos.",
              style: RegistroStyles.infoBannerTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class RegisterEmailCard extends StatelessWidget {
  final TextEditingController controller;

  const RegisterEmailCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: RegistroStyles.emailCardPadding,
      decoration: RegistroStyles.emailCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Correo electrónico",
            style: RegistroStyles.sectionLabelStyle,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            style: RegistroStyles.inputTextStyle,
            decoration: RegistroStyles.emailInputDecoration,
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(
                Icons.shield_outlined,
                color: RegistroStyles.hintBlue,
                size: 14,
              ),
              SizedBox(width: 6),
              Text(
                "Tu información está protegida y es privada",
                style: RegistroStyles.shieldHintStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RegisterNextStepsSection extends StatelessWidget {
  const RegisterNextStepsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "¿Qué sucede a continuación?",
          style: RegistroStyles.nextStepsTitleStyle,
        ),
        SizedBox(height: 12),
        StepRow(
          icon: Icons.mark_email_unread_outlined,
          title: "Recibe el código",
          subtitle: "En menos de 2 minutos en tu bandeja",
        ),
        SizedBox(height: 10),
        StepRow(
          icon: Icons.pin_outlined,
          title: "Ingresa los 6 dígitos",
          subtitle: "Válido por 10 minutos tras el envío",
        ),
        SizedBox(height: 10),
        StepRow(
          icon: Icons.check_circle_outline_rounded,
          title: "Completa tu perfil",
          subtitle: "Configura tu cuenta y empieza a usar la app",
        ),
      ],
    );
  }
}

class StepRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const StepRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: RegistroStyles.nextStepIconDecoration,
          child: Icon(
            icon,
            color: RegistroStyles.primaryCyan,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: RegistroStyles.stepTitleStyle,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: RegistroStyles.stepSubtitleStyle,
              ),
            ],
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
  
  // 🔥 1. Recibimos la variable isLoading
  final bool isLoading; 

  const GradientActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isLoading = false, // 🔥 2. Falso por defecto para que no rompa otros usos
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: RegistroStyles.gradientButtonDecoration,
        child: ElevatedButton( // Cambiado de ElevatedButton.icon a ElevatedButton normal para mayor control
          style: RegistroStyles.transparentButtonStyle,
          onPressed: isLoading ? () {} : onPressed, // 🔥 3. Bloqueamos el botón si carga
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
                      style: RegistroStyles.buttonTextStyle,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}