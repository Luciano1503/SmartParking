import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart'; // <--- Import para WebSocket

class MapaEstacionamientoPage extends StatefulWidget {
  final int estacionamientoId;
  final String nombreEstacionamiento;
  final String descripcion;

  const MapaEstacionamientoPage({
    super.key,
    required this.estacionamientoId,
    this.nombreEstacionamiento = 'Estacionamiento',
    this.descripcion = 'Estacionamiento 24/7',
  });

  @override
  State<MapaEstacionamientoPage> createState() =>
      _MapaEstacionamientoPageState();
}

class _MapaEstacionamientoPageState extends State<MapaEstacionamientoPage> {
  final String baseUrl = "http://10.131.131.148:8000";
  final String wsUrl = "ws://10.131.131.148:8000/ws/parking";
  List<dynamic> niveles = [];
  bool isLoading = true;
  int _selectedNivelIndex = 0;
  
  IOWebSocketChannel? _channel; // 👈 Variable para controlar el Socket

  static const Color _darkBlue   = Color(0xFF1A2B4A);
  static const Color _accentBlue = Color(0xFF2563EB);
  static const Color _cyan       = Color(0xFF00BCD4);
  static const Color _bgGray     = Color(0xFFF0F4F8);
  static const Color _white      = Colors.white;
  static const Color _red        = Color(0xFFEF4444);

  @override
  void initState() {
    super.initState();
    fetchDetalleMapa();
    _initWebSocket(); // 👈 Iniciamos la escucha del Socket al abrir la pantalla
  }

  @override
  void dispose() {
    _channel?.sink.close(); // 👈 Cerramos el socket al salir para ahorrar batería
    super.dispose();
  }

  // ── Lógica de Tiempo Real (WebSockets) ────────────────────────────
  void _initWebSocket() {
    try {
      _channel = IOWebSocketChannel.connect(Uri.parse(wsUrl));
      _channel!.stream.listen((message) {
        final data = json.decode(message);
        _actualizarEspacioEnMemoria(data['espacio_id'], data['nuevo_estado']);
      }, onError: (error) {
        debugPrint("❌ WS Error: $error");
        // Reintentar conexión si se cae (opcional)
        Future.delayed(const Duration(seconds: 5), () => _initWebSocket());
      });
    } catch (e) {
      debugPrint("❌ No se pudo conectar al WS: $e");
    }
  }

  void _actualizarEspacioEnMemoria(int id, String nuevoEstado) {
    // Buscamos el espacio en la lista cargada y lo actualizamos
    setState(() {
      for (var nivel in niveles) {
        for (var zona in nivel['zonas']) {
          for (var espacio in zona['espacios']) {
            if (espacio['id'] == id) {
              espacio['estado_actual'] = nuevoEstado;
              debugPrint("🚀 UI Actualizada: Espacio $id ahora está $nuevoEstado");
            }
          }
        }
      }
    });
  }

  Future<void> fetchDetalleMapa() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/parking/detalle/${widget.estacionamientoId}'),
      );
      if (response.statusCode == 200) {
        setState(() {
          niveles = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("❌ Error cargando mapa: $e");
      setState(() => isLoading = false);
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────

  int _getTotalEspacios() {
    int total = 0;
    for (final nivel in niveles) {
      for (final zona in (nivel['zonas'] as List)) {
        total += (zona['espacios'] as List).length;
      }
    }
    return total;
  }

  int _getEspaciosNivel(dynamic nivel) {
    int total = 0;
    for (final zona in (nivel['zonas'] as List)) {
      total += (zona['espacios'] as List).length;
    }
    return total;
  }

  /// Columnas de zonas definidas en la BD.
  int _getZonasPorFilaBD(dynamic nivel) {
    final raw = nivel['horizontal'] ?? nivel['columnas'];
    if (raw != null) {
      final cols = int.tryParse(raw.toString());
      if (cols != null && cols > 0) return cols;
    }
    return 3;
  }

  Color _getZonaColor(String nombre) {
    const colors = [
      Color(0xFF2563EB),
      Color(0xFF059669),
      Color(0xFF7C3AED),
      Color(0xFFD97706),
      Color(0xFFDB2777),
      Color(0xFF0891B2),
      Color(0xFFEA580C),
      Color(0xFF16A34A),
    ];
    final letras = nombre.replaceAll(RegExp(r'[^A-Z]'), '');
    if (letras.isEmpty) return colors[0];
    int idx = 0;
    for (final c in letras.runes) {
      idx += c - 'A'.codeUnitAt(0);
    }
    return colors[idx % colors.length];
  }

  // ── Build root ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: _bgGray,
        body: Center(child: CircularProgressIndicator(color: _accentBlue)),
      );
    }

    final nivelActual =
        niveles.isNotEmpty ? niveles[_selectedNivelIndex] : null;

    return Scaffold(
      backgroundColor: _bgGray,
      body: Column(
        children: [
          _buildHeroHeader(),
          _buildResumenPisos(),
          Expanded(
            child: nivelActual != null
                ? _buildDistribucionNivel(nivelActual)
                : const Center(child: Text('Sin datos')),
          ),
        ],
      ),
    );
  }

  // ── Hero Header ───────────────────────────────────────────────────
  Widget _buildHeroHeader() {
    final total = _getTotalEspacios();
    final initials = widget.nombreEstacionamiento
        .split(' ')
        .map((w) => w.isNotEmpty ? w[0] : '')
        .take(3)
        .join();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A2B4A), Color(0xFF243560)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white70, size: 18),
              ),
              const Spacer(),
              Opacity(
                opacity: 0.15,
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: _white,
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nombreEstacionamiento,
                      style: const TextStyle(
                        color: _white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.descripcion,
                      style: const TextStyle(
                          color: Colors.white60, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$total',
                    style: const TextStyle(
                      color: _white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    'ESPACIOS TOTALES',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Selector de pisos ─────────────────────────────────────────────
  Widget _buildResumenPisos() {
    return Container(
      color: _white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RESUMEN POR PISO',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6B7280),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(niveles.length, (i) {
                final nivel = niveles[i];
                final isSelected = i == _selectedNivelIndex;
                final espacios = _getEspaciosNivel(nivel);
                return GestureDetector(
                  onTap: () => setState(() => _selectedNivelIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? _darkBlue : _bgGray,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? _darkBlue
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? _cyan : _accentBlue,
                          ),
                          child: Center(
                            child: Text(
                              'P${i + 1}',
                              style: const TextStyle(
                                color: _white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nivel['nivel']?.toString() ??
                                  'Nivel ${i + 1}',
                              style: TextStyle(
                                color: isSelected
                                    ? _white
                                    : const Color(0xFF374151),
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '$espacios esp.',
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white60
                                    : const Color(0xFF9CA3AF),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ── Distribución del nivel ────────────────────────────────────────
  Widget _buildDistribucionNivel(dynamic nivel) {
    final zonas = nivel['zonas'] as List;

    return Column(
      children: [
        Container(
          color: _white,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'DISTRIBUCIÓN — ${nivel['nivel']?.toString().toUpperCase() ?? ''}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B7280),
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              Text(
                '${zonas.length} div.',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _accentBlue,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Ancho total disponible descontando padding del scroll (12+12)
              final double totalWidth = constraints.maxWidth - 24;
              final int colsBD = _getZonasPorFilaBD(nivel);
              const double gap = 8.0;

              // Ancho exacto de cada tarjeta según columnas de la BD
              final double cardWidth =
                  (totalWidth - gap * (colsBD - 1)) / colsBD;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: _buildZonasWrap(zonas, colsBD, cardWidth, gap),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Wrap de tarjetas de zonas ─────────────────────────────────────
  Widget _buildZonasWrap(
      List zonas, int colsBD, double cardWidth, double gap) {
    // Si la tarjeta mide menos de 68px, los chips van en 1 columna
    final int chipCols = cardWidth >= 68 ? 2 : 1;

    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: zonas.map((zona) {
        return SizedBox(
          width: cardWidth,
          child: _buildZonaCard(zona, chipCols, cardWidth),
        );
      }).toList(),
    );
  }

  // ── Tarjeta de zona ───────────────────────────────────────────────
  Widget _buildZonaCard(dynamic zona, int chipCols, double cardWidth) {
    final nombre    = zona['nombre']?.toString() ?? 'Zona';
    final espacios  = zona['espacios'] as List;
    final letras    = nombre.replaceAll(RegExp(r'[^A-Z]'), '');
    final zonaColor = _getZonaColor(nombre);

    final double pad          = (cardWidth * 0.07).clamp(5.0, 10.0);
    final double avatarRadius = (cardWidth * 0.13).clamp(9.0, 13.0);
    final double labelFont    = (cardWidth * 0.12).clamp(9.0, 13.0);
    final double subFont      = (cardWidth * 0.09).clamp(8.0, 10.0);

    return Container(
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(pad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: avatarRadius,
                backgroundColor: zonaColor,
                child: Text(
                  letras.isNotEmpty ? letras : nombre[0],
                  style: TextStyle(
                    color: _white,
                    fontSize: avatarRadius * 0.72,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(width: pad * 0.5),
              Expanded(
                child: Text(
                  'Div. ${letras.isNotEmpty ? letras : nombre}',
                  style: TextStyle(
                    fontSize: labelFont,
                    fontWeight: FontWeight.w700,
                    color: zonaColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: pad * 0.3),
          Text(
            '${espacios.length} esp.',
            style: TextStyle(
              fontSize: subFont,
              color: const Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: pad * 0.6),
          _buildEspaciosMiniGrid(espacios, chipCols, cardWidth),
        ],
      ),
    );
  }

  // ── Mini-grid de chips de espacios ────────────────────────────────
  Widget _buildEspaciosMiniGrid(
      List espacios, int cols, double cardWidth) {
    final List<Widget> rows = [];
    for (int i = 0; i < espacios.length; i += cols) {
      final slice = espacios.sublist(
        i,
        (i + cols) > espacios.length ? espacios.length : i + cols,
      );
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...slice.map(
                (esp) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(1.5),
                    child: _buildEspacioChip(esp, cardWidth),
                  ),
                ),
              ),
              if (slice.length < cols)
                ...List.generate(
                  cols - slice.length,
                  (_) => const Expanded(child: SizedBox()),
                ),
            ],
          ),
        ),
      );
      rows.add(const SizedBox(height: 2));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }

  // ── Chip individual (ACTUALIZADO CON ESTADOS DE COLORES) ────────
  Widget _buildEspacioChip(dynamic espacio, double cardWidth) {
    final codigo = espacio['codigo']?.toString() ?? '??';
    // Pasamos a minusculas para asegurar que coincida con la BD
    final estado = (espacio['estado_actual']?.toString() ?? 'libre').toLowerCase();

    // Variables para los colores dinamicos
    Color bgColor;
    Color borderColor;
    Color iconColor;
    Color textColor;

    // Logica de estados (Verde, Rojo, Gris)
    if (estado == 'libre') {
      bgColor     = const Color(0xFF10B981).withOpacity(0.12);
      borderColor = const Color(0xFF10B981).withOpacity(0.5);
      iconColor   = const Color(0xFF10B981);
      textColor   = const Color(0xFF047857);
    } else if (estado == 'ocupado') {
      bgColor     = _red.withOpacity(0.12);
      borderColor = _red.withOpacity(0.5);
      iconColor   = _red;
      textColor   = _red;
    } else {
      // 'no operativo', 'mantenimiento' u otros errores
      bgColor     = Colors.grey.shade200;
      borderColor = Colors.grey.shade400;
      iconColor   = Colors.grey.shade500;
      textColor   = Colors.grey.shade700;
    }

    final double iconSize = (cardWidth * 0.16).clamp(10.0, 16.0);
    final double codeFont = (cardWidth * 0.09).clamp(7.0, 10.0);
    final double vertPad  = (cardWidth * 0.04).clamp(2.0, 5.0);

    return Container(
      padding: EdgeInsets.symmetric(vertical: vertPad, horizontal: 1),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: borderColor,
          width: 1.0, 
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.directions_car_rounded,
            size: iconSize,
            color: iconColor,
          ),
          const SizedBox(height: 1),
          Text(
            codigo,
            style: TextStyle(
              fontSize: codeFont,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}