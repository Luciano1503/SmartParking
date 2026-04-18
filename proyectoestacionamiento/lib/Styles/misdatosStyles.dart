import 'package:flutter/material.dart';

class MisDatosStyles {
  MisDatosStyles._();

  static const Color primaryBlue   = Color(0xFF1558D6);
  static const Color lightBg       = Color(0xFFF0F4FF);
  static const Color cardBg        = Colors.white;
  static const Color borderColor   = Color(0xFFD8E2F5);
  static const Color iconBg        = Color(0xFFE8EFFE);
  static const Color textPrimary   = Color(0xFF1A2B5E);
  static const Color textMuted     = Color(0xFF8898C0);

  static const BoxDecoration backgroundDecoration = BoxDecoration(
    color: lightBg,
  );

  static const EdgeInsets pagePadding = EdgeInsets.fromLTRB(16, 0, 16, 24);

  // Labels de campo (pequeño, color suave)
  static const TextStyle fieldLabelStyle = TextStyle(
    color: textMuted,
    fontSize: 11,
    letterSpacing: 0.2,
  );

  // Valor del campo (robusto, oscuro)
  static const TextStyle fieldValueStyle = TextStyle(
    color: textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle sectionTitleStyle = TextStyle(
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