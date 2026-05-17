import 'package:flutter/material.dart';
import '../Core/app_localizations.dart';
import '../Styles/premium_styles.dart';

class HeaderPremium extends StatelessWidget {
  const HeaderPremium({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: PremiumStyles.headerDecoration,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: PremiumStyles.headerPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.tr('premium.title'),
                      style: PremiumStyles.headerTitleStyle,
                    ),
                  ),
                  Container(
                    padding: PremiumStyles.headerBadgePadding,
                    decoration: PremiumStyles.premiumBadgeDecoration,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.workspace_premium_rounded,
                          color: PremiumStyles.primaryCyan,
                          size: 13,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Premium",
                          style: PremiumStyles.premiumBadgeTextStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: PremiumStyles.headerSubtitlePadding,
                child: Text(
                  context.tr('premium.subtitle'),
                  style: PremiumStyles.headerSubtitleStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureItem {
  final IconData icon;
  final String text;
  final bool disabled;

  const FeatureItem({
    required this.icon,
    required this.text,
    this.disabled = false,
  });
}

class PlanCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String priceNote;
  final IconData icon;
  final Color accentColor;
  final bool isPrimary;
  final List<FeatureItem> features;
  final String description;

  const PlanCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.priceNote,
    required this.icon,
    required this.accentColor,
    required this.isPrimary,
    required this.features,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: PremiumStyles.planCardDecoration(
        accentColor: accentColor,
        isPrimary: isPrimary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: PremiumStyles.cardHeaderPadding,
            decoration: PremiumStyles.planHeaderDecoration(
              accentColor: accentColor,
              isPrimary: isPrimary,
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: PremiumStyles.planIconDecoration(
                    accentColor: accentColor,
                    isPrimary: isPrimary,
                  ),
                  child: Icon(
                    icon,
                    color: isPrimary ? Colors.white : accentColor,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: PremiumStyles.planTitleStyle(isPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: PremiumStyles.planSubtitleStyle(isPrimary),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: PremiumStyles.priceStyle(
                        isPrimary: isPrimary,
                        accentColor: accentColor,
                      ),
                    ),
                    Text(
                      priceNote,
                      style: PremiumStyles.priceNoteStyle(isPrimary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: PremiumStyles.featuresPadding,
            child: Column(
              children: features
                  .map((f) => FeatureRow(feature: f, accentColor: accentColor))
                  .toList(),
            ),
          ),
          Padding(
            padding: PremiumStyles.descriptionPadding,
            child: Container(
              padding: PremiumStyles.descriptionInnerPadding,
              decoration: PremiumStyles.descriptionDecoration(accentColor),
              child: Text(
                description,
                style: PremiumStyles.descriptionTextStyle,
              ),
            ),
          ),
          Padding(
            padding: PremiumStyles.ctaPadding,
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: DecoratedBox(
                decoration: PremiumStyles.ctaDecoration(
                  accentColor: accentColor,
                  isPrimary: isPrimary,
                ),
                child: ElevatedButton(
                  style: PremiumStyles.ctaButtonStyle(),
                  onPressed: () {},
                  child: Text(
                    isPrimary
                        ? context.tr('premium.subscribe')
                        : context.tr('premium.continue_free'),
                    style: PremiumStyles.ctaTextStyle(
                      isPrimary: isPrimary,
                      accentColor: accentColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureRow extends StatelessWidget {
  final FeatureItem feature;
  final Color accentColor;

  const FeatureRow({
    super.key,
    required this.feature,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: PremiumStyles.featureIconDecoration(
              accentColor: accentColor,
              disabled: feature.disabled,
            ),
            child: Icon(
              feature.icon,
              size: 16,
              color: feature.disabled ? Colors.grey : accentColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature.text,
              style: PremiumStyles.featureTextStyle(feature.disabled),
            ),
          ),
        ],
      ),
    );
  }
}
