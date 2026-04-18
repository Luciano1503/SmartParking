import 'package:flutter/material.dart';
import '../Styles/acercadeStyles.dart';

class HeroTitle extends StatelessWidget {
  const HeroTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [AcercaDeStyles.cyan, AcercaDeStyles.white],
      ).createShader(bounds),
      child: const Text(
        'Acerca de',
        style: AcercaDeStyles.heroTitleTextStyle,
      ),
    );
  }
}

class HeroBackground extends StatelessWidget {
  const HeroBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/carros.jpeg', fit: BoxFit.cover),
        Container(decoration: AcercaDeStyles.heroOverlayDecoration),
        Positioned(
          top: -40,
          right: -40,
          child: Container(
            width: 180,
            height: 180,
            decoration: AcercaDeStyles.heroGlowDecoration,
          ),
        ),
      ],
    );
  }
}

class BrandIntroCard extends StatelessWidget {
  const BrandIntroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AcercaDeStyles.brandCardInnerPadding,
      decoration: AcercaDeStyles.brandCardDecoration,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BrandHeaderRow(),
          SizedBox(height: 20),
          Text('¿Quiénes somos?', style: AcercaDeStyles.sectionTitleStyle),
          SizedBox(height: 10),
          Text(
            'Somos una empresa dedicada a optimizar la experiencia de estacionamiento en universidades, centros comerciales y corporaciones. '
            'Nuestro objetivo es brindar seguridad, comodidad y tecnología de punta para que tu vehículo siempre esté en el mejor lugar.',
            style: AcercaDeStyles.paragraphStyle,
          ),
        ],
      ),
    );
  }
}

class BrandHeaderRow extends StatelessWidget {
  const BrandHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: AcercaDeStyles.brandLogoDecoration,
          child: const Icon(
            Icons.local_parking_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AcercaDeStyles.blue, AcercaDeStyles.cyan],
              ).createShader(bounds),
              child: const Text(
                'SmartParking',
                style: AcercaDeStyles.brandNameStyle,
              ),
            ),
            const Text('SOLUTIONS', style: AcercaDeStyles.brandMiniLabelStyle),
          ],
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String value;
  final String label;

  const StatCard({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AcercaDeStyles.statCardPadding,
      decoration: AcercaDeStyles.statCardDecoration,
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AcercaDeStyles.cyan, AcercaDeStyles.blue],
            ).createShader(bounds),
            child: Text(value, style: AcercaDeStyles.statValueStyle),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AcercaDeStyles.statLabelStyle,
          ),
        ],
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String label;

  const SectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AcercaDeStyles.cyan, AcercaDeStyles.blue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(label, style: AcercaDeStyles.sectionLabelTextStyle),
      ],
    );
  }
}

class OfferImageBanner extends StatelessWidget {
  final String imagePath;
  final String text;

  const OfferImageBanner({
    super.key,
    required this.imagePath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: AcercaDeStyles.heroImageHeight,
          ),
          Container(
            height: AcercaDeStyles.heroImageHeight,
            decoration: AcercaDeStyles.imageBottomOverlayDecoration,
          ),
          Positioned(
            bottom: 16,
            left: 18,
            right: 18,
            child: Text(text, style: AcercaDeStyles.bannerTextStyle),
          ),
        ],
      ),
    );
  }
}

class TechImageBanner extends StatelessWidget {
  final String imagePath;
  final String text;

  const TechImageBanner({
    super.key,
    required this.imagePath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: AcercaDeStyles.heroImageHeight,
          ),
          Container(
            height: AcercaDeStyles.heroImageHeight,
            decoration: AcercaDeStyles.imageBottomOverlayDecoration,
          ),
          Positioned(
            bottom: 16,
            left: 18,
            right: 18,
            child: Text(text, style: AcercaDeStyles.bannerTextStyle),
          ),
        ],
      ),
    );
  }
}

class FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AcercaDeStyles.featureCardPadding,
      decoration: AcercaDeStyles.featureCardDecoration,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: AcercaDeStyles.featureIconDecoration,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AcercaDeStyles.featureTitleStyle),
                const SizedBox(height: 3),
                Text(subtitle, style: AcercaDeStyles.featureSubtitleStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TechnologyInfoCard extends StatelessWidget {
  const TechnologyInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AcercaDeStyles.infoCardPadding,
      decoration: AcercaDeStyles.infoCardDecoration,
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: AcercaDeStyles.blue, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Con SmartParking Solutions podrás acceder a estacionamientos afiliados, visualizar mapas en tiempo real y gestionar tu historial de uso desde una sola aplicación.',
              style: AcercaDeStyles.infoCardTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class GradientCtaButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const GradientCtaButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AcercaDeStyles.ctaHeight,
      child: DecoratedBox(
        decoration: AcercaDeStyles.ctaDecoration,
        child: ElevatedButton.icon(
          style: AcercaDeStyles.transparentIconButtonStyle,
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white, size: 20),
          label: Text(label, style: AcercaDeStyles.ctaTextStyle),
        ),
      ),
    );
  }
}