import 'package:flutter/material.dart';

class ValidacionStyles {
  ValidacionStyles._();

  // Colors
  static const Color bgDark1 = Color(0xFF0A0E27);
  static const Color bgDark2 = Color(0xFF0D1B4B);
  static const Color bgDark3 = Color(0xFF0A2540);

  static const Color primaryCyan = Color(0xFF00C6FF);
  static const Color primaryBlue = Color(0xFF0072FF);
  static const Color lightCyan = Color(0xFF8ADFFF);

  static const Color white = Colors.white;
  static const Color mutedBlue = Color(0xFF7BA7C2);
  static const Color softBlue = Color(0xFF4A7090);
  static const Color mediumBlue = Color(0xFF5B7FA0);
  static const Color secondaryText = Color(0xFF3D6080);
  static const Color hintBlue = Color(0xFF2E5070);

  static const Color darkInput = Color(0xFF0A1628);
  static const Color darkCard = Color(0xFF0F1E3A);
  static const Color darkBorder = Color(0xFF1E3A5F);

  static final Color glowCyan =
      const Color(0xFF00C6FF).withOpacity(0.14);
  static final Color glowBlue =
      const Color(0xFF0072FF).withOpacity(0.13);

  // Animation
  static const Duration animationDuration = Duration(milliseconds: 800);
  static const Offset slideBeginOffset = Offset(0, 0.10);

  // Paddings
  static const EdgeInsets topBarPadding =
      EdgeInsets.symmetric(horizontal: 8, vertical: 4);

  static const EdgeInsets pagePadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 8);

  static const EdgeInsets indicatorPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 6);

  static const EdgeInsets emailBannerPadding = EdgeInsets.all(16);

  static const EdgeInsets otpCardPadding = EdgeInsets.all(24);

  static const EdgeInsets gradientButtonPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 6);

  // Decorations
  static const BoxDecoration backgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [bgDark1, bgDark2, bgDark3],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static BoxDecoration get brandLogoDecoration => BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryCyan, primaryBlue],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      );

  static BoxDecoration get stepIndicatorDecoration => BoxDecoration(
        color: darkInput,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: darkBorder),
      );

  static BoxDecoration get emailBannerDecoration => BoxDecoration(
        color: primaryBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryBlue.withOpacity(0.22),
        ),
      );

  static BoxDecoration get emailBannerIconDecoration => BoxDecoration(
        color: primaryBlue.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      );

  static BoxDecoration get otpCardDecoration => BoxDecoration(
        color: darkCard.withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: darkBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      );

  static BoxDecoration get otpBoxDecoration => BoxDecoration(
        color: darkInput,
        borderRadius: BorderRadius.circular(12),
      );

  static BoxDecoration get gradientButtonDecoration => BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryCyan, primaryBlue],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.45),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );

  // Text styles
  static const TextStyle brandTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: white,
  );

  static const TextStyle brandSubtitleStyle = TextStyle(
    fontSize: 10,
    letterSpacing: 3,
    color: softBlue,
  );

  static const TextStyle pageTitleStyle = TextStyle(
    color: white,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );

  static const TextStyle pageSubtitleStyle = TextStyle(
    color: softBlue,
    fontSize: 13,
  );

  static const TextStyle emailBannerLabelStyle = TextStyle(
    color: mediumBlue,
    fontSize: 12,
  );

  static const TextStyle emailBannerValueStyle = TextStyle(
    color: lightCyan,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle otpTitleStyle = TextStyle(
    color: white,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle otpSubtitleStyle = TextStyle(
    color: softBlue,
    fontSize: 12,
  );

  static const TextStyle expiryHintStyle = TextStyle(
    color: hintBlue,
    fontSize: 12,
  );

  static const TextStyle resendBaseStyle = TextStyle(
    color: secondaryText,
    fontSize: 13,
  );

  static const TextStyle resendActionStyle = TextStyle(
    color: primaryCyan,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: white,
    fontWeight: FontWeight.w700,
    fontSize: 15,
    letterSpacing: 0.3,
  );

  static const TextStyle otpInputTextStyle = TextStyle(
    color: primaryCyan,
    fontSize: 22,
    fontWeight: FontWeight.w800,
  );

  // Input borders
  static OutlineInputBorder get otpEnabledBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: darkBorder,
          width: 1.5,
        ),
      );

  static OutlineInputBorder get otpFocusedBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: primaryCyan,
          width: 2,
        ),
      );

  static InputDecoration get otpInputDecoration => InputDecoration(
        counterText: '',
        filled: true,
        fillColor: darkInput,
        enabledBorder: otpEnabledBorder,
        focusedBorder: otpFocusedBorder,
        contentPadding: EdgeInsets.zero,
      );

  static ButtonStyle get transparentButtonStyle =>
      ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      );
}