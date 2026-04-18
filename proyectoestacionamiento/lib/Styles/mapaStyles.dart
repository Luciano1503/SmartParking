import 'package:flutter/material.dart';

class MapaStyles {
  MapaStyles._();

  // Colors
  static const Color pageBackground = Color(0xFFF0F6FF);
  static const Color headerBackground = Color(0xFF0A2540);
  static const Color darkInput = Color(0xFF0A1628);
  static const Color darkBorder = Color(0xFF1E3A5F);

  static const Color primaryBlue = Color(0xFF0072FF);
  static const Color primaryCyan = Color(0xFF00C6FF);
  static const Color lightCyan = Color(0xFF8ADFFF);

  static const Color mutedBlue = Color(0xFF7BA7C2);
  static const Color softBlue = Color(0xFF4A7090);
  static const Color hintBlue = Color(0xFF2E4F70);
  static const Color textDark = Color(0xFF0A2540);
  static const Color textSoftDark = Color(0xFF4A6A85);

  static const Color placeholderBg = Color(0xFFE8F1FA);
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleRed = Color(0xFFE53935);

  static const Color successGreen = Color(0xFF00A86B);
  static const Color purple = Color(0xFF7B61FF);

  // BottomNav colors
  static const Color bottomNavBackground = Colors.white;
  static const Color bottomNavSelected = primaryBlue;
  static const Color bottomNavUnselected = Color(0xFF9EBCD4);

  // Padding
  static const EdgeInsets headerOuterPadding =
      EdgeInsets.fromLTRB(16, 4, 16, 20);
  static const EdgeInsets headerHelpPadding =
      EdgeInsets.fromLTRB(14, 4, 14, 0);
  static const EdgeInsets searchRowPadding =
      EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets infoChipsPadding =
      EdgeInsets.fromLTRB(16, 14, 16, 0);
  static const EdgeInsets mapAreaPadding =
      EdgeInsets.fromLTRB(16, 0, 16, 16);
  static const EdgeInsets gpsBadgePadding =
      EdgeInsets.symmetric(horizontal: 10, vertical: 5);
  static const EdgeInsets searchButtonPadding =
      EdgeInsets.symmetric(horizontal: 18);
  static const EdgeInsets legendPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 7);
  static const EdgeInsets infoChipPadding =
      EdgeInsets.symmetric(vertical: 10, horizontal: 10);
  static const EdgeInsets placeholderButtonPadding =
      EdgeInsets.symmetric(horizontal: 24);

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
          ? primaryCyan.withOpacity(0.15)
          : Colors.orange.withOpacity(0.15),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: active
            ? primaryCyan.withOpacity(0.4)
            : Colors.orange.withOpacity(0.4),
      ),
    );
  }

  static BoxDecoration get searchFieldDecoration => BoxDecoration(
        color: darkInput,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: darkBorder),
      );

  static BoxDecoration get searchButtonDecoration => BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryCyan, primaryBlue],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get placeholderIconDecoration => BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryCyan, primaryBlue],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );

  static BoxDecoration placeholderButtonDecoration() => BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryCyan, primaryBlue],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.35),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      );

  static BoxDecoration infoChipDecoration(Color color) => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get mapFabDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get legendDecoration => BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      );

  // BottomNav decoration (sombra superior sutil)
  static BoxDecoration get bottomNavDecoration => BoxDecoration(
        color: bottomNavBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.10),
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

  static const TextStyle placeholderTitleStyle = TextStyle(
    color: textDark,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle placeholderSubtitleStyle = TextStyle(
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
        color: color.withOpacity(0.85),
        fontSize: 10,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  static const TextStyle legendTextStyle = TextStyle(
    color: textDark,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bottomNavLabelStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  // Input decoration
  static const InputDecoration searchInputDecoration = InputDecoration(
    hintText: "Buscar dirección o lugar...",
    hintStyle: searchHintStyle,
    prefixIcon: Icon(
      Icons.search_rounded,
      color: softBlue,
      size: 20,
    ),
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );

  // Buttons
  static ButtonStyle get transparentSearchButtonStyle =>
      ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: searchButtonPadding,
      );

  static ButtonStyle get transparentPlaceholderButtonStyle =>
      ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: placeholderButtonPadding,
      );

  // SnackBar
  static SnackBar buildSnackBar(String message) {
    return SnackBar(
      content: Text(message),
      backgroundColor: primaryBlue,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}