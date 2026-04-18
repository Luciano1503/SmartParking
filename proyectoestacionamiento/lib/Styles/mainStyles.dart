import 'package:flutter/material.dart';

class AppStyles {
  AppStyles._();

  // Theme
  static ThemeData get appTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlueAccent,
        ),
        useMaterial3: true,
      );

  // Animation
  static const Duration animationDuration = Duration(milliseconds: 900);
  static const Offset slideBeginOffset = Offset(0, 0.12);

  // Colors
  static const Color bgDark1 = Color(0xFF0A0E27);
  static const Color bgDark2 = Color(0xFF0D1B4B);
  static const Color bgDark3 = Color(0xFF0A2540);

  static const Color primaryCyan = Color(0xFF00C6FF);
  static const Color primaryBlue = Color(0xFF0072FF);
  static const Color lightCyan = Color(0xFF8ADFFF);

  static const Color textWhite = Colors.white;
  static const Color textMuted = Color(0xFF7BA7C2);
  static const Color textSecondary = Color(0xFF5B7FA0);
  static const Color inputIcon = Color(0xFF4A7090);

  static const Color cardBase = Color(0xFF0F1E3A);
  static const Color cardBorder = Color(0xFF1E3A5F);
  static const Color inputFill = Color(0xFF0A1628);

  static final Color glowCyanStrong =
      const Color(0xFF00C6FF).withOpacity(0.18);
  static final Color glowBlueSoft =
      const Color(0xFF0072FF).withOpacity(0.15);
  static final Color glowCyanLight =
      const Color(0xFF00C6FF).withOpacity(0.10);

  // Spacing
  static const EdgeInsets pagePadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 48);

  static const EdgeInsets cardPadding = EdgeInsets.all(28);

  static const EdgeInsets inputContentPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 16);

  // Sizes
  static const double logoSize = 72;
  static const double logoIconSize = 38;
  static const double logoRadius = 20;
  static const double cardRadius = 24;
  static const double inputRadius = 14;
  static const double buttonRadius = 14;
  static const double buttonHeight = 52;

  // Decorations
  static const BoxDecoration backgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [bgDark1, bgDark2, bgDark3],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static BoxDecoration get logoDecoration => BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryCyan, primaryBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(logoRadius),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.5),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      );

  static BoxDecoration get cardDecoration => BoxDecoration(
        color: cardBase.withOpacity(0.85),
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(
          color: cardBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      );

  static BoxDecoration get buttonDecoration => BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryCyan, primaryBlue],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(buttonRadius),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.45),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      );

  // TextStyles
  static const TextStyle brandTitleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: textWhite,
    letterSpacing: -0.5,
  );

  static const TextStyle brandSolutionsStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textMuted,
    letterSpacing: 4,
  );

  static const TextStyle brandDescriptionStyle = TextStyle(
    color: textSecondary,
    fontSize: 13,
    height: 1.5,
  );

  static const TextStyle cardTitleStyle = TextStyle(
    color: textWhite,
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle cardSubtitleStyle = TextStyle(
    color: textSecondary,
    fontSize: 13,
  );

  static const TextStyle inputTextStyle = TextStyle(
    color: textWhite,
    fontSize: 14,
  );

  static const TextStyle inputLabelStyle = TextStyle(
    color: inputIcon,
    fontSize: 14,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: textWhite,
    fontWeight: FontWeight.w700,
    fontSize: 15,
    letterSpacing: 0.4,
  );

  static const TextStyle registerTextStyle = TextStyle(
    fontSize: 13,
  );

  // Borders
  static OutlineInputBorder get enabledInputBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputRadius),
        borderSide: const BorderSide(
          color: cardBorder,
          width: 1,
        ),
      );

  static OutlineInputBorder get focusedInputBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputRadius),
        borderSide: const BorderSide(
          color: primaryCyan,
          width: 1.5,
        ),
      );

  // Button styles
  static ButtonStyle get transparentElevatedButtonStyle =>
      ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
      );

  static ButtonStyle get registerTextButtonStyle => TextButton.styleFrom(
        foregroundColor: primaryCyan,
      );
}