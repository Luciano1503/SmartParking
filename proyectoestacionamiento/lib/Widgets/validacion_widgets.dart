import 'package:flutter/material.dart';
import '../Core/app_localizations.dart';
import '../Styles/validacion_styles.dart';

class ValidationBackground extends StatelessWidget {
  const ValidationBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: isDark
          ? ValidacionStyles.backgroundDecoration
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
            const Text("SOLUTIONS", style: ValidacionStyles.brandSubtitleStyle),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('validation.title'),
          style: isDark
              ? ValidacionStyles.pageTitleStyle
              : ValidacionStyles.pageTitleStyle.copyWith(
                  color: const Color(0xFF0F1E3A),
                ),
        ),
        const SizedBox(height: 6),
        Text(
          context.tr('validation.step_two'),
          style: isDark
              ? ValidacionStyles.pageSubtitleStyle
              : ValidacionStyles.pageSubtitleStyle.copyWith(
                  color: const Color(0xFF4A6A85),
                ),
        ),
      ],
    );
  }
}

class EmailSentBanner extends StatelessWidget {
  final String maskedEmail;

  const EmailSentBanner({super.key, required this.maskedEmail});

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
                Text(
                  context.tr('validation.sent_to'),
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
          Text(
            context.tr('validation.code'),
            style: ValidacionStyles.otpTitleStyle,
          ),
          const SizedBox(height: 4),
          Text(
            context.tr('validation.code_help'),
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
          Row(
            children: [
              const Icon(
                Icons.timer_outlined,
                color: ValidacionStyles.hintBlue,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                context.tr('validation.expiry'),
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
        Text(
          context.tr('validation.not_received'),
          style: ValidacionStyles.resendBaseStyle,
        ),
        GestureDetector(
          onTap: () {
            // Lógica de reenvío
          },
          child: Text(
            context.tr('validation.resend'),
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

  final bool isLoading;

  const GradientActionButton({
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
      height: 54,
      child: DecoratedBox(
        decoration: ValidacionStyles.gradientButtonDecoration,
        child: ElevatedButton(
          style: ValidacionStyles.transparentButtonStyle,
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
                    Icon(icon, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(label, style: ValidacionStyles.buttonTextStyle),
                  ],
                ),
        ),
      ),
    );
  }
}
