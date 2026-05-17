import 'dart:async';

import 'package:flutter/material.dart';
import '../Core/app_localizations.dart';
import '../Services/parking_realtime_service.dart';
import '../Services/parking_service.dart';

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
  final ParkingService _parkingService = const ParkingService();
  final ParkingRealtimeService _realtimeService = ParkingRealtimeService();
  List<dynamic> niveles = [];
  bool isLoading = true;
  int _selectedNivelIndex = 0;
  StreamSubscription<Map<String, dynamic>>? _realtimeSubscription;
  bool _reconnectScheduled = false;
  bool _syncingVisualState = false;
  bool _stateUpdateScheduled = false;
  final Map<int, String> _pendingSpaceStates = {};

  static const Color _accentBlue = Color(0xFF2563EB);
  static const Color _white = Colors.white;
  static const Color _red = Color(0xFFEF4444);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _pageBg =>
      _isDark ? const Color(0xFF08111F) : const Color(0xFFF0F4F8);
  Color get _surface => _isDark ? const Color(0xFF101B2E) : Colors.white;
  Color get _primaryText =>
      _isDark ? const Color(0xFFF2F7FF) : const Color(0xFF374151);
  Color get _secondaryText =>
      _isDark ? const Color(0xFFA9BAD2) : const Color(0xFF6B7280);

  @override
  void initState() {
    super.initState();
    fetchDetalleMapa();
    _initWebSocket();
  }

  @override
  void dispose() {
    _realtimeSubscription?.cancel();
    _pendingSpaceStates.clear();
    _realtimeService.close();
    super.dispose();
  }

  void _initWebSocket() {
    try {
      _realtimeSubscription?.cancel();
      _realtimeSubscription = _realtimeService.connect().listen(
        _procesarEventoRealtime,
        onError: (error) {
          debugPrint('WS Error: $error');
          _scheduleReconnect();
        },
        onDone: _scheduleReconnect,
        cancelOnError: true,
      );
    } catch (error) {
      debugPrint('No se pudo conectar al WS: $error');
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (!mounted || _reconnectScheduled) return;

    _reconnectScheduled = true;
    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;

      _reconnectScheduled = false;
      await fetchDetalleMapa(silent: true);
      _initWebSocket();
    });
  }

  Future<void> _sincronizarEstadosDesdeBackend() async {
    if (!mounted || _syncingVisualState) return;

    _syncingVisualState = true;
    try {
      final detalle = await _parkingService.getDetalleMapa(
        widget.estacionamientoId,
      );
      if (!mounted) return;

      _aplicarEstadosDesdeDetalle(_normalizarDetalle(detalle));
    } catch (error) {
      debugPrint('Error sincronizando espacios: $error');
    } finally {
      _syncingVisualState = false;
    }
  }

  void _procesarEventoRealtime(Map<String, dynamic> data) {
    try {
      final estacionamientoId = _asInt(data['estacionamiento_id']);
      if (estacionamientoId != null &&
          estacionamientoId != widget.estacionamientoId) {
        return;
      }

      final espacioId = _asInt(
        data['espacio_id'] ?? data['id'] ?? data['space_id'],
      );
      final nuevoEstado =
          (data['nuevo_estado'] ?? data['estado_actual'] ?? data['estado'])
              ?.toString()
              .trim();

      if (espacioId == null || nuevoEstado == null || nuevoEstado.isEmpty) {
        unawaited(_sincronizarEstadosDesdeBackend());
        return;
      }

      _programarActualizacionVisual(espacioId, nuevoEstado);
    } catch (error) {
      debugPrint('Error procesando evento de espacio: $error');
      unawaited(_sincronizarEstadosDesdeBackend());
    }
  }

  int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  void _programarActualizacionVisual(int id, String nuevoEstado) {
    _pendingSpaceStates[id] = _normalizarEstado(nuevoEstado);
    if (_stateUpdateScheduled) return;

    _stateUpdateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _stateUpdateScheduled = false;
      if (!mounted) {
        _pendingSpaceStates.clear();
        return;
      }

      final estados = Map<int, String>.from(_pendingSpaceStates);
      _pendingSpaceStates.clear();
      if (estados.isEmpty) return;

      final aplicado = _aplicarEstadosEnCopia(estados);
      if (!aplicado) {
        unawaited(_sincronizarEstadosDesdeBackend());
      }
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  bool _aplicarEstadosEnCopia(Map<int, String> estadosPorId) {
    if (niveles.isEmpty || estadosPorId.isEmpty) return false;

    var encontroEspacio = false;
    var huboCambios = false;

    final nivelesActualizados = niveles
        .map((nivel) {
          if (nivel is! Map) return nivel;

          final nivelMap = Map<String, dynamic>.from(nivel);
          final zonas = nivelMap['zonas'];
          if (zonas is! List) return nivelMap;

          nivelMap['zonas'] = zonas
              .map((zona) {
                if (zona is! Map) return zona;

                final zonaMap = Map<String, dynamic>.from(zona);
                final espacios = zonaMap['espacios'];
                if (espacios is! List) return zonaMap;

                zonaMap['espacios'] = espacios
                    .map((espacio) {
                      if (espacio is! Map) return espacio;

                      final id = _asInt(espacio['id']);
                      final nuevoEstado = id == null ? null : estadosPorId[id];
                      if (nuevoEstado == null) return espacio;

                      encontroEspacio = true;
                      final estadoActual = _normalizarEstado(
                        espacio['estado_actual']?.toString() ?? 'libre',
                      );
                      if (estadoActual == nuevoEstado) return espacio;

                      huboCambios = true;
                      return {...espacio, 'estado_actual': nuevoEstado};
                    })
                    .toList(growable: false);

                return zonaMap;
              })
              .toList(growable: false);

          return nivelMap;
        })
        .toList(growable: false);

    if (huboCambios && mounted) {
      setState(() => niveles = nivelesActualizados);
    }

    return encontroEspacio;
  }

  void _aplicarEstadosDesdeDetalle(List<dynamic> detalle) {
    if (!mounted) return;

    if (niveles.isEmpty) {
      setState(() {
        niveles = detalle;
        isLoading = false;
      });
      return;
    }

    _aplicarEstadosEnCopia(_extraerEstadosPorId(detalle));
  }

  Map<int, String> _extraerEstadosPorId(List<dynamic> detalle) {
    final estadosPorId = <int, String>{};

    for (final nivel in detalle) {
      final zonas = nivel is Map ? nivel['zonas'] : null;
      if (zonas is! List) continue;

      for (final zona in zonas) {
        final espacios = zona is Map ? zona['espacios'] : null;
        if (espacios is! List) continue;

        for (final espacio in espacios) {
          if (espacio is! Map) continue;

          final id = _asInt(espacio['id']);
          if (id == null) continue;

          estadosPorId[id] = _normalizarEstado(
            espacio['estado_actual']?.toString() ?? 'libre',
          );
        }
      }
    }

    return estadosPorId;
  }

  List<dynamic> _normalizarDetalle(List<dynamic> detalle) {
    return detalle.whereType<Map>().map((nivel) {
      final nivelMap = Map<String, dynamic>.from(nivel);
      final zonas = nivelMap['zonas'];

      nivelMap['zonas'] = zonas is List
          ? zonas.whereType<Map>().map((zona) {
              final zonaMap = Map<String, dynamic>.from(zona);
              final espacios = zonaMap['espacios'];

              zonaMap['espacios'] = espacios is List
                  ? espacios.whereType<Map>().map((espacio) {
                      final espacioMap = Map<String, dynamic>.from(espacio);
                      espacioMap['codigo'] =
                          espacioMap['codigo']?.toString().trim() ?? '';
                      espacioMap['estado_actual'] = _normalizarEstado(
                        espacioMap['estado_actual']?.toString() ?? 'libre',
                      );
                      return espacioMap;
                    }).toList()
                  : <Map<String, dynamic>>[];

              return zonaMap;
            }).toList()
          : <Map<String, dynamic>>[];

      return nivelMap;
    }).toList();
  }

  String _normalizarEstado(String estado) {
    return estado.trim().toLowerCase().replaceAll('_', ' ');
  }

  Future<void> fetchDetalleMapa({bool silent = false}) async {
    try {
      final detalle = await _parkingService.getDetalleMapa(
        widget.estacionamientoId,
      );
      if (!mounted) return;

      final detalleNormalizado = _normalizarDetalle(detalle);
      if (silent && niveles.isNotEmpty) {
        _aplicarEstadosDesdeDetalle(detalleNormalizado);
        if (isLoading && mounted) {
          setState(() => isLoading = false);
        }
        return;
      }

      setState(() {
        niveles = detalleNormalizado;
        if (_selectedNivelIndex >= niveles.length) {
          _selectedNivelIndex = niveles.isEmpty ? 0 : niveles.length - 1;
        }
        isLoading = false;
      });
    } catch (error) {
      debugPrint('Error cargando mapa: $error');
      if (!mounted || silent) return;
      setState(() => isLoading = false);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: _pageBg,
        body: const Center(
          child: CircularProgressIndicator(color: _accentBlue),
        ),
      );
    }

    final nivelActual = niveles.isNotEmpty
        ? niveles[_selectedNivelIndex]
        : null;

    return Scaffold(
      backgroundColor: _pageBg,
      body: Column(
        children: [
          _buildHeroHeader(),
          _buildResumenPisos(),
          Expanded(
            child: nivelActual != null
                ? _buildDistribucionNivel(nivelActual)
                : Center(
                    child: Text(
                      context.tr('parking_map.no_data'),
                      style: TextStyle(color: _primaryText),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

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
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white70,
                  size: 18,
                ),
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
                        color: Colors.white60,
                        fontSize: 13,
                      ),
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
                  Text(
                    context.tr('parking_map.total_spaces'),
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

  Widget _buildResumenPisos() {
    return Container(
      width: double.infinity,
      color: _pageBg,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: _isDark ? const Color(0xFF263B5A) : const Color(0xFFDCE7F5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isDark ? 0.18 : 0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('parking_map.floor_summary'),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: _secondaryText,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(niveles.length, (i) {
                  final nivel = niveles[i];
                  final isSelected = i == _selectedNivelIndex;
                  final espacios = _getEspaciosNivel(nivel);

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _buildFloorChip(
                      index: i,
                      label:
                          nivel['nivel']?.toString() ??
                          '${context.tr('parking_map.level')} ${i + 1}',
                      spaces: espacios,
                      selected: isSelected,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloorChip({
    required int index,
    required String label,
    required int spaces,
    required bool selected,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _selectedNivelIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        constraints: const BoxConstraints(minWidth: 142),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: selected
              ? null
              : (_isDark ? const Color(0xFF0D1728) : Colors.white),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : (_isDark ? const Color(0xFF2A3F60) : const Color(0xFFDCE7F5)),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: _accentBlue.withValues(alpha: 0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? Colors.white.withValues(alpha: 0.18)
                    : _accentBlue.withValues(alpha: 0.12),
              ),
              alignment: Alignment.center,
              child: Text(
                'P${index + 1}',
                style: TextStyle(
                  color: selected ? Colors.white : _accentBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? Colors.white : _primaryText,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$spaces esp.',
                  style: TextStyle(
                    color: selected ? Colors.white70 : _secondaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistribucionNivel(dynamic nivel) {
    final zonas = nivel['zonas'] as List;

    return Column(
      children: [
        Container(
          color: _pageBg,
          padding: const EdgeInsets.fromLTRB(18, 2, 18, 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${context.tr('parking_map.distribution')} - ${nivel['nivel']?.toString().toUpperCase() ?? ''}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: _secondaryText,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _accentBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${zonas.length} div.',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: _accentBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double totalWidth = constraints.maxWidth - 28;
              final int colsBD = _getZonasPorFilaBD(nivel);
              const double gap = 10.0;
              final double cardWidth =
                  (totalWidth - gap * (colsBD - 1)) / colsBD;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 2, 14, 18),
                child: _buildZonasWrap(zonas, colsBD, cardWidth, gap),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildZonasWrap(List zonas, int colsBD, double cardWidth, double gap) {
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

  Widget _buildZonaCard(dynamic zona, int chipCols, double cardWidth) {
    final nombre = zona['nombre']?.toString() ?? context.tr('parking_map.zone');
    final espacios = zona['espacios'] as List;
    final letras = nombre.replaceAll(RegExp(r'[^A-Z]'), '');
    final zonaColor = _getZonaColor(nombre);

    final double pad = (cardWidth * 0.07).clamp(5.0, 10.0);
    final double avatarRadius = (cardWidth * 0.13).clamp(9.0, 13.0);
    final double labelFont = (cardWidth * 0.12).clamp(9.0, 13.0);
    final double subFont = (cardWidth * 0.09).clamp(8.0, 10.0);

    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
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
              color: _secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: pad * 0.6),
          _buildEspaciosMiniGrid(espacios, chipCols, cardWidth),
        ],
      ),
    );
  }

  Widget _buildEspaciosMiniGrid(List espacios, int cols, double cardWidth) {
    final List<Widget> rows = [];
    final double chipHeight = (cardWidth * 0.38).clamp(44.0, 58.0);

    for (int i = 0; i < espacios.length; i += cols) {
      final slice = espacios.sublist(
        i,
        (i + cols) > espacios.length ? espacios.length : i + cols,
      );
      rows.add(
        SizedBox(
          height: chipHeight,
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

  Widget _buildEspacioChip(dynamic espacio, double cardWidth) {
    final codigo = espacio['codigo']?.toString() ?? '??';
    final estado = _normalizarEstado(
      espacio['estado_actual']?.toString() ?? 'libre',
    );

    Color bgColor;
    Color borderColor;
    Color iconColor;
    Color textColor;

    if (estado.contains('libre')) {
      bgColor = const Color(0xFF10B981).withValues(alpha: 0.12);
      borderColor = const Color(0xFF10B981).withValues(alpha: 0.5);
      iconColor = const Color(0xFF10B981);
      textColor = const Color(0xFF047857);
    } else if (estado.contains('ocupado')) {
      bgColor = _red.withValues(alpha: 0.12);
      borderColor = _red.withValues(alpha: 0.5);
      iconColor = _red;
      textColor = _red;
    } else {
      bgColor = Colors.grey.shade200;
      borderColor = Colors.grey.shade400;
      iconColor = Colors.grey.shade500;
      textColor = Colors.grey.shade700;
    }

    final double iconSize = (cardWidth * 0.16).clamp(10.0, 16.0);
    final double codeFont = (cardWidth * 0.09).clamp(7.0, 10.0);
    final double vertPad = (cardWidth * 0.04).clamp(2.0, 5.0);

    return Container(
      key: ValueKey(_asInt(espacio['id']) ?? codigo),
      padding: EdgeInsets.symmetric(vertical: vertPad, horizontal: 1),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.directions_car_rounded,
                size: iconSize,
                color: iconColor,
              ),
              const SizedBox(height: 2),
              Text(
                codigo,
                maxLines: 1,
                textScaler: TextScaler.noScaling,
                style: TextStyle(
                  fontSize: codeFont,
                  fontWeight: FontWeight.w800,
                  height: 1,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
