import 'package:flutter/material.dart';
import '../Styles/premiumStyles.dart';
import '../Widgets/premiumWidgets.dart';

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
              child: const Column(
                children: [
                  PlanCard(
                    title: "Plan Básico",
                    subtitle: "Para explorar sin compromiso",
                    price: "Gratis",
                    priceNote: "Sin costo",
                    icon: Icons.map_outlined,
                    accentColor: PremiumStyles.successGreen,
                    isPrimary: false,
                    features: [
                      FeatureItem(
                        icon: Icons.location_on_outlined,
                        text: "Acceso limitado a estacionamientos",
                      ),
                      FeatureItem(
                        icon: Icons.map_outlined,
                        text: "Visualización básica del mapa",
                      ),
                      FeatureItem(
                        icon: Icons.campaign_outlined,
                        text: "Anuncios por defecto",
                        disabled: true,
                      ),
                    ],
                    description:
                        "Ideal para usuarios que solo necesitan una vista rápida de estacionamientos cercanos.",
                  ),
                  SizedBox(height: 16),
                  PlanCard(
                    title: "Plan Premium",
                    subtitle: "La experiencia completa",
                    price: "S/ 38.00",
                    priceNote: "≈ 10 USD / mes",
                    icon: Icons.workspace_premium_rounded,
                    accentColor: PremiumStyles.primaryBlue,
                    isPrimary: true,
                    features: [
                      FeatureItem(
                        icon: Icons.check_circle_outline,
                        text: "Todo lo del Plan Básico",
                      ),
                      FeatureItem(
                        icon: Icons.history_rounded,
                        text: "Historial de estacionamientos usados",
                      ),
                      FeatureItem(
                        icon: Icons.auto_awesome_rounded,
                        text: "Información exclusiva con IA",
                      ),
                      FeatureItem(
                        icon: Icons.block_rounded,
                        text: "Sin anuncios",
                      ),
                      FeatureItem(
                        icon: Icons.support_agent_rounded,
                        text: "Soporte prioritario 24/7",
                      ),
                    ],
                    description:
                        "Diseñado para usuarios frecuentes que buscan comodidad, predicción inteligente y una experiencia sin interrupciones.",
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

