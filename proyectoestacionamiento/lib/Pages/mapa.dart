import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../Styles/mapaStyles.dart';
import '../Widgets/mapaWidgets.dart';
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
  // ── BottomNav ──────────────────────────────────────────────
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

  final String _apiKey = "AIzaSyDU9V_Db6UdM8vuvfQwSghwRdT3v-cOklk";
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _checkUbicacion();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _checkUbicacion() async {
    setState(() => _locationLoading = true);

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar("Por favor, activa tu ubicación para usar este apartado.");
      setState(() => _locationLoading = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar("Permiso de ubicación denegado. Actívalo para continuar.");
        setState(() => _locationLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackBar(
        "Permiso de ubicación denegado permanentemente. Actívalo desde ajustes.",
      );
      setState(() => _locationLoading = false);
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
      _locationLoading = false;
    });

    _showSnackBar("Ubicación detectada correctamente.");
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      MapaStyles.buildSnackBar(message),
    );
  }

  Future<void> _buscarLugar() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      _showSnackBar("Escribe un lugar para buscar.");
      return;
    }

    setState(() => _isSearching = true);

    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json?address=$query&key=$_apiKey",
    );

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data["status"] == "OK" && data["results"].isNotEmpty) {
        final location = data["results"][0]["geometry"]["location"];
        final lat = location["lat"];
        final lng = location["lng"];

        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15),
        );

        setState(() {
          _markers.add(
            Marker(
              markerId: const MarkerId("busqueda"),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(title: query),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
            ),
          );
        });

        _showSnackBar("Ubicación encontrada: $query");
      } else {
        _showSnackBar("No se encontró la dirección: $query");
      }
    } catch (e) {
      _showSnackBar("Error al buscar dirección: $e");
    } finally {
      setState(() => _isSearching = false);
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
    if (_currentPosition == null) return;

    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId("usuario"),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          infoWindow: const InfoWindow(title: "Tu ubicación"),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );
    });
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
        const Padding(
          padding: MapaStyles.infoChipsPadding,
          child: Row(
            children: [
              InfoChip(
                icon: Icons.local_parking_rounded,
                label: "Afiliados cercanos",
                color: MapaStyles.primaryBlue,
              ),
              SizedBox(width: 10),
              InfoChip(
                icon: Icons.verified_rounded,
                label: "Zonas verificadas",
                color: MapaStyles.successGreen,
              ),
              SizedBox(width: 10),
              InfoChip(
                icon: Icons.security_rounded,
                label: "Vigilados 24/7",
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
                            tooltip: "Mi ubicación",
                          ),
                          const SizedBox(height: 10),
                          MapFab(
                            icon: Icons.refresh_rounded,
                            onTap: _checkUbicacion,
                            tooltip: "Actualizar",
                          ),
                        ],
                      ),
                    ),
                  if (_currentPosition != null)
                    const Positioned(
                      top: 12,
                      left: 12,
                      child: MapLegend(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

// Páginas embebidas (sin Scaffold propio para heredar el BottomNav)
static const List<Widget> _pages = [
  EstacionamientosPage(),  // índice 0
  PremiumPage(),           // índice 1
  SizedBox.shrink(),       // índice 2 → _buildMapView() se maneja aparte
  MisDatosPage(),          // índice 3 → ahora muestra la página real
  AcercaDePage(),          // índice 4
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
    bottomNavigationBar: _buildBottomNav(),
  );
}


  Widget _buildBottomNav() {
    return Container(
      decoration: MapaStyles.bottomNavDecoration,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.local_parking_rounded,
                label: "Parking",
                selected: _selectedIndex == 0,
                onTap: () => _onTabTapped(0),
              ),
              _NavItem(
                icon: Icons.star_outline_rounded,
                label: "Planes",
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
                label: "Mis datos",
                selected: _selectedIndex == 3,
                onTap: () => _onTabTapped(3),
              ),
              _NavItem(
                icon: Icons.info_outline_rounded,
                label: "Acerca de",
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

// ── Widgets internos del BottomNav ─────────────────────────

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: selected
                    ? MapaStyles.primaryBlue.withOpacity(0.10)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: MapaStyles.bottomNavLabelStyle.copyWith(color: color),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón central flotante destacado
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              height: 52,
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
                          color: MapaStyles.primaryBlue.withOpacity(0.45),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: MapaStyles.primaryBlue.withOpacity(0.20),
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
              "Mapa",
              style: MapaStyles.bottomNavLabelStyle.copyWith(
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