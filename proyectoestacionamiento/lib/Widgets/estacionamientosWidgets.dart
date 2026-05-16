import 'package:flutter/material.dart';
import '../Styles/estacionamientosStyles.dart';
import '../Models/parking_model.dart';
import '../Pages/mapaEstacionamiento.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          EstacionamientosStyles.primaryCyan,
          EstacionamientosStyles.lightCyan,
        ],
      ).createShader(bounds),
      child: const Text(
        'Estacionamientos',
        style: EstacionamientosStyles.pageTitleStyle,
      ),
    );
  }
}

class AffiliatesBadge extends StatelessWidget {
  final int total;

  const AffiliatesBadge({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EstacionamientosStyles.appBarBadgeMargin,
      padding: EstacionamientosStyles.appBarBadgePadding,
      decoration: EstacionamientosStyles.affiliatesBadgeDecoration,
      child: Text(
        '$total afiliados',
        style: EstacionamientosStyles.affiliatesBadgeTextStyle,
      ),
    );
  }
}

class SubHeader extends StatelessWidget {
  const SubHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EstacionamientosStyles.subHeaderPadding,
      decoration: EstacionamientosStyles.subHeaderDecoration,
      child: const Text(
        'Selecciona un estacionamiento afiliado\npara ver su información y disponibilidad',
        style: EstacionamientosStyles.subHeaderTextStyle,
      ),
    );
  }
}

class ParkingCard extends StatelessWidget {
  final Estacionamiento empresa; // 🚀 Cambiado de Map a Estacionamiento
  final VoidCallback onTap;

  const ParkingCard({super.key, required this.empresa, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: EstacionamientosStyles.parkingCardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: EstacionamientosStyles.logoAreaHeight,
              width: double.infinity,
              decoration: EstacionamientosStyles.parkingLogoAreaDecoration,
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: EstacionamientosStyles.parkingLogoPadding,
                      child: _buildLogo(empresa.imagenUrl),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: EstacionamientosStyles.tagPadding,
                      decoration: EstacionamientosStyles.parkingTagDecoration,
                      child: const Text(
                        "Afiliado", // Puedes hacerlo dinámico si agregas 'tag' al modelo
                        style: EstacionamientosStyles.tagTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EstacionamientosStyles.parkingCardContentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          empresa.nombre,
                          style: EstacionamientosStyles.parkingNameStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified_rounded,
                        color: EstacionamientosStyles.primaryBlue,
                        size: 15,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_parking_rounded,
                        color: EstacionamientosStyles.mutedBlue,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${empresa.totalEspacios} espacios',
                        style: EstacionamientosStyles.parkingSpotsStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: EstacionamientosStyles.cardButtonHeight,
                    child: DecoratedBox(
                      decoration:
                          EstacionamientosStyles.primaryButtonDecoration,
                      child: ElevatedButton(
                        style: EstacionamientosStyles.transparentButtonStyle,
                        onPressed: onTap,
                        child: const Text(
                          'Ver detalles',
                          style: EstacionamientosStyles.cardButtonTextStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper para cargar imagen de red o local
  Widget _buildLogo(String? url) {
    if (url != null && url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset('assets/images/utp.png'),
      );
    }
    return Image.asset('assets/images/utp.png');
  }
}

class DetailSheet extends StatelessWidget {
  final Estacionamiento empresa; // 🚀 Cambiado de Map a Estacionamiento

  const DetailSheet({super.key, required this.empresa});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: EstacionamientosStyles.detailSheetDecoration,
      padding: EstacionamientosStyles.detailSheetPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EstacionamientosStyles.handleMargin,
              width: EstacionamientosStyles.bottomHandleWidth,
              height: EstacionamientosStyles.bottomHandleHeight,
              decoration: EstacionamientosStyles.handleDecoration,
            ),
          ),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                padding: EstacionamientosStyles.detailHeaderLogoPadding,
                decoration: EstacionamientosStyles.detailLogoBoxDecoration,
                child: _buildDetailLogo(empresa.imagenUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            empresa.nombre,
                            style: EstacionamientosStyles.detailTitleStyle,
                          ),
                        ),
                        const Icon(
                          Icons.verified_rounded,
                          color: EstacionamientosStyles.primaryBlue,
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: EstacionamientosStyles.detailTagPadding,
                      decoration: EstacionamientosStyles.detailTagDecoration,
                      child: const Text(
                        "Institución",
                        style: EstacionamientosStyles.detailTagTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: EstacionamientosStyles.detailInfoPadding,
            decoration: EstacionamientosStyles.detailInfoCardDecoration,
            child: Column(
              children: [
                InfoRow(
                  icon: Icons.info_outline_rounded,
                  label: 'Descripción',
                  value: empresa.descripcion,
                ),
                const SheetDivider(),
                InfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Dirección',
                  value: empresa.direccion,
                ),
                const SheetDivider(),
                InfoRow(
                  icon: Icons.local_parking_rounded,
                  label: 'Capacidad',
                  value: '${empresa.totalEspacios} espacios totales',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: EstacionamientosStyles.availabilityPadding,
            decoration: EstacionamientosStyles.availabilityDecoration,
            child: const Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  color: EstacionamientosStyles.primaryBlue,
                  size: 18,
                ),
                SizedBox(width: 10),
                Text(
                  'Disponible 24/7 · Vigilancia permanente',
                  style: EstacionamientosStyles.availabilityTextStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: EstacionamientosStyles.closeOutlinedButtonStyle,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: EstacionamientosStyles.softText,
                    size: 18,
                  ),
                  label: const Text(
                    'Cerrar',
                    style: EstacionamientosStyles.closeButtonTextStyle,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: EstacionamientosStyles.mapButtonHeight,
                  child: DecoratedBox(
                    decoration: EstacionamientosStyles.mapButtonDecoration,
                    child: ElevatedButton.icon(
                      style: EstacionamientosStyles.transparentMapButtonStyle,
                      onPressed: () {
                        Navigator.pop(context); // Cierra el modal
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MapaEstacionamientoPage(estacionamientoId: empresa.id),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.map_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: const Text(
                        'Ver en el mapa',
                        style: EstacionamientosStyles.mapButtonTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailLogo(String? url) {
    if (url != null && url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset('assets/images/utp.png'),
      );
    }
    return Image.asset('assets/images/utp.png');
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EstacionamientosStyles.infoRowPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: EstacionamientosStyles.infoIconBoxDecoration,
            child: Icon(
              icon,
              color: EstacionamientosStyles.primaryBlue,
              size: 17,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: EstacionamientosStyles.infoLabelStyle),
                const SizedBox(height: 2),
                Text(value, style: EstacionamientosStyles.infoValueStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SheetDivider extends StatelessWidget {
  const SheetDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: EstacionamientosStyles.pageBackground,
    );
  }
}
