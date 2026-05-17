import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_localizations.dart';
import 'app_preferences.dart';

enum LegalDocumentType { terms, privacy }

extension LegalDocumentInfo on LegalDocumentType {
  String get titleKey => switch (this) {
    LegalDocumentType.terms => 'legal.terms_title',
    LegalDocumentType.privacy => 'legal.privacy_title',
  };

  String assetPath(String languageCode) {
    final language = languageCode == 'en' ? 'en' : 'es';
    return switch (this) {
      LegalDocumentType.terms => 'assets/legal/terms_$language.txt',
      LegalDocumentType.privacy => 'assets/legal/privacy_$language.txt',
    };
  }
}

Future<void> showLegalDocument(
  BuildContext context,
  LegalDocumentType document,
) async {
  final title = context.tr(document.titleKey);
  final loadError = context.tr('legal.load_error');
  final language = AppPreferences.instance.locale.languageCode;
  final assetPath = document.assetPath(language);

  String content;
  try {
    content = await rootBundle.loadString(assetPath);
  } catch (_) {
    content = loadError;
  }

  if (!context.mounted) return;

  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final size = MediaQuery.sizeOf(context);

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 32),
        backgroundColor: isDark ? const Color(0xFF0D1B2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 560,
            maxHeight: size.height * 0.72,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF16C7E8), Color(0xFF0B7CFF)],
                        ),
                      ),
                      child: const Icon(
                        Icons.policy_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F1E3A),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      icon: Icon(
                        Icons.close_rounded,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF5B6B82),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Flexible(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : const Color(0xFFF6F9FE),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.10)
                            : const Color(0xFFDDE7F5),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        content,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.78)
                              : const Color(0xFF40516A),
                          fontSize: 13,
                          height: 1.45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text(context.tr('legal.close')),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
