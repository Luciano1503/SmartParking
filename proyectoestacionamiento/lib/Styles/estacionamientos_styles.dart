import 'package:flutter/material.dart';
import '../Core/app_preferences.dart';

class EstacionamientosStyles {
  EstacionamientosStyles._();

  static bool get _dark => AppPreferences.instance.isDarkMode;
  static Color get pageBackground =>
      _dark ? const Color(0xFF07111F) : const Color(0xFFF0F6FF);
  static Color get surface => _dark ? const Color(0xFF0F1D31) : Colors.white;
  static Color get surfaceAlt =>
      _dark ? const Color(0xFF16263B) : const Color(0xFFEAF3FC);
  static Color get textPrimary =>
      _dark ? const Color(0xFFF2F7FF) : const Color(0xFF0A2540);
  static Color get textSecondary =>
      _dark ? const Color(0xFFBFD1E8) : const Color(0xFF4A6A85);
  static Color get headerBackground =>
      _dark ? const Color(0xFF0B1D33) : const Color(0xFFF8FBFF);
  static Color get appBarBackground =>
      _dark ? const Color(0xFF07111F) : const Color(0xFFF8FBFF);
  static const Color backIconColor = Color(0xFF7BA7C2);

  static const Color primaryDark = Color(0xFF0A2540);
  static const Color primaryBlue = Color(0xFF0072FF);
  static const Color primaryCyan = Color(0xFF00C6FF);
  static const Color lightCyan = Color(0xFF8ADFFF);

  static const Color mutedBlue = Color(0xFF7BA7C2);
  static const Color secondaryText = Color(0xFF4A7090);
  static const Color softText = Color(0xFF4A6A85);
  static const Color infoText = Color(0xFF2E5A80);
  static Color get dividerColor =>
      _dark ? const Color(0xFF273B59) : const Color(0xFFBDD5EA);
  static const Color white = Colors.white;

  static const double cardRadius = 20;
  static const double cardButtonRadius = 10;
  static const double sheetRadius = 28;
  static const double actionButtonRadius = 14;
  static const double detailInfoRadius = 18;
  static const double detailSmallRadius = 16;
  static const double tagRadius = 8;
  static const double miniIconRadius = 9;

  static const double logoAreaHeight = 110;
  static const double cardButtonHeight = 34;
  static const double mapButtonHeight = 50;
  static const double bottomHandleWidth = 40;
  static const double bottomHandleHeight = 4;

  static const EdgeInsets gridPadding = EdgeInsets.all(16);

  static const EdgeInsets appBarBadgeMargin = EdgeInsets.only(right: 14);
  static const EdgeInsets appBarBadgePadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  );

  static const EdgeInsets subHeaderPadding = EdgeInsets.fromLTRB(
    20,
    16,
    20,
    18,
  );

  static const EdgeInsets parkingCardContentPadding = EdgeInsets.fromLTRB(
    12,
    10,
    12,
    8,
  );

  static const EdgeInsets parkingLogoPadding = EdgeInsets.all(16);

  static const EdgeInsets tagPadding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 3,
  );

  static const EdgeInsets detailSheetPadding = EdgeInsets.fromLTRB(
    24,
    0,
    24,
    32,
  );

  static const EdgeInsets detailHeaderLogoPadding = EdgeInsets.all(8);

  static const EdgeInsets detailInfoPadding = EdgeInsets.all(18);

  static const EdgeInsets availabilityPadding = EdgeInsets.all(14);

  static const EdgeInsets outlinedButtonPadding = EdgeInsets.symmetric(
    vertical: 14,
  );

  static const EdgeInsets infoRowPadding = EdgeInsets.symmetric(vertical: 8);

  static const EdgeInsets detailTagPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 3,
  );

  static const EdgeInsets handleMargin = EdgeInsets.only(top: 12, bottom: 20);

  static BoxDecoration get subHeaderDecoration => BoxDecoration(
    gradient: _dark
        ? const LinearGradient(
            colors: [Color(0xFF0A2540), Color(0xFF0B1D33)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : null,
    color: _dark ? null : headerBackground,
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(24),
      bottomRight: Radius.circular(24),
    ),
    boxShadow: _dark
        ? null
        : [
            BoxShadow(
              color: primaryBlue.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
  );

  static BoxDecoration get affiliatesBadgeDecoration => BoxDecoration(
    color: primaryBlue.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: const Color(0xFF1E3A5F)),
  );

  static BoxDecoration get parkingCardDecoration => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(cardRadius),
    border: _dark
        ? Border.all(color: const Color(0xFF223853), width: 1)
        : Border.all(color: Colors.white, width: 1),
    boxShadow: [
      BoxShadow(
        color: _dark
            ? Colors.black.withValues(alpha: 0.28)
            : primaryBlue.withValues(alpha: 0.08),
        blurRadius: _dark ? 16 : 18,
        offset: const Offset(0, 6),
      ),
    ],
  );

  static BoxDecoration get parkingLogoAreaDecoration => BoxDecoration(
    color: surfaceAlt,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(cardRadius)),
  );

  static BoxDecoration get parkingTagDecoration => BoxDecoration(
    color: primaryBlue.withValues(alpha: 0.10),
    borderRadius: BorderRadius.circular(tagRadius),
    border: Border.all(color: primaryBlue.withValues(alpha: 0.20)),
  );

  static BoxDecoration get primaryButtonDecoration => BoxDecoration(
    gradient: const LinearGradient(colors: [primaryCyan, primaryBlue]),
    borderRadius: BorderRadius.circular(cardButtonRadius),
    boxShadow: [
      BoxShadow(
        color: primaryBlue.withValues(alpha: 0.30),
        blurRadius: 8,
        offset: const Offset(0, 3),
      ),
    ],
  );

  static BoxDecoration get detailSheetDecoration => BoxDecoration(
    color: pageBackground,
    borderRadius: const BorderRadius.vertical(
      top: Radius.circular(sheetRadius),
    ),
  );

  static BoxDecoration get handleDecoration => BoxDecoration(
    color: dividerColor,
    borderRadius: BorderRadius.circular(2),
  );

  static BoxDecoration get detailLogoBoxDecoration => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(detailSmallRadius),
    boxShadow: [
      BoxShadow(
        color: primaryBlue.withValues(alpha: 0.10),
        blurRadius: 14,
        offset: const Offset(0, 5),
      ),
    ],
  );

  static BoxDecoration get detailTagDecoration => BoxDecoration(
    color: primaryBlue.withValues(alpha: 0.08),
    borderRadius: BorderRadius.circular(tagRadius),
  );

  static BoxDecoration get detailInfoCardDecoration => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(detailInfoRadius),
    boxShadow: [
      BoxShadow(
        color: primaryBlue.withValues(alpha: 0.06),
        blurRadius: 16,
        offset: const Offset(0, 5),
      ),
    ],
  );

  static BoxDecoration get availabilityDecoration => BoxDecoration(
    color: primaryCyan.withValues(alpha: 0.07),
    borderRadius: BorderRadius.circular(actionButtonRadius),
    border: Border.all(color: primaryCyan.withValues(alpha: 0.20)),
  );

  static BoxDecoration get mapButtonDecoration => BoxDecoration(
    gradient: const LinearGradient(
      colors: [primaryCyan, primaryBlue],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    borderRadius: BorderRadius.circular(actionButtonRadius),
    boxShadow: [
      BoxShadow(
        color: primaryBlue.withValues(alpha: 0.35),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  );

  static BoxDecoration get infoIconBoxDecoration => BoxDecoration(
    color: primaryBlue.withValues(alpha: 0.08),
    borderRadius: BorderRadius.circular(miniIconRadius),
  );

  static const TextStyle pageTitleStyle = TextStyle(
    color: white,
    fontWeight: FontWeight.w800,
    fontSize: 20,
  );

  static const TextStyle affiliatesBadgeTextStyle = TextStyle(
    color: primaryCyan,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get subHeaderTextStyle => TextStyle(
    color: _dark ? const Color(0xFFC0D3EA) : textSecondary,
    fontSize: 13,
    height: 1.5,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get parkingNameStyle =>
      TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: textPrimary);

  static TextStyle get parkingSpotsStyle =>
      TextStyle(color: textSecondary, fontSize: 11);

  static const TextStyle tagTextStyle = TextStyle(
    color: primaryBlue,
    fontSize: 9,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle cardButtonTextStyle = TextStyle(
    color: white,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get detailTitleStyle =>
      TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary);

  static const TextStyle detailTagTextStyle = TextStyle(
    color: primaryBlue,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle availabilityTextStyle = TextStyle(
    color: infoText,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get closeButtonTextStyle =>
      TextStyle(color: textSecondary, fontWeight: FontWeight.w600);

  static const TextStyle mapButtonTextStyle = TextStyle(
    color: white,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );

  static TextStyle get infoLabelStyle => TextStyle(
    color: textSecondary,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get infoValueStyle => TextStyle(
    color: textPrimary,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static ButtonStyle get transparentButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(cardButtonRadius),
    ),
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get transparentMapButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(actionButtonRadius),
    ),
  );

  static ButtonStyle get closeOutlinedButtonStyle => OutlinedButton.styleFrom(
    side: BorderSide(color: dividerColor, width: 1.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(actionButtonRadius),
    ),
    padding: outlinedButtonPadding,
  );

  static SnackBar snackBar(String text) {
    return SnackBar(
      content: Text(text),
      backgroundColor: primaryBlue,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
