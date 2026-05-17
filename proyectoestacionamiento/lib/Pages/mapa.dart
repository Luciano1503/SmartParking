import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Core/app_localizations.dart';
import '../Styles/mapa_styles.dart';
import '../Widgets/mapa_widgets.dart';
import '../Widgets/preferences_controls.dart';
import '../Services/geocoding_service.dart';
import '../Services/location_service.dart';
import 'estacionamientos.dart';
import 'misdatos.dart';
import 'premium.dart';
import 'acercade.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final LocationService _locationService = LocationService();
  final GeocodingService _geocodingService = GeocodingService();
  int _selectedIndex = 2; // Mapa es el tab central (índice 2)

  void _onTabTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  // ── Mapa ───────────────────────────────────────────────────
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;
  bool _locationLoading = true;

  final Set<Marker> _markers = {};

  void _safeSetState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(MapaStyles.buildSnackBar(message));
  }

  @override
  void initState() {
    super.initState();
    _checkUbicacion();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _checkUbicacion() async {
    _safeSetState(() => _locationLoading = true);

    try {
      final position = await _locationService.getCurrentPosition();
      if (!mounted) return;

      _safeSetState(() {
        _currentPosition = position;
        _locationLoading = false;
        _markers.removeWhere((marker) => marker.markerId.value == 'usuario');
        _markers.add(
          Marker(
            markerId: const MarkerId('usuario'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(title: context.tr('map.user_location')),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
        );
      });

      _showSnackBar(context.tr('map.location_detected'));
    } catch (error) {
      if (!mounted) return;
      _safeSetState(() => _locationLoading = false);
      _showSnackBar(error.toString());
    }
  }

  Future<void> _buscarLugar() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      _showSnackBar(context.tr('map.write_place'));
      return;
    }

    _safeSetState(() => _isSearching = true);

    try {
      final place = await _geocodingService.searchPlace(query);
      if (!mounted) return;

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(place.latitude, place.longitude), 15),
      );

      _safeSetState(() {
        _markers.removeWhere((marker) => marker.markerId.value == 'busqueda');
        _markers.add(
          Marker(
            markerId: const MarkerId('busqueda'),
            position: LatLng(place.latitude, place.longitude),
            infoWindow: InfoWindow(title: query),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        );
      });

      _showSnackBar(context.tr('map.location_found', {'query': query}));
    } catch (error) {
      if (!mounted) return;
      _showSnackBar(error.toString());
    } finally {
      _safeSetState(() => _isSearching = false);
    }
  }

  void _centerOnUser() {
    if (_currentPosition != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          15,
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentPosition != null) {
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          15,
        ),
      );
    }
  }

  // ── Páginas de los tabs ────────────────────────────────────
  Widget _buildMapView() {
    return Column(
      children: [
        MapHeader(
          currentPosition: _currentPosition,
          locationLoading: _locationLoading,
          searchController: _searchController,
          isSearching: _isSearching,
          onSearch: _buscarLugar,
        ),
        Padding(
          padding: MapaStyles.infoChipsPadding,
          child: Row(
            children: [
              InfoChip(
                icon: Icons.local_parking_rounded,
                label: context.tr('map.nearby_affiliates'),
                color: MapaStyles.primaryBlue,
              ),
              const SizedBox(width: 10),
              InfoChip(
                icon: Icons.verified_rounded,
                label: context.tr('map.verified_zones'),
                color: MapaStyles.successGreen,
              ),
              const SizedBox(width: 10),
              InfoChip(
                icon: Icons.security_rounded,
                label: context.tr('map.watched'),
                color: MapaStyles.purple,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Padding(
            padding: MapaStyles.mapAreaPadding,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  _currentPosition == null
                      ? LocationPlaceholder(
                          loading: _locationLoading,
                          onRetry: _checkUbicacion,
                        )
                      : GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            ),
                            zoom: 15,
                          ),
                          onMapCreated: _onMapCreated,
                          markers: _markers,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                        ),
                  if (_currentPosition != null)
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Column(
                        children: [
                          MapFab(
                            icon: Icons.my_location_rounded,
                            onTap: _centerOnUser,
                            tooltip: context.tr('map.my_location'),
                          ),
                          const SizedBox(height: 10),
                          MapFab(
                            icon: Icons.refresh_rounded,
                            onTap: _checkUbicacion,
                            tooltip: context.tr('map.refresh'),
                          ),
                        ],
                      ),
                    ),
                  if (_currentPosition != null)
                    const Positioned(top: 12, left: 12, child: MapLegend()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> get _pages => const [
    EstacionamientosPage(), // índice 0
    PremiumPage(), // índice 1
    SizedBox.shrink(), // índice 2 → _buildMapView() se maneja aparte
    MisDatosPage(), // índice 3 → ahora muestra la página real
    AcercaDePage(), // índice 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MapaStyles.pageBackground,
      // Usamos IndexedStack para mantener el estado de cada tab vivo
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _pages[0], // Estacionamientos
          _pages[1], // Premium
          _buildMapView(), // Mapa (índice 2)
          _pages[3], // Mis Datos
          _pages[4], // Acerca de
        ],
      ),
      bottomNavigationBar: _buildBottomArea(),
    );
  }

  Widget _buildBottomArea() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          color: MapaStyles.bottomNavBackground,
          child: const SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 6),
              child: Align(
                alignment: Alignment.centerRight,
                child: PreferencesControls(compact: true),
              ),
            ),
          ),
        ),
        _buildBottomNav(),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: MapaStyles.bottomNavDecoration,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 74,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.local_parking_rounded,
                label: context.tr('nav.parking'),
                selected: _selectedIndex == 0,
                onTap: () => _onTabTapped(0),
              ),
              _NavItem(
                icon: Icons.star_outline_rounded,
                label: context.tr('nav.plans'),
                selected: _selectedIndex == 1,
                onTap: () => _onTabTapped(1),
              ),
              // Tab central destacado
              _NavItemCenter(
                selected: _selectedIndex == 2,
                onTap: () => _onTabTapped(2),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: context.tr('nav.my_data'),
                selected: _selectedIndex == 3,
                onTap: () => _onTabTapped(3),
              ),
              _NavItem(
                icon: Icons.info_outline_rounded,
                label: context.tr('nav.about'),
                selected: _selectedIndex == 4,
                onTap: () => _onTabTapped(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? MapaStyles.bottomNavSelected
        : MapaStyles.bottomNavUnselected;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: selected
                    ? MapaStyles.primaryBlue.withValues(alpha: 0.10)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textScaler: TextScaler.noScaling,
              style: MapaStyles.bottomNavLabelStyle.copyWith(
                color: color,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemCenter extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const _NavItemCenter({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón central flotante destacado
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [MapaStyles.primaryCyan, MapaStyles.primaryBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: MapaStyles.primaryBlue.withValues(alpha: 0.45),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: MapaStyles.primaryBlue.withValues(alpha: 0.20),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
              ),
              child: const Icon(
                Icons.map_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              context.tr('nav.map'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textScaler: TextScaler.noScaling,
              style: MapaStyles.bottomNavLabelStyle.copyWith(
                height: 1,
                color: selected
                    ? MapaStyles.bottomNavSelected
                    : MapaStyles.bottomNavUnselected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
