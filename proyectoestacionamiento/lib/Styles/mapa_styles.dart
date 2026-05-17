import 'package:flutter/material.dart';
import '../Core/app_localizations.dart';
import '../Core/app_preferences.dart';

class MapaStyles {
  MapaStyles._();

  // Colors
  static bool get _dark => AppPreferences.instance.isDarkMode;
  static Color get pageBackground =>
      _dark ? const Color(0xFF08111F) : const Color(0xFFF0F6FF);
  static Color get surface =>
      _dark ? const Color(0xFF101B2E) : Colors.white;
  static Color get softSurface =>
      _dark ? const Color(0xFF0D1728) : const Color(0xFFE8F1FA);
  static const Color headerBackground = Color(0xFF0A2540);
  static const Color darkInput = Color(0xFF0A1628);
  static const Color darkBorder = Color(0xFF1E3A5F);

  static const Color primaryBlue = Color(0xFF0072FF);
  static const Color primaryCyan = Color(0xFF00C6FF);
  static const Color lightCyan = Color(0xFF8ADFFF);

  static const Color mutedBlue = Color(0xFF7BA7C2);
  static const Color softBlue = Color(0xFF4A7090);
  static const Color hintBlue = Color(0xFF2E4F70);
  static Color get textDark =>
      _dark ? const Color(0xFFEEF6FF) : const Color(0xFF0A2540);
  static Color get textSoftDark =>
      _dark ? const Color(0xFFA8BAD2) : const Color(0xFF4A6A85);

  static Color get placeholderBg => softSurface;
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleRed = Color(0xFFE53935);

  static const Color successGreen = Color(0xFF00A86B);
  static const Color purple = Color(0xFF7B61FF);

  static Color get bottomNavBackground => surface;
  static const Color bottomNavSelected = primaryBlue;
  static Color get bottomNavUnselected =>
      _dark ? const Color(0xFF6F86A6) : const Color(0xFF9EBCD4);

  // Padding
  static const EdgeInsets headerOuterPadding = EdgeInsets.fromLTRB(
    16,
    4,
    16,
    20,
  );
  static const EdgeInsets headerHelpPadding = EdgeInsets.fromLTRB(14, 4, 14, 0);
  static const EdgeInsets searchRowPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const EdgeInsets infoChipsPadding = EdgeInsets.fromLTRB(16, 14, 16, 0);
  static const EdgeInsets mapAreaPadding = EdgeInsets.fromLTRB(16, 0, 16, 16);
  static const EdgeInsets gpsBadgePadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 5,
  );
  static const EdgeInsets searchButtonPadding = EdgeInsets.symmetric(
    horizontal: 18,
  );
  static const EdgeInsets legendPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 7,
  );
  static const EdgeInsets infoChipPadding = EdgeInsets.symmetric(
    vertical: 10,
    horizontal: 10,
  );
  static const EdgeInsets placeholderButtonPadding = EdgeInsets.symmetric(
    horizontal: 24,
  );

  // Decorations
  static const BoxDecoration headerDecoration = BoxDecoration(
    color: headerBackground,
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(28),
      bottomRight: Radius.circular(28),
    ),
  );

  static BoxDecoration gpsBadgeDecoration(bool active) {
    return BoxDecoration(
      color: active
          ? primaryCyan.withValues(alpha: 0.15)
          : Colors.orange.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: active
            ? primaryCyan.withValues(alpha: 0.4)
            : Colors.orange.withValues(alpha: 0.4),
      ),
    );
  }

  static BoxDecoration get searchFieldDecoration => BoxDecoration(
    color: darkInput,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: darkBorder),
  );

  static BoxDecoration get searchButtonDecoration => BoxDecoration(
    gradient: const LinearGradient(colors: [primaryCyan, primaryBlue]),
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: primaryBlue.withValues(alpha: 0.4),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get placeholderIconDecoration => BoxDecoration(
    gradient: const LinearGradient(colors: [primaryCyan, primaryBlue]),
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: primaryBlue.withValues(alpha: 0.30),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );

  static BoxDecoration placeholderButtonDecoration() => BoxDecoration(
    gradient: const LinearGradient(colors: [primaryCyan, primaryBlue]),
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: primaryBlue.withValues(alpha: 0.35),
        blurRadius: 14,
        offset: const Offset(0, 5),
      ),
    ],
  );

  static BoxDecoration infoChipDecoration(Color color) => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: color.withValues(alpha: 0.08),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get mapFabDecoration => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(13),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.12),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get legendDecoration => BoxDecoration(
    color: surface.withValues(alpha: 0.92),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 10,
        offset: const Offset(0, 3),
      ),
    ],
  );

  static BoxDecoration get bottomNavDecoration => BoxDecoration(
    color: bottomNavBackground,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(24),
      topRight: Radius.circular(24),
    ),
    boxShadow: [
      BoxShadow(
        color: primaryBlue.withValues(alpha: 0.10),
        blurRadius: 24,
        offset: const Offset(0, -6),
      ),
    ],
  );

  // Text styles
  static const TextStyle headerTitleStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 18,
  );

  static const TextStyle headerHelpStyle = TextStyle(
    color: softBlue,
    fontSize: 13,
  );

  static TextStyle gpsBadgeTextStyle(bool active) => TextStyle(
    color: active ? primaryCyan : Colors.orange,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle searchFieldStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
  );

  static const TextStyle searchHintStyle = TextStyle(
    color: hintBlue,
    fontSize: 13,
  );

  static const TextStyle searchButtonTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 13,
  );

  static TextStyle get placeholderTitleStyle => TextStyle(
    color: textDark,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get placeholderSubtitleStyle => TextStyle(
    color: textSoftDark,
    fontSize: 13,
    height: 1.5,
  );

  static const TextStyle placeholderButtonTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );

  static TextStyle infoChipTextStyle(Color color) => TextStyle(
    color: color.withValues(alpha: 0.85),
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static TextStyle get legendTextStyle => TextStyle(
    color: textDark,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bottomNavLabelStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  // Input decoration
  static InputDecoration searchInputDecoration(BuildContext context) =>
      InputDecoration(
    hintText: context.tr('map.search_hint'),
    hintStyle: searchHintStyle,
    prefixIcon: Icon(Icons.search_rounded, color: softBlue, size: 20),
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );

  // Buttons
  static ButtonStyle get transparentSearchButtonStyle =>
      ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: searchButtonPadding,
      );

  static ButtonStyle get transparentPlaceholderButtonStyle =>
      ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: placeholderButtonPadding,
      );

  // SnackBar
  static SnackBar buildSnackBar(String message) {
    return SnackBar(
      content: Text(message),
      backgroundColor: primaryBlue,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
