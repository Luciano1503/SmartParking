import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../Styles/mapaStyles.dart';

class MapHeader extends StatelessWidget {
  final Position? currentPosition;
  final bool locationLoading;
  final TextEditingController searchController;
  final bool isSearching;
  final VoidCallback onSearch;

  const MapHeader({
    super.key,
    required this.currentPosition,
    required this.locationLoading,
    required this.searchController,
    required this.isSearching,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final gpsActive = currentPosition != null;

    return Container(
      decoration: MapaStyles.headerDecoration,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: MapaStyles.headerOuterPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila de título sin botón de regreso
              Row(
                children: [
                  // Logo compacto
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [MapaStyles.primaryCyan, MapaStyles.primaryBlue],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.local_parking_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Mapa de estacionamientos",
                      style: MapaStyles.headerTitleStyle,
                    ),
                  ),
                  GpsStatusBadge(
                    active: gpsActive,
                    loading: locationLoading,
                  ),
                ],
              ),
              const Padding(
                padding: MapaStyles.headerHelpPadding,
                child: Text(
                  "Verifica estacionamientos cerca de ti",
                  style: MapaStyles.headerHelpStyle,
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: MapaStyles.searchRowPadding,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 46,
                        decoration: MapaStyles.searchFieldDecoration,
                        child: TextField(
                          controller: searchController,
                          style: MapaStyles.searchFieldStyle,
                          onSubmitted: (_) => onSearch(),
                          decoration: MapaStyles.searchInputDecoration,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SearchButton(
                      isSearching: isSearching,
                      onPressed: onSearch,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GpsStatusBadge extends StatelessWidget {
  final bool active;
  final bool loading;

  const GpsStatusBadge({
    super.key,
    required this.active,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MapaStyles.gpsBadgePadding,
      decoration: MapaStyles.gpsBadgeDecoration(active),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? MapaStyles.primaryCyan : Colors.orange,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            loading
                ? "Detectando..."
                : active
                    ? "GPS activo"
                    : "Sin GPS",
            style: MapaStyles.gpsBadgeTextStyle(active),
          ),
        ],
      ),
    );
  }
}

class SearchButton extends StatelessWidget {
  final bool isSearching;
  final VoidCallback onPressed;

  const SearchButton({
    super.key,
    required this.isSearching,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: DecoratedBox(
        decoration: MapaStyles.searchButtonDecoration,
        child: ElevatedButton(
          style: MapaStyles.transparentSearchButtonStyle,
          onPressed: isSearching ? null : onPressed,
          child: isSearching
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  "Buscar",
                  style: MapaStyles.searchButtonTextStyle,
                ),
        ),
      ),
    );
  }
}

class LocationPlaceholder extends StatelessWidget {
  final bool loading;
  final VoidCallback onRetry;

  const LocationPlaceholder({
    super.key,
    required this.loading,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MapaStyles.placeholderBg,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: MapaStyles.placeholderIconDecoration,
              child: Icon(
                loading
                    ? Icons.location_searching_rounded
                    : Icons.location_off_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              loading
                  ? "Detectando tu ubicación..."
                  : "Ubicación no disponible",
              style: MapaStyles.placeholderTitleStyle,
            ),
            const SizedBox(height: 8),
            const Text(
              "Activa el GPS para ver los\nestacionamientos más cercanos a ti",
              textAlign: TextAlign.center,
              style: MapaStyles.placeholderSubtitleStyle,
            ),
            if (!loading) ...[
              const SizedBox(height: 24),
              SizedBox(
                height: 46,
                child: DecoratedBox(
                  decoration: MapaStyles.placeholderButtonDecoration(),
                  child: ElevatedButton.icon(
                    style: MapaStyles.transparentPlaceholderButtonStyle,
                    onPressed: onRetry,
                    icon: const Icon(
                      Icons.location_on_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: const Text(
                      "Activar ubicación",
                      style: MapaStyles.placeholderButtonTextStyle,
                    ),
                  ),
                ),
              ),
            ] else
              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: CircularProgressIndicator(
                  color: MapaStyles.primaryBlue,
                  strokeWidth: 2.5,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const InfoChip({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: MapaStyles.infoChipPadding,
        decoration: MapaStyles.infoChipDecoration(color),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: MapaStyles.infoChipTextStyle(color),
            ),
          ],
        ),
      ),
    );
  }
}

class MapFab extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  const MapFab({
    super.key,
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: MapaStyles.mapFabDecoration,
          child: Icon(
            icon,
            color: MapaStyles.primaryBlue,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class MapLegend extends StatelessWidget {
  const MapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MapaStyles.legendPadding,
      decoration: MapaStyles.legendDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: MapaStyles.googleBlue,
            ),
          ),
          const SizedBox(width: 6),
          const Text("Tu ubicación", style: MapaStyles.legendTextStyle),
          const SizedBox(width: 12),
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: MapaStyles.googleRed,
            ),
          ),
          const SizedBox(width: 6),
          const Text("Búsqueda", style: MapaStyles.legendTextStyle),
        ],
      ),
    );
  }
}