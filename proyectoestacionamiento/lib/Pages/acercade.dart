import 'package:flutter/material.dart';
import 'estacionamientos.dart';
import '../Styles/acercadeStyles.dart';
import '../Widgets/acercadeWidgets.dart';

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
                const Padding(
                  padding: AcercaDeStyles.statsRowPadding,
                  child: Row(
                    children: [
                      Expanded(
                        child: StatCard(value: '+500', label: 'Espacios\nafiliados'),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: StatCard(value: '24/7', label: 'Disponible\nsiempre'),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: StatCard(value: '98%', label: 'Clientes\nsatisfechos'),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: AcercaDeStyles.sectionTopPadding,
                  child: SectionLabel(label: 'Lo que ofrecemos'),
                ),
                const SizedBox(height: 14),
                const Padding(
                  padding: AcercaDeStyles.horizontalSectionPadding,
                  child: OfferImageBanner(
                    imagePath: 'assets/images/estacionamiento.jpg',
                    text: 'Estacionamientos inteligentes en tiempo real',
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: AcercaDeStyles.horizontalSectionPadding,
                  child: Column(
                    children: [
                      FeatureRow(
                        icon: Icons.map_outlined,
                        title: 'Mapas en tiempo real',
                        subtitle: 'Visualiza disponibilidad al instante desde la app',
                      ),
                      SizedBox(height: 12),
                      FeatureRow(
                        icon: Icons.history_rounded,
                        title: 'Historial de uso',
                        subtitle: 'Consulta tus ingresos y egresos cuando quieras',
                      ),
                      SizedBox(height: 12),
                      FeatureRow(
                        icon: Icons.security_rounded,
                        title: 'Seguridad garantizada',
                        subtitle: 'Acceso controlado y monitoreo constante 24/7',
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: AcercaDeStyles.techSectionPadding,
                  child: SectionLabel(label: 'Nuestra tecnología'),
                ),
                const Padding(
                  padding: AcercaDeStyles.horizontalSectionPadding,
                  child: TechImageBanner(
                    imagePath: 'assets/images/smartparking.jpg',
                    text: 'Una sola app para gestionar todo',
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
                    label: 'Ver estacionamientos',
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