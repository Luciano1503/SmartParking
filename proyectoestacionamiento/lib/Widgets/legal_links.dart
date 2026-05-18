import 'package:flutter/material.dart';

import '../Core/app_localizations.dart';
import '../Core/legal_documents.dart';

class LegalLinksCard extends StatelessWidget {
  final bool compact;

  const LegalLinksCard({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white70 : const Color(0xFF4B647E);
    final background = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : const Color(0xFFF2F7FF);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : const Color(0xFFD5E5F7);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 14,
        vertical: compact ? 8 : 14,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(compact ? 14 : 18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: const Color(0xFF0B7CFF),
                size: compact ? 15 : 20,
              ),
              SizedBox(width: compact ? 6 : 8),
              Expanded(
                child: Text(
                  context.tr('legal.notice'),
                  style: TextStyle(
                    color: textColor,
                    fontSize: compact ? 10.5 : 13,
                    height: compact ? 1.2 : 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: compact ? 1 : null,
                  overflow: compact ? TextOverflow.ellipsis : null,
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 4 : 8),
          Wrap(
            spacing: compact ? 6 : 8,
            runSpacing: compact ? 2 : 4,
            children: [
              _LegalChip(
                label: context.tr('legal.terms'),
                icon: Icons.description_outlined,
                compact: compact,
                onPressed: () =>
                    showLegalDocument(context, LegalDocumentType.terms),
              ),
              _LegalChip(
                label: context.tr('legal.privacy'),
                icon: Icons.privacy_tip_outlined,
                compact: compact,
                onPressed: () =>
                    showLegalDocument(context, LegalDocumentType.privacy),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegalChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool compact;
  final VoidCallback onPressed;

  const _LegalChip({
    required this.label,
    required this.icon,
    required this.compact,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: compact ? 13 : 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF0B7CFF),
        side: const BorderSide(color: Color(0xFF0B7CFF)),
        visualDensity: compact
            ? const VisualDensity(horizontal: -3, vertical: -3)
            : VisualDensity.compact,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 9 : 12,
          vertical: compact ? 5 : 8,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        textStyle: TextStyle(
          fontSize: compact ? 10.5 : 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
