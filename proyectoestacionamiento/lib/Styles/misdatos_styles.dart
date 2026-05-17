import 'package:flutter/material.dart';
import '../Core/app_preferences.dart';

class MisDatosStyles {
  MisDatosStyles._();

  static const Color primaryBlue = Color(0xFF1558D6);
  static bool get _dark => AppPreferences.instance.isDarkMode;
  static Color get lightBg =>
      _dark ? const Color(0xFF08111F) : const Color(0xFFF0F4FF);
  static Color get cardBg =>
      _dark ? const Color(0xFF101B2E) : Colors.white;
  static Color get borderColor =>
      _dark ? const Color(0xFF263B5A) : const Color(0xFFD8E2F5);
  static Color get iconBg =>
      _dark ? const Color(0xFF162A4A) : const Color(0xFFE8EFFE);
  static Color get textPrimary =>
      _dark ? const Color(0xFFF2F7FF) : const Color(0xFF1A2B5E);
  static Color get textMuted =>
      _dark ? const Color(0xFFA9BAD2) : const Color(0xFF8898C0);

  static BoxDecoration get backgroundDecoration => BoxDecoration(
    color: lightBg,
  );

  static const EdgeInsets pagePadding = EdgeInsets.fromLTRB(16, 0, 16, 24);

  // Labels de campo (pequeño, color suave)
  static TextStyle get fieldLabelStyle => TextStyle(
    color: textMuted,
    fontSize: 11,
    letterSpacing: 0.2,
  );

  // Valor del campo (robusto, oscuro)
  static TextStyle get fieldValueStyle => TextStyle(
    color: textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get sectionTitleStyle => const TextStyle(
    color: primaryBlue,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle profileNameStyle = TextStyle(
    color: Colors.white,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle profileSubStyle = TextStyle(
    color: Colors.white70,
    fontSize: 12,
  );

  static BoxDecoration get cardDecoration => BoxDecoration(
    color: cardBg,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: borderColor, width: 0.5),
  );

  static BoxDecoration get bannerDecoration => BoxDecoration(
    color: primaryBlue,
    borderRadius: BorderRadius.circular(18),
  );
}
