import 'package:flutter/material.dart';
import '../Styles/formularioStyles.dart';

class FormBackground extends StatelessWidget {
  const FormBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: FormularioStyles.backgroundDecoration,
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

class CustomTopBar extends StatelessWidget {
  const CustomTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: FormularioStyles.topBarPadding,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: FormularioStyles.mutedBlue,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          Container(
            padding: FormularioStyles.topBadgePadding,
            decoration: FormularioStyles.topBadgeDecoration,
            child: const Text(
              "Paso final",
              style: FormularioStyles.topBadgeTextStyle,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class FormBrandHeader extends StatelessWidget {
  const FormBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: FormularioStyles.brandLogoDecoration,
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
                  FormularioStyles.primaryCyan,
                  FormularioStyles.lightCyan,
                ],
              ).createShader(bounds),
              child: const Text(
                "SmartParking",
                style: FormularioStyles.brandTitleStyle,
              ),
            ),
            const Text(
              "SOLUTIONS",
              style: FormularioStyles.brandSubtitleStyle,
            ),
          ],
        ),
      ],
    );
  }
}

class FormPageTitle extends StatelessWidget {
  const FormPageTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Completa tu registro",
          style: FormularioStyles.pageTitleStyle,
        ),
        SizedBox(height: 6),
        Text(
          "Rellena todos los campos para crear tu cuenta",
          style: FormularioStyles.pageSubtitleStyle,
        ),
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: FormularioStyles.sectionIconDecoration,
          child: Icon(icon, color: Colors.white, size: 17),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: FormularioStyles.sectionHeaderTextStyle,
        ),
      ],
    );
  }
}

class PasswordHint extends StatelessWidget {
  final String text;

  const PasswordHint({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.circle,
          color: FormularioStyles.passwordHintDot,
          size: 5,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: FormularioStyles.passwordHintTextStyle,
        ),
      ],
    );
  }
}

class PasswordRequirementsCard extends StatelessWidget {
  const PasswordRequirementsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: FormularioStyles.passwordRequirementsPadding,
      decoration: FormularioStyles.passwordRequirementsDecoration,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Requisitos de contraseña",
            style: FormularioStyles.passwordRequirementTitleStyle,
          ),
          SizedBox(height: 8),
          PasswordHint(text: "Mínimo 12 caracteres"),
          SizedBox(height: 4),
          PasswordHint(text: "Al menos un número"),
          SizedBox(height: 4),
          PasswordHint(
            text: "Al menos un carácter especial (!@#\$&*~)",
          ),
        ],
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const GradientButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: FormularioStyles.buttonHeight,
      child: DecoratedBox(
        decoration: FormularioStyles.gradientButtonDecoration,
        child: ElevatedButton.icon(
          style: FormularioStyles.transparentElevatedIconButtonStyle,
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white, size: 20),
          label: Text(
            label,
            style: FormularioStyles.buttonTextStyle,
          ),
        ),
      ),
    );
  }
}