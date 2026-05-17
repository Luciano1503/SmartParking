import 'package:flutter/material.dart';

import '../Core/app_localizations.dart';
import '../Core/app_preferences.dart';

class PreferencesControls extends StatelessWidget {
  final bool compact;

  const PreferencesControls({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final preferences = AppPreferencesScope.watch(context);
    final iconSize = compact ? 20.0 : 24.0;
    final buttonSize = compact ? 36.0 : 44.0;
    final modeLabel = preferences.isDarkMode
        ? context.tr('common.dark_mode')
        : context.tr('common.light_mode');

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(compact ? 3 : 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: modeLabel,
              visualDensity: VisualDensity.compact,
              constraints: BoxConstraints.tightFor(
                width: buttonSize,
                height: buttonSize,
              ),
              padding: EdgeInsets.zero,
              iconSize: iconSize,
              onPressed: preferences.toggleTheme,
              icon: Icon(
                preferences.isDarkMode
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(compact ? 38 : 44, buttonSize),
                padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12),
                visualDensity: VisualDensity.compact,
              ),
              onPressed: preferences.toggleLanguage,
              child: Text(
                preferences.locale.languageCode.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
