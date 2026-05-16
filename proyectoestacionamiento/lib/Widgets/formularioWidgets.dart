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

// 🔥 NUEVO: Grupo de Inputs para la Placa (ABC - 123)
class PlacaInputGroup extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function(String value, int index) onChanged;

  const PlacaInputGroup({
    super.key,
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PlacaBox(controller: controllers[0], focusNode: focusNodes[0], onChanged: (v) => onChanged(v, 0)),
        PlacaBox(controller: controllers[1], focusNode: focusNodes[1], onChanged: (v) => onChanged(v, 1)),
        PlacaBox(controller: controllers[2], focusNode: focusNodes[2], onChanged: (v) => onChanged(v, 2)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            "-",
            style: TextStyle(fontSize: 28, color: FormularioStyles.primaryCyan, fontWeight: FontWeight.bold),
          ),
        ),
        PlacaBox(controller: controllers[3], focusNode: focusNodes[3], onChanged: (v) => onChanged(v, 3)),
        PlacaBox(controller: controllers[4], focusNode: focusNodes[4], onChanged: (v) => onChanged(v, 4)),
        PlacaBox(controller: controllers[5], focusNode: focusNodes[5], onChanged: (v) => onChanged(v, 5)),
      ],
    );
  }
}

// 🔥 NUEVO: Cajita individual para la Placa
class PlacaBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const PlacaBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textCapitalization: TextCapitalization.characters, // Fuerza mayúsculas
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        onChanged: onChanged,
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.white.withOpacity(0.08),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: FormularioStyles.primaryCyan, width: 2),
          ),
        ),
      ),
    );
  }
}

// 🔥 ACTUALIZADO: Botón con estado de carga
class GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: FormularioStyles.buttonHeight,
      child: DecoratedBox(
        decoration: FormularioStyles.gradientButtonDecoration,
        child: ElevatedButton(
          style: FormularioStyles.transparentElevatedIconButtonStyle,
          onPressed: isLoading ? () {} : onPressed,
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
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: FormularioStyles.buttonTextStyle,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}