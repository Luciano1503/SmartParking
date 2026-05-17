import 'package:flutter/material.dart';
import '../Core/app_preferences.dart';

class PremiumStyles {
  PremiumStyles._();

  // Colors
  static bool get _dark => AppPreferences.instance.isDarkMode;
  static Color get pageBackground =>
      _dark ? const Color(0xFF08111F) : const Color(0xFFF0F6FF);
  static Color get surface =>
      _dark ? const Color(0xFF101B2E) : Colors.white;
  static Color get surfaceAlt =>
      _dark ? const Color(0xFF0D1728) : const Color(0xFFF8FBFF);
  static Color get primaryText =>
      _dark ? const Color(0xFFF2F7FF) : const Color(0xFF0A2540);
  static Color get secondaryCopy =>
      _dark ? const Color(0xFFA9BAD2) : const Color(0xFF4A6A85);
  static const Color headerBackground = Color(0xFF0A2540);
  static const Color primaryCyan = Color(0xFF00C6FF);
  static const Color primaryBlue = Color(0xFF0072FF);
  static const Color lightCyan = Color(0xFF8ADFFF);
  static const Color mutedBlue = Color(0xFF7BA7C2);
  static const Color softBlue = Color(0xFF4A7090);
  static const Color titleDark = Color(0xFF0A2540);
  static const Color textDark = Color(0xFF1A3A55);
  static const Color textSoftDark = Color(0xFF4A6A85);
  static const Color disabledText = Color(0xFFADB5BD);
  static const Color successGreen = Color(0xFF00A86B);
  static const Color white = Colors.white;

  // Padding
  static const EdgeInsets headerPadding = EdgeInsets.fromLTRB(8, 4, 16, 24);
  static const EdgeInsets headerSubtitlePadding = EdgeInsets.fromLTRB(
    14,
    4,
    14,
    0,
  );
  static const EdgeInsets headerBadgePadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 5,
  );
  static const EdgeInsets contentPadding = EdgeInsets.fromLTRB(16, 20, 16, 24);

  static const EdgeInsets cardHeaderPadding = EdgeInsets.all(20);
  static const EdgeInsets featuresPadding = EdgeInsets.fromLTRB(20, 16, 20, 0);
  static const EdgeInsets descriptionPadding = EdgeInsets.fromLTRB(
    20,
    10,
    20,
    0,
  );
  static const EdgeInsets descriptionInnerPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 10,
  );
  static const EdgeInsets ctaPadding = EdgeInsets.all(20);

  // Decorations
  static const BoxDecoration headerDecoration = BoxDecoration(
    color: headerBackground,
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(28),
      bottomRight: Radius.circular(28),
    ),
  );

  static BoxDecoration get premiumBadgeDecoration => BoxDecoration(
    color: primaryCyan.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: primaryCyan.withValues(alpha: 0.4)),
  );

  static BoxDecoration planCardDecoration({
    required Color accentColor,
    required bool isPrimary,
  }) {
    return BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(24),
      border: isPrimary
          ? Border.all(color: accentColor.withValues(alpha: 0.35), width: 1.5)
          : null,
      boxShadow: [
        BoxShadow(
          color: accentColor.withValues(alpha: isPrimary ? 0.14 : 0.07),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  static BoxDecoration planHeaderDecoration({
    required Color accentColor,
    required bool isPrimary,
  }) {
    return BoxDecoration(
      gradient: isPrimary
          ? LinearGradient(
              colors: [
                const Color(0xFF0A2540),
                accentColor.withValues(alpha: 0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      color: isPrimary ? null : surfaceAlt,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    );
  }

  static BoxDecoration planIconDecoration({
    required Color accentColor,
    required bool isPrimary,
  }) {
    return BoxDecoration(
      color: isPrimary
          ? Colors.white.withValues(alpha: 0.12)
          : accentColor.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isPrimary
            ? Colors.white.withValues(alpha: 0.2)
            : accentColor.withValues(alpha: 0.2),
      ),
    );
  }

  static BoxDecoration descriptionDecoration(Color accentColor) {
    return BoxDecoration(
      color: accentColor.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: accentColor.withValues(alpha: 0.12)),
    );
  }

  static BoxDecoration ctaDecoration({
    required Color accentColor,
    required bool isPrimary,
  }) {
    return BoxDecoration(
      gradient: isPrimary
          ? const LinearGradient(colors: [primaryCyan, primaryBlue])
          : null,
      color: isPrimary ? null : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      border: isPrimary
          ? null
          : Border.all(color: accentColor.withValues(alpha: 0.5)),
      boxShadow: isPrimary
          ? [
              BoxShadow(
                color: primaryBlue.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ]
          : null,
    );
  }

  static BoxDecoration featureIconDecoration({
    required Color accentColor,
    required bool disabled,
  }) {
    return BoxDecoration(
      color: disabled
          ? Colors.grey.withValues(alpha: 0.08)
          : accentColor.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(9),
    );
  }

  // Text styles
  static const TextStyle headerTitleStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 18,
  );

  static const TextStyle headerSubtitleStyle = TextStyle(
    color: softBlue,
    fontSize: 13,
  );

  static const TextStyle premiumBadgeTextStyle = TextStyle(
    color: primaryCyan,
    fontSize: 11,
    fontWeight: FontWeight.w700,
  );

  static TextStyle planTitleStyle(bool isPrimary) => TextStyle(
    color: isPrimary ? Colors.white : primaryText,
    fontSize: 18,
    fontWeight: FontWeight.w800,
  );

  static TextStyle planSubtitleStyle(bool isPrimary) => TextStyle(
    color: isPrimary ? Colors.white.withValues(alpha: 0.65) : secondaryCopy,
    fontSize: 12,
  );

  static TextStyle priceStyle({
    required bool isPrimary,
    required Color accentColor,
  }) => TextStyle(
    color: isPrimary ? Colors.white : accentColor,
    fontSize: 20,
    fontWeight: FontWeight.w900,
  );

  static TextStyle priceNoteStyle(bool isPrimary) => TextStyle(
    color: isPrimary ? Colors.white.withValues(alpha: 0.55) : secondaryCopy,
    fontSize: 10,
  );

  static TextStyle get descriptionTextStyle => TextStyle(
    color: secondaryCopy,
    fontSize: 12,
    height: 1.55,
  );

  static TextStyle ctaTextStyle({
    required bool isPrimary,
    required Color accentColor,
  }) => TextStyle(
    color: isPrimary ? Colors.white : accentColor,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );

  static TextStyle featureTextStyle(bool disabled) => TextStyle(
    color: disabled ? disabledText : primaryText,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    decoration: disabled ? TextDecoration.lineThrough : null,
  );

  // Button styles
  static ButtonStyle ctaButtonStyle() => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  );
}
