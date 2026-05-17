import 'package:flutter/material.dart';
import '../Core/app_preferences.dart';

class AcercaDeStyles {
  AcercaDeStyles._();

  // Colors
  static bool get _dark => AppPreferences.instance.isDarkMode;
  static Color get pageBackground =>
      _dark ? const Color(0xFF08111F) : const Color(0xFFF0F6FF);
  static Color get surface =>
      _dark ? const Color(0xFF101B2E) : Colors.white;
  static Color get textPrimary =>
      _dark ? const Color(0xFFF2F7FF) : const Color(0xFF0A2540);
  static Color get textSecondary =>
      _dark ? const Color(0xFFA9BAD2) : const Color(0xFF4A6A85);
  static const Color appBarBackground = Color(0xFF0A2540);

  static const Color darkBlue = Color(0xFF0A2540);
  static const Color darkerBlue = Color(0xFF0A0E27);
  static const Color cyan = Color(0xFF00C6FF);
  static const Color blue = Color(0xFF0072FF);
  static const Color white = Colors.white;

  static const Color titleDark = Color(0xFF0A2540);
  static const Color textBlueGrey = Color(0xFF4A6A85);
  static const Color textMuted = Color(0xFF7BA7C2);
  static const Color textSoft = Color(0xFF5B7FA0);
  static const Color infoText = Color(0xFF2E5A80);

  // Sizes
  static const double appBarExpandedHeight = 260;
  static const double heroImageHeight = 180;
  static const double ctaHeight = 54;

  // Paddings
  static const EdgeInsets appBarTitlePadding = EdgeInsets.only(
    left: 16,
    bottom: 14,
  );

  static const EdgeInsets brandCardOuterPadding = EdgeInsets.fromLTRB(
    20,
    24,
    20,
    0,
  );

  static const EdgeInsets statsRowPadding = EdgeInsets.fromLTRB(20, 20, 20, 0);

  static const EdgeInsets sectionTopPadding = EdgeInsets.fromLTRB(
    20,
    24,
    20,
    0,
  );

  static const EdgeInsets techSectionPadding = EdgeInsets.fromLTRB(
    20,
    28,
    20,
    14,
  );

  static const EdgeInsets horizontalSectionPadding = EdgeInsets.symmetric(
    horizontal: 20,
  );

  static const EdgeInsets ctaPadding = EdgeInsets.fromLTRB(20, 28, 20, 36);

  static const EdgeInsets brandCardInnerPadding = EdgeInsets.all(24);
  static const EdgeInsets infoCardPadding = EdgeInsets.all(18);
  static const EdgeInsets featureCardPadding = EdgeInsets.all(16);
  static const EdgeInsets statCardPadding = EdgeInsets.symmetric(
    vertical: 16,
    horizontal: 8,
  );

  // Decorations
  static const BoxDecoration heroOverlayDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.transparent, Color(0xCC0A2540)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  static const BoxDecoration imageBottomOverlayDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xCC0A2540), Colors.transparent],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ),
  );

  static BoxDecoration get heroGlowDecoration => BoxDecoration(
    shape: BoxShape.circle,
    gradient: RadialGradient(
      colors: [cyan.withValues(alpha: 0.20), Colors.transparent],
    ),
  );

  static BoxDecoration get brandCardDecoration => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: blue.withValues(alpha: 0.08),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ],
  );

  static BoxDecoration get brandLogoDecoration => BoxDecoration(
    gradient: const LinearGradient(colors: [cyan, blue]),
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: blue.withValues(alpha: 0.35),
        blurRadius: 14,
        offset: const Offset(0, 5),
      ),
    ],
  );

  static BoxDecoration get statCardDecoration => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: blue.withValues(alpha: 0.07),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  );

  static BoxDecoration get featureCardDecoration => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: blue.withValues(alpha: 0.06),
        blurRadius: 14,
        offset: const Offset(0, 5),
      ),
    ],
  );

  static BoxDecoration get featureIconDecoration => BoxDecoration(
    gradient: const LinearGradient(colors: [cyan, blue]),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: blue.withValues(alpha: 0.30),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get infoCardDecoration => BoxDecoration(
    color: blue.withValues(alpha: 0.06),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: blue.withValues(alpha: 0.15)),
  );

  static BoxDecoration get ctaDecoration => BoxDecoration(
    gradient: const LinearGradient(
      colors: [cyan, blue],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: blue.withValues(alpha: 0.35),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );

  // Text styles
  static const TextStyle heroTitleTextStyle = TextStyle(
    color: white,
    fontWeight: FontWeight.w800,
    fontSize: 20,
  );

  static const TextStyle brandNameStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: white,
  );

  static const TextStyle brandMiniLabelStyle = TextStyle(
    fontSize: 10,
    letterSpacing: 3,
    color: textMuted,
  );

  static TextStyle get sectionTitleStyle => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: textPrimary,
  );

  static TextStyle get paragraphStyle => TextStyle(
    fontSize: 14,
    color: textSecondary,
    height: 1.65,
  );

  static const TextStyle statValueStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w900,
    color: white,
  );

  static TextStyle get statLabelStyle => TextStyle(
    color: textSecondary,
    fontSize: 11,
    height: 1.3,
  );

  static TextStyle get sectionLabelTextStyle => TextStyle(
    color: textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle bannerTextStyle = TextStyle(
    color: white,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get featureTitleStyle => TextStyle(
    color: textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get featureSubtitleStyle => TextStyle(
    color: textSecondary,
    fontSize: 12,
    height: 1.4,
  );

  static TextStyle get infoCardTextStyle => TextStyle(
    fontSize: 13,
    color: _dark ? const Color(0xFFB9D8FF) : infoText,
    height: 1.6,
  );

  static const TextStyle ctaTextStyle = TextStyle(
    color: white,
    fontWeight: FontWeight.w700,
    fontSize: 15,
    letterSpacing: 0.3,
  );

  // Button styles
  static ButtonStyle get transparentIconButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}
