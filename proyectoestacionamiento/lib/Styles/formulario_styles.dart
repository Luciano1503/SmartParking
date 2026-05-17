import 'package:flutter/material.dart';

class FormularioStyles {
  FormularioStyles._();

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
  static const Color lightInputFill = Color(0xFFFFFFFF);
  static const Color lightInputBorder = Color(0xFFD6E6F8);
  static const Color lightInputText = Color(0xFF0F1E3A);
  static const Color lightLabel = Color(0xFF53708B);

  static final Color glowCyan = const Color(0xFF00C6FF).withValues(alpha: 0.13);
  static final Color glowBlue = const Color(0xFF0072FF).withValues(alpha: 0.12);

  static const EdgeInsets topBarPadding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 4,
  );
  static const EdgeInsets topBadgePadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 6,
  );
  static const EdgeInsets scrollPadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 8,
  );
  static const EdgeInsets cardPadding = EdgeInsets.all(20);
  static const EdgeInsets passwordRequirementsPadding = EdgeInsets.all(14);
  static const EdgeInsets inputContentPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 18,
  );

  static const double buttonHeight = 54;

  static const BoxDecoration backgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [bgDark1, bgDark2, bgDark3],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static BoxDecoration topBadgeDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? inputFill : Colors.white.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: isDark ? cardBorder : lightInputBorder),
      boxShadow: isDark
          ? null
          : [
              BoxShadow(
                color: const Color(0xFF0072FF).withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
    );
  }

  static BoxDecoration get brandLogoDecoration => BoxDecoration(
    gradient: const LinearGradient(colors: [primaryCyan, primaryBlue]),
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: primaryBlue.withValues(alpha: 0.4),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  );

  static BoxDecoration cardDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark
          ? const Color(0xFF0F1E3A).withValues(alpha: 0.85)
          : Colors.white.withValues(alpha: 0.86),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: isDark ? cardBorder : lightInputBorder),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
          blurRadius: 30,
          offset: const Offset(0, 12),
        ),
      ],
    );
  }

  static BoxDecoration passwordRequirementsDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark
          ? primaryBlue.withValues(alpha: 0.07)
          : Colors.white.withValues(alpha: 0.75),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isDark ? primaryBlue.withValues(alpha: 0.18) : lightInputBorder,
      ),
    );
  }

  static BoxDecoration get sectionIconDecoration => BoxDecoration(
    gradient: const LinearGradient(colors: [primaryCyan, primaryBlue]),
    borderRadius: BorderRadius.circular(9),
    boxShadow: [
      BoxShadow(
        color: primaryBlue.withValues(alpha: 0.35),
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
        color: primaryBlue.withValues(alpha: 0.45),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );

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

  static TextStyle brandSubtitleStyle(BuildContext context) => TextStyle(
    fontSize: 10,
    letterSpacing: 3,
    color: Theme.of(context).brightness == Brightness.dark
        ? softBlue
        : const Color(0xFF5D7895),
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

  static TextStyle fieldTextStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).brightness == Brightness.dark
        ? white
        : lightInputText,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static TextStyle inputLabelStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).brightness == Brightness.dark
        ? inputLabelColor
        : lightLabel,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static TextStyle hintTextStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : const Color(0xFF71879D),
    fontSize: 14,
  );

  static TextStyle counterTextStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).brightness == Brightness.dark
        ? counterBlue
        : const Color(0xFF5C7893),
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle passwordRequirementTitleStyle = TextStyle(
    color: mutedBlue,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static TextStyle passwordHintTextStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).brightness == Brightness.dark
        ? passwordHintText
        : const Color(0xFF58708A),
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

  static OutlineInputBorder enabledBorder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: isDark ? cardBorder : lightInputBorder),
    );
  }

  static OutlineInputBorder get focusedBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: primaryCyan, width: 1.6),
  );

  static OutlineInputBorder get errorBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: errorPink, width: 1),
  );

  static OutlineInputBorder get focusedErrorBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: errorPink, width: 1.5),
  );

  static InputDecoration inputDecoration(
    BuildContext context,
    String label,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      labelText: label,
      labelStyle: inputLabelStyle(context),
      floatingLabelStyle: inputLabelStyle(context).copyWith(
        color: isDark ? primaryCyan : primaryBlue,
        fontWeight: FontWeight.w800,
      ),
      prefixIcon: Icon(
        icon,
        color: isDark ? inputLabelColor : const Color(0xFF5C7D99),
        size: 20,
      ),
      filled: true,
      fillColor: isDark ? inputFill : lightInputFill.withValues(alpha: 0.96),
      enabledBorder: enabledBorder(context),
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: focusedErrorBorder,
      errorStyle: const TextStyle(color: errorPink, fontSize: 11),
      contentPadding: inputContentPadding,
      hintStyle: hintTextStyle(context),
      counterStyle: counterTextStyle(context),
    );
  }

  static ButtonStyle get transparentElevatedIconButtonStyle =>
      ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );

  static ColorScheme datePickerColorScheme(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return const ColorScheme.dark(
        primary: primaryCyan,
        onPrimary: white,
        surface: Color(0xFF0F1E3A),
        onSurface: white,
      );
    }

    return const ColorScheme.light(
      primary: primaryBlue,
      onPrimary: white,
      surface: white,
      onSurface: lightInputText,
    );
  }

  static SnackBar successSnackBar() {
    return SnackBar(
      content: const Text("Registro exitoso!"),
      backgroundColor: primaryBlue,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
