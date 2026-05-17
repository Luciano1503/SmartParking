import 'package:flutter/material.dart';
import '../Core/app_localizations.dart';
import '../Styles/premium_styles.dart';
import '../Widgets/premium_widgets.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PremiumStyles.pageBackground,
      body: Column(
        children: [
          const HeaderPremium(),
          Expanded(
            child: SingleChildScrollView(
              padding: PremiumStyles.contentPadding,
              child: Column(
                children: [
                  PlanCard(
                    title: context.tr('premium.basic_plan'),
                    subtitle: context.tr('premium.basic_subtitle'),
                    price: context.tr('premium.free'),
                    priceNote: context.tr('premium.no_cost'),
                    icon: Icons.map_outlined,
                    accentColor: PremiumStyles.successGreen,
                    isPrimary: false,
                    features: [
                      FeatureItem(
                        icon: Icons.location_on_outlined,
                        text: context.tr('premium.limited_access'),
                      ),
                      FeatureItem(
                        icon: Icons.map_outlined,
                        text: context.tr('premium.basic_map'),
                      ),
                      FeatureItem(
                        icon: Icons.campaign_outlined,
                        text: context.tr('premium.default_ads'),
                        disabled: true,
                      ),
                    ],
                    description: context.tr('premium.basic_description'),
                  ),
                  const SizedBox(height: 16),
                  PlanCard(
                    title: context.tr('premium.premium_plan'),
                    subtitle: context.tr('premium.complete_experience'),
                    price: "S/ 38.00",
                    priceNote: "≈ 10 USD / mes",
                    icon: Icons.workspace_premium_rounded,
                    accentColor: PremiumStyles.primaryBlue,
                    isPrimary: true,
                    features: [
                      FeatureItem(
                        icon: Icons.check_circle_outline,
                        text: context.tr('premium.everything_basic'),
                      ),
                      FeatureItem(
                        icon: Icons.history_rounded,
                        text: context.tr('premium.history'),
                      ),
                      FeatureItem(
                        icon: Icons.auto_awesome_rounded,
                        text: context.tr('premium.ai_info'),
                      ),
                      FeatureItem(
                        icon: Icons.block_rounded,
                        text: context.tr('premium.no_ads'),
                      ),
                      FeatureItem(
                        icon: Icons.support_agent_rounded,
                        text: context.tr('premium.priority_support'),
                      ),
                    ],
                    description: context.tr('premium.premium_description'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
