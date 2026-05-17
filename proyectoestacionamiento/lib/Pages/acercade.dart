import 'package:flutter/material.dart';
import 'estacionamientos.dart';
import '../Core/app_localizations.dart';
import '../Styles/acercade_styles.dart';
import '../Widgets/acercade_widgets.dart';

class AcercaDePage extends StatelessWidget {
  const AcercaDePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AcercaDeStyles.pageBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: AcercaDeStyles.appBarExpandedHeight,
            pinned: true,
            automaticallyImplyLeading: false, // sin botón de regreso ni menú
            backgroundColor: AcercaDeStyles.appBarBackground,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: AcercaDeStyles.appBarTitlePadding,
              title: const HeroTitle(),
              background: const HeroBackground(),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: AcercaDeStyles.brandCardOuterPadding,
                  child: BrandIntroCard(),
                ),
                Padding(
                  padding: AcercaDeStyles.statsRowPadding,
                  child: Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          value: '+500',
                          label: context.tr('about.affiliated_spaces'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          value: '24/7',
                          label: context.tr('about.always_available'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          value: '98%',
                          label: context.tr('about.satisfied_customers'),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: AcercaDeStyles.sectionTopPadding,
                  child: SectionLabel(label: context.tr('about.offerings')),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: AcercaDeStyles.horizontalSectionPadding,
                  child: OfferImageBanner(
                    imagePath: 'assets/images/estacionamiento.jpg',
                    text: context.tr('about.smart_parking'),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: AcercaDeStyles.horizontalSectionPadding,
                  child: Column(
                    children: [
                      FeatureRow(
                        icon: Icons.map_outlined,
                        title: context.tr('about.realtime_maps'),
                        subtitle: context.tr('about.realtime_maps_subtitle'),
                      ),
                      const SizedBox(height: 12),
                      FeatureRow(
                        icon: Icons.history_rounded,
                        title: context.tr('about.history'),
                        subtitle: context.tr('about.history_subtitle'),
                      ),
                      const SizedBox(height: 12),
                      FeatureRow(
                        icon: Icons.security_rounded,
                        title: context.tr('about.security'),
                        subtitle: context.tr('about.security_subtitle'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: AcercaDeStyles.techSectionPadding,
                  child: SectionLabel(label: context.tr('about.technology')),
                ),
                Padding(
                  padding: AcercaDeStyles.horizontalSectionPadding,
                  child: TechImageBanner(
                    imagePath: 'assets/images/smartparking.jpg',
                    text: context.tr('about.one_app'),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: AcercaDeStyles.horizontalSectionPadding,
                  child: TechnologyInfoCard(),
                ),
                Padding(
                  padding: AcercaDeStyles.ctaPadding,
                  child: GradientCtaButton(
                    label: context.tr('about.view_parking'),
                    icon: Icons.local_parking_rounded,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EstacionamientosPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
