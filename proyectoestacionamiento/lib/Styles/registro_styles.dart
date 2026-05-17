import 'package:flutter/material.dart';

class RegistroStyles {
  RegistroStyles._();

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
  static const Color hintBlue = Color(0xFF2E4F70);
  static const Color infoTextBlue = Color(0xFF7BB8D4);
  static const Color mediumBlue = Color(0xFF5B7FA0);
  static const Color lightText = Color(0xFFB0CDE0);
  static const Color secondaryText = Color(0xFF3D6080);

  static const Color darkInput = Color(0xFF0A1628);
  static const Color darkCard = Color(0xFF0F1E3A);
  static const Color darkBorder = Color(0xFF1E3A5F);

  static final Color glowCyan = const Color(0xFF00C6FF).withValues(alpha: 0.15);
  static final Color glowBlue = const Color(0xFF0072FF).withValues(alpha: 0.14);

  // Paddings
  static const EdgeInsets topBarPadding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 4,
  );

  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 16,
  );

  static const EdgeInsets indicatorPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  );

  static const EdgeInsets infoBannerPadding = EdgeInsets.all(16);

  static const EdgeInsets emailCardPadding = EdgeInsets.all(24);

  static const EdgeInsets inputContentPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  );

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
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: primaryBlue.withValues(alpha: 0.4),
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

  static BoxDecoration get infoBannerDecoration => BoxDecoration(
    color: primaryBlue.withValues(alpha: 0.10),
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: primaryBlue.withValues(alpha: 0.25), width: 1),
  );

  static BoxDecoration get emailCardDecoration => BoxDecoration(
    color: darkCard.withValues(alpha: 0.85),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: darkBorder, width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.35),
        blurRadius: 40,
        offset: const Offset(0, 16),
      ),
    ],
  );

  static BoxDecoration get nextStepIconDecoration => BoxDecoration(
    color: darkInput,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: darkBorder),
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
        color: primaryBlue.withValues(alpha: 0.45),
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

  static const TextStyle infoBannerTextStyle = TextStyle(
    color: infoTextBlue,
    fontSize: 13,
    height: 1.5,
  );

  static const TextStyle sectionLabelStyle = TextStyle(
    color: mutedBlue,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle inputTextStyle = TextStyle(color: white, fontSize: 14);

  static const TextStyle inputHintStyle = TextStyle(
    color: hintBlue,
    fontSize: 14,
  );

  static const TextStyle shieldHintStyle = TextStyle(
    color: hintBlue,
    fontSize: 12,
  );

  static const TextStyle nextStepsTitleStyle = TextStyle(
    color: mediumBlue,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static const TextStyle stepTitleStyle = TextStyle(
    color: lightText,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle stepSubtitleStyle = TextStyle(
    color: secondaryText,
    fontSize: 12,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: white,
    fontWeight: FontWeight.w700,
    fontSize: 15,
    letterSpacing: 0.3,
  );

  static TextStyle get loginHintTextStyle =>
      TextStyle(color: primaryCyan.withValues(alpha: 0.75), fontSize: 13);

  // Input borders
  static OutlineInputBorder get enabledBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: darkBorder, width: 1),
  );

  static OutlineInputBorder get focusedBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: primaryCyan, width: 1.5),
  );

  static InputDecoration get emailInputDecoration => InputDecoration(
    hintText: "ejemplo@correo.com",
    hintStyle: inputHintStyle,
    prefixIcon: const Icon(Icons.email_outlined, color: softBlue, size: 20),
    filled: true,
    fillColor: darkInput,
    enabledBorder: enabledBorder,
    focusedBorder: focusedBorder,
    contentPadding: inputContentPadding,
  );

  static ButtonStyle get transparentButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}
