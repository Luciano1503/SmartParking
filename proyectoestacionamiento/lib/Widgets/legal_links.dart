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
      padding: EdgeInsets.all(compact ? 12 : 14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
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
                size: compact ? 18 : 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.tr('legal.notice'),
                  style: TextStyle(
                    color: textColor,
                    fontSize: compact ? 12 : 13,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 6 : 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _LegalChip(
                label: context.tr('legal.terms'),
                icon: Icons.description_outlined,
                onPressed: () =>
                    showLegalDocument(context, LegalDocumentType.terms),
              ),
              _LegalChip(
                label: context.tr('legal.privacy'),
                icon: Icons.privacy_tip_outlined,
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
  final VoidCallback onPressed;

  const _LegalChip({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF0B7CFF),
        side: const BorderSide(color: Color(0xFF0B7CFF)),
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
      ),
    );
  }
}
