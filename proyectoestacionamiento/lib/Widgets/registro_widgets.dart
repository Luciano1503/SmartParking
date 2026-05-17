import 'package:flutter/material.dart';
import '../Core/app_localizations.dart';
import '../Styles/registro_styles.dart';

class RegisterBackground extends StatelessWidget {
  const RegisterBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: isDark
          ? RegistroStyles.backgroundDecoration
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
          StepIndicator(current: currentStep, total: totalSteps),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class StepIndicator extends StatelessWidget {
  final int current;
  final int total;

  const StepIndicator({super.key, required this.current, required this.total});

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
                colors: [RegistroStyles.primaryCyan, RegistroStyles.lightCyan],
              ).createShader(bounds),
              child: const Text(
                "SmartParking",
                style: RegistroStyles.brandTitleStyle,
              ),
            ),
            const Text("SOLUTIONS", style: RegistroStyles.brandSubtitleStyle),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('register.create_account'),
          style: isDark
              ? RegistroStyles.pageTitleStyle
              : RegistroStyles.pageTitleStyle.copyWith(
                  color: const Color(0xFF0F1E3A),
                ),
        ),
        const SizedBox(height: 6),
        Text(
          context.tr('register.step_one'),
          style: isDark
              ? RegistroStyles.pageSubtitleStyle
              : RegistroStyles.pageSubtitleStyle.copyWith(
                  color: const Color(0xFF4A6A85),
                ),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: RegistroStyles.primaryCyan,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.tr('register.info'),
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

  const RegisterEmailCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: RegistroStyles.emailCardPadding,
      decoration: isDark
          ? RegistroStyles.emailCardDecoration
          : BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFD8E4F4)),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('register.email'),
            style: isDark
                ? RegistroStyles.sectionLabelStyle
                : RegistroStyles.sectionLabelStyle.copyWith(
                    color: const Color(0xFF4A6A85),
                  ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            style: isDark
                ? RegistroStyles.inputTextStyle
                : RegistroStyles.inputTextStyle.copyWith(
                    color: const Color(0xFF0F1E3A),
                  ),
            decoration: RegistroStyles.emailInputDecoration.copyWith(
              fillColor: isDark ? RegistroStyles.darkInput : const Color(0xFFF5F8FD),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: RegistroStyles.hintBlue,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                context.tr('register.private_info'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('register.next_steps'),
          style: RegistroStyles.nextStepsTitleStyle,
        ),
        const SizedBox(height: 12),
        StepRow(
          icon: Icons.mark_email_unread_outlined,
          title: context.tr('register.receive_code'),
          subtitle: context.tr('register.receive_code_subtitle'),
        ),
        const SizedBox(height: 10),
        StepRow(
          icon: Icons.pin_outlined,
          title: context.tr('register.enter_digits'),
          subtitle: context.tr('register.enter_digits_subtitle'),
        ),
        const SizedBox(height: 10),
        StepRow(
          icon: Icons.check_circle_outline_rounded,
          title: context.tr('register.complete_profile'),
          subtitle: context.tr('register.complete_profile_subtitle'),
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
          child: Icon(icon, color: RegistroStyles.primaryCyan, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: RegistroStyles.stepTitleStyle),
              const SizedBox(height: 2),
              Text(subtitle, style: RegistroStyles.stepSubtitleStyle),
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

  final bool isLoading;

  const GradientActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isLoading =
        false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: RegistroStyles.gradientButtonDecoration,
        child: ElevatedButton(
          style: RegistroStyles.transparentButtonStyle,
          onPressed: isLoading
              ? () {}
              : onPressed,
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
                    Icon(icon, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(label, style: RegistroStyles.buttonTextStyle),
                  ],
                ),
        ),
      ),
    );
  }
}
