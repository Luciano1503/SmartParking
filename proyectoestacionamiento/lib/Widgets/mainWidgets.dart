import 'package:flutter/material.dart';
import '../Styles/mainStyles.dart';

class StyledBackground extends StatelessWidget {
  const StyledBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStyles.backgroundDecoration,
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

class AppLogoBadge extends StatelessWidget {
  const AppLogoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppStyles.logoSize,
      height: AppStyles.logoSize,
      decoration: AppStyles.logoDecoration,
      child: const Icon(
        Icons.local_parking_rounded,
        color: Colors.white,
        size: AppStyles.logoIconSize,
      ),
    );
  }
}

class BrandTitle extends StatelessWidget {
  const BrandTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [AppStyles.primaryCyan, AppStyles.lightCyan],
      ).createShader(bounds),
      child: const Text(
        'SmartParking',
        style: AppStyles.brandTitleStyle,
      ),
    );
  }
}

class BrandSubtitle extends StatelessWidget {
  const BrandSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Solutions',
          style: AppStyles.brandSolutionsStyle,
        ),
        SizedBox(height: 8),
        Text(
          'Gestiona estacionamientos en universidades,\ncentros comerciales y más',
          textAlign: TextAlign.center,
          style: AppStyles.brandDescriptionStyle,
        ),
      ],
    );
  }
}

class LoginCard extends StatelessWidget {
  final TextEditingController correoController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onLoginPressed;
  final VoidCallback onRegisterPressed;

  const LoginCard({
    super.key,
    required this.correoController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onLoginPressed,
    required this.onRegisterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppStyles.cardPadding,
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bienvenido',
            style: AppStyles.cardTitleStyle,
          ),
          const SizedBox(height: 4),
          const Text(
            'Inicia sesión para continuar',
            style: AppStyles.cardSubtitleStyle,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: correoController,
            style: AppStyles.inputTextStyle,
            decoration: InputDecoration(
              labelText: 'Correo electrónico',
              labelStyle: AppStyles.inputLabelStyle,
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: AppStyles.inputIcon,
                size: 20,
              ),
              filled: true,
              fillColor: AppStyles.inputFill,
              enabledBorder: AppStyles.enabledInputBorder,
              focusedBorder: AppStyles.focusedInputBorder,
              contentPadding: AppStyles.inputContentPadding,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: passwordController,
            obscureText: obscurePassword,
            style: AppStyles.inputTextStyle,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              labelStyle: AppStyles.inputLabelStyle,
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: AppStyles.inputIcon,
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppStyles.inputIcon,
                  size: 20,
                ),
                onPressed: onTogglePassword,
              ),
              filled: true,
              fillColor: AppStyles.inputFill,
              enabledBorder: AppStyles.enabledInputBorder,
              focusedBorder: AppStyles.focusedInputBorder,
              contentPadding: AppStyles.inputContentPadding,
            ),
          ),
          const SizedBox(height: 28),
          GradientButton(
            label: 'Iniciar sesión',
            onPressed: onLoginPressed,
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: onRegisterPressed,
              style: AppStyles.registerTextButtonStyle,
              child: const Text(
                '¿No tienes cuenta? Regístrate aquí',
                style: AppStyles.registerTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppStyles.buttonHeight,
      child: DecoratedBox(
        decoration: AppStyles.buttonDecoration,
        child: ElevatedButton(
          style: AppStyles.transparentElevatedButtonStyle,
          onPressed: onPressed,
          child: Text(
            label,
            style: AppStyles.buttonTextStyle,
          ),
        ),
      ),
    );
  }
}
