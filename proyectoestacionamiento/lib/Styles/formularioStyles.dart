import 'package:flutter/material.dart';

class FormularioStyles {
  FormularioStyles._();

  // Colors
  static const Color bgDark1 = Color(0xFF0A0E27);
  static const Color bgDark2 = Color(0xFF0D1B4B);
  static const Color bgDark3 = Color(0xFF0A2540);

  static const Color primaryCyan = Color(0xFF00C6FF);
  static const Color primaryBlue = Color(0xFF0072FF);
  static const Color lightCyan = Color(0xFF8ADFFF);

  static const Color white = Colors.white;
  static const Color inputFill = Color(0xFF0A1628);
  static const Color cardBorder = Color(0xFF1E3A5F);
  static const Color inputLabelColor = Color(0xFF4A7090);
  static const Color mutedBlue = Color(0xFF7BA7C2);
  static const Color softBlue = Color(0xFF4A7090);
  static const Color counterBlue = Color(0xFF2E5070);
  static const Color passwordHintDot = Color(0xFF1E4A70);
  static const Color passwordHintText = Color(0xFF3D6080);
  static const Color errorPink = Color(0xFFFF4D6A);

  static final Color glowCyan =
      const Color(0xFF00C6FF).withOpacity(0.13);
  static final Color glowBlue =
      const Color(0xFF0072FF).withOpacity(0.12);

  // Paddings
  static const EdgeInsets topBarPadding =
      EdgeInsets.symmetric(horizontal: 8, vertical: 4);

  static const EdgeInsets topBadgePadding =
      EdgeInsets.symmetric(horizontal: 14, vertical: 6);

  static const EdgeInsets scrollPadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 8);

  static const EdgeInsets cardPadding = EdgeInsets.all(20);

  static const EdgeInsets passwordRequirementsPadding =
      EdgeInsets.all(14);

  static const EdgeInsets inputContentPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 16);

  // Sizes
  static const double buttonHeight = 54;

  // Decorations
  static const BoxDecoration backgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [bgDark1, bgDark2, bgDark3],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static BoxDecoration get topBadgeDecoration => BoxDecoration(
        color: inputFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorder),
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

  static BoxDecoration get cardDecoration => BoxDecoration(
        color: const Color(0xFF0F1E3A).withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      );

  static BoxDecoration get passwordRequirementsDecoration => BoxDecoration(
        color: primaryBlue.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryBlue.withOpacity(0.18),
        ),
      );

  static BoxDecoration get sectionIconDecoration => BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryCyan, primaryBlue],
        ),
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration gradientButtonDecoration = BoxDecoration(
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
  static const TextStyle topBadgeTextStyle = TextStyle(
    color: primaryCyan,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

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
    fontSize: 26,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );

  static const TextStyle pageSubtitleStyle = TextStyle(
    color: softBlue,
    fontSize: 13,
  );

  static const TextStyle inputTextStyle = TextStyle(
    color: white,
    fontSize: 14,
  );

  static const TextStyle inputLabelStyle = TextStyle(
    color: inputLabelColor,
    fontSize: 14,
  );

  static const TextStyle hintTextStyle = TextStyle(
    color: Colors.white70,
    fontSize: 14,
  );

  static const TextStyle counterTextStyle = TextStyle(
    color: counterBlue,
    fontSize: 11,
  );

  static const TextStyle passwordRequirementTitleStyle = TextStyle(
    color: mutedBlue,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static const TextStyle passwordHintTextStyle = TextStyle(
    color: passwordHintText,
    fontSize: 12,
  );

  static const TextStyle sectionHeaderTextStyle = TextStyle(
    color: white,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: white,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    letterSpacing: 0.3,
  );

  // Borders
  static OutlineInputBorder get enabledBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: cardBorder, width: 1),
      );

  static OutlineInputBorder get focusedBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryCyan, width: 1.5),
      );

  static OutlineInputBorder get errorBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: errorPink, width: 1),
      );

  static OutlineInputBorder get focusedErrorBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: errorPink, width: 1.5),
      );

  static InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: inputLabelStyle,
      prefixIcon: Icon(icon, color: inputLabelColor, size: 20),
      filled: true,
      fillColor: inputFill,
      enabledBorder: enabledBorder,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: focusedErrorBorder,
      errorStyle: const TextStyle(color: errorPink, fontSize: 11),
      contentPadding: inputContentPadding,
      hintStyle: hintTextStyle, // agregado para mejorar visibilidad
    );
  }

  static ButtonStyle get transparentElevatedIconButtonStyle =>
      ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      );

  static ColorScheme get datePickerColorScheme => const ColorScheme.dark(
        primary: primaryCyan,
        onPrimary: white,
        surface: Color(0xFF0F1E3A),
        onSurface: white,
      );

  static SnackBar successSnackBar() {
    return SnackBar(
      content: const Text("¡Registro exitoso!"),
      backgroundColor: primaryBlue,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
