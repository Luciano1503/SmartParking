import 'package:flutter/material.dart';
import '../Core/app_localizations.dart';
import '../Styles/main_styles.dart';

class StyledBackground extends StatelessWidget {
  const StyledBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: isDark
          ? AppStyles.backgroundDecoration
          : const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF8FBFF), Color(0xFFEAF3FF), Color(0xFFDDEBFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
    );
  }
}

class GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const GlowCircle({super.key, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
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
      child: const Text('SmartParking', style: AppStyles.brandTitleStyle),
    );
  }
}

class BrandSubtitle extends StatelessWidget {
  const BrandSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Solutions', style: AppStyles.brandSolutionsStyle),
        const SizedBox(height: 8),
        Text(
          context.tr('login.brand_description'),
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

  final bool isLoading;

  final VoidCallback onTogglePassword;
  final VoidCallback onLoginPressed;
  final VoidCallback onRegisterPressed;

  const LoginCard({
    super.key,
    required this.correoController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading, // Lo pedimos en el constructor
    required this.onTogglePassword,
    required this.onLoginPressed,
    required this.onRegisterPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardDecoration = isDark
        ? AppStyles.cardDecoration
        : BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(AppStyles.cardRadius),
            border: Border.all(color: const Color(0xFFD8E4F4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          );
    final titleStyle = isDark
        ? AppStyles.cardTitleStyle
        : AppStyles.cardTitleStyle.copyWith(color: const Color(0xFF0F1E3A));
    final subtitleStyle = isDark
        ? AppStyles.cardSubtitleStyle
        : AppStyles.cardSubtitleStyle.copyWith(color: const Color(0xFF5B7FA0));
    final inputTextStyle = isDark
        ? AppStyles.inputTextStyle
        : AppStyles.inputTextStyle.copyWith(color: const Color(0xFF0F1E3A));
    final inputFill = isDark ? AppStyles.inputFill : const Color(0xFFF5F8FD);

    return Container(
      padding: AppStyles.cardPadding,
      decoration: cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr('login.welcome'), style: titleStyle),
          const SizedBox(height: 4),
          Text(context.tr('login.subtitle'), style: subtitleStyle),
          const SizedBox(height: 24),
          TextField(
            controller: correoController,
            style: inputTextStyle,
            decoration: InputDecoration(
              labelText: context.tr('login.email'),
              labelStyle: AppStyles.inputLabelStyle,
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: AppStyles.inputIcon,
                size: 20,
              ),
              filled: true,
              fillColor: inputFill,
              enabledBorder: AppStyles.enabledInputBorder,
              focusedBorder: AppStyles.focusedInputBorder,
              contentPadding: AppStyles.inputContentPadding,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: passwordController,
            obscureText: obscurePassword,
            style: inputTextStyle,
            decoration: InputDecoration(
              labelText: context.tr('login.password'),
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
              fillColor: inputFill,
              enabledBorder: AppStyles.enabledInputBorder,
              focusedBorder: AppStyles.focusedInputBorder,
              contentPadding: AppStyles.inputContentPadding,
            ),
          ),
          const SizedBox(height: 28),
          GradientButton(
            label: context.tr('login.sign_in'),
            isLoading: isLoading,
            onPressed: onLoginPressed,
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: isLoading
                  ? null
                  : onRegisterPressed, // Bloquea si está cargando
              style: AppStyles.registerTextButtonStyle,
              child: Text(
                context.tr('login.register'),
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

  final bool isLoading;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false, // Por defecto es false
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
          onPressed: isLoading
              ? () {}
              : onPressed, // Si está cargando, anula el click
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white, // Color del circulito
                    strokeWidth: 2.5,
                  ),
                )
              : Text(label, style: AppStyles.buttonTextStyle),
        ),
      ),
    );
  }
}
