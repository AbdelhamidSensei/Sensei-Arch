import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../../metro_data/presentation/providers/metro_provider.dart';
import '../../../metro_data/domain/entities/station.dart';
import '../../../trip_planner/presentation/providers/trip_planner_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/line_chip.dart';
import 'package:metrogo/l10n/app_localizations.dart';

class OsmMetroMap extends ConsumerStatefulWidget {
  const OsmMetroMap({super.key});

  @override
  ConsumerState<OsmMetroMap> createState() => _OsmMetroMapState();
}

class _OsmMetroMapState extends ConsumerState<OsmMetroMap>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  LatLng? _userLocation;
  double _currentZoom = 11;
  Timer? _zoomDebounce;

  // Animation controllers
  late AnimationController _controlsFadeController;
  late Animation<double> _controlsFade;
  late AnimationController _locatePulseController;
  late Animation<double> _locatePulse;

  @override
  void initState() {
    super.initState();
    _controlsFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1.0,
    );
    _controlsFade = CurvedAnimation(
      parent: _controlsFadeController,
      curve: Curves.easeOut,
    );

    _locatePulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _locatePulse = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _locatePulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _zoomDebounce?.cancel();
    _controlsFadeController.dispose();
    _locatePulseController.dispose();
    super.dispose();
  }

  void _onZoomChanged(double zoom) {
    // Debounce zoom updates to prevent excessive rebuilds (fixes crash/jank)
    _zoomDebounce?.cancel();
    _zoomDebounce = Timer(const Duration(milliseconds: 150), () {
      if (mounted && (_currentZoom - zoom).abs() > 0.3) {
        setState(() => _currentZoom = zoom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stationsAsync = ref.watch(stationsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context);

    return stationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (stations) {
        return Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(30.0444, 31.2357),
                initialZoom: 11,
                minZoom: 9,
                maxZoom: 18,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
                onPositionChanged: (pos, hasGesture) {
                  _onZoomChanged(pos.zoom);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: isDark
                      ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                      : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.abdelhamidsensei.metrogo',
                ),
                // Polylines
                ..._buildPolylines(stations),
                // Station markers
                MarkerLayer(
                  markers: _buildMarkers(stations, context, locale),
                ),
                // User location
                if (_userLocation != null)
                  MarkerLayer(markers: [_buildUserLocationMarker()]),
              ],
            ),
            // Controls overlay with fade animation
            FadeTransition(
              opacity: _controlsFade,
              child: _buildOverlayControls(context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOverlayControls(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        // Legend - top left
        Positioned(
          top: MediaQuery.of(context).padding.top + 100,
          left: 12,
          child: _AnimatedLegend(isDark: isDark),
        ),
        // Zoom + locate - bottom right
        Positioned(
          bottom: 24,
          right: 16,
          child: Column(
            children: [
              _AnimatedMapButton(
                icon: Icons.add_rounded,
                onPressed: () => _animateZoom(_currentZoom + 1),
                isDark: isDark,
                delay: 0,
              ),
              const SizedBox(height: 8),
              _AnimatedMapButton(
                icon: Icons.remove_rounded,
                onPressed: () => _animateZoom(_currentZoom - 1),
                isDark: isDark,
                delay: 50,
              ),
              const SizedBox(height: 16),
              _AnimatedMapButton(
                icon: Icons.my_location_rounded,
                onPressed: _locateUser,
                isDark: isDark,
                accent: true,
                delay: 100,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _animateZoom(double target) {
    target = target.clamp(9.0, 18.0);
    _mapController.move(_mapController.camera.center, target);
  }

  List<PolylineLayer> _buildPolylines(List<Station> stations) {
    final lineStations = <String, List<Station>>{};
    for (final s in stations) {
      for (final lineId in s.lineIds) {
        (lineStations[lineId] ??= []).add(s);
      }
    }

    return lineStations.entries.map((entry) {
      final color = AppColors.lineColor(entry.key);
      final points = entry.value.map((s) => LatLng(s.lat, s.lng)).toList();
      final thick = _currentZoom >= 13;
      return PolylineLayer(
        polylines: [
          // Glow layer
          Polyline(
            points: points,
            color: color.withValues(alpha: 0.2),
            strokeWidth: thick ? 14 : 10,
          ),
          // Main line
          Polyline(
            points: points,
            color: color,
            strokeWidth: thick ? 5 : 3.5,
            borderColor: color.withValues(alpha: 0.5),
            borderStrokeWidth: 1,
          ),
        ],
      );
    }).toList();
  }

  List<Marker> _buildMarkers(
    List<Station> stations,
    BuildContext context,
    Locale locale,
  ) {
    final showLabels = _currentZoom >= 12.5;
    final showAllLabels = _currentZoom >= 14;

    return stations.map((station) {
      final color = AppColors.lineColor(station.lineIds.first);
      final shouldShowLabel =
          showAllLabels || (showLabels && station.isTransfer);

      final markerSize = _currentZoom >= 14
          ? (station.isTransfer ? 26.0 : 18.0)
          : (station.isTransfer ? 20.0 : 12.0);

      final labelText = station.localizedName(locale.languageCode);
      final widgetWidth = shouldShowLabel ? 140.0 : markerSize + 6;
      final widgetHeight = shouldShowLabel ? 58.0 : markerSize + 6;

      return Marker(
        point: LatLng(station.lat, station.lng),
        width: widgetWidth,
        height: widgetHeight,
        alignment: shouldShowLabel
            ? const Alignment(0, 0.85)
            : Alignment.center,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _showStationSheet(context, station),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (shouldShowLabel)
                _StationLabel(
                  text: labelText,
                  color: color,
                  isTransfer: station.isTransfer,
                ),
              if (shouldShowLabel) const SizedBox(height: 2),
              _StationDot(
                color: color,
                size: markerSize,
                isTransfer: station.isTransfer,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Marker _buildUserLocationMarker() {
    return Marker(
      point: _userLocation!,
      width: 36,
      height: 36,
      child: AnimatedBuilder(
        animation: _locatePulse,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withValues(alpha: 0.15 * _locatePulse.value),
            ),
            child: Center(
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 2 * _locatePulse.value,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showStationSheet(BuildContext context, Station station) {
    final l10n = AppL10n.of(context);
    final locale = Localizations.localeOf(context);
    final primaryColor = AppColors.lineColor(station.lineIds.first);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      transitionAnimationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 350),
      ),
      builder: (ctx) => _StationBottomSheet(
        station: station,
        l10n: l10n,
        locale: locale,
        primaryColor: primaryColor,
        isDark: isDark,
        onFromHere: () {
          Navigator.pop(ctx);
          ref.read(tripPlannerProvider.notifier).setFromStation(station);
          context.go('/plan');
        },
        onToHere: () {
          Navigator.pop(ctx);
          ref.read(tripPlannerProvider.notifier).setToStation(station);
          context.go('/plan');
        },
        onDetails: () {
          Navigator.pop(ctx);
          context.push('/station/${station.id}');
        },
      ),
    );
  }

  Future<void> _locateUser() async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) return;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_userLocation!, 14);
    } catch (_) {}
  }
}

// ─── Station label widget ───────────────────────────────────────────────

class _StationLabel extends StatelessWidget {
  final String text;
  final Color color;
  final bool isTransfer;

  const _StationLabel({
    required this.text,
    required this.color,
    required this.isTransfer,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[900]!.withValues(alpha: 0.95)
            : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isTransfer ? color.withValues(alpha: 0.5) : Colors.grey.withValues(alpha: 0.2),
          width: isTransfer ? 1.5 : 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isTransfer ? 10.5 : 9,
          fontWeight: isTransfer ? FontWeight.w700 : FontWeight.w500,
          color: isTransfer ? color : (isDark ? Colors.white70 : Colors.black87),
          letterSpacing: 0.1,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ─── Station dot widget ─────────────────────────────────────────────────

class _StationDot extends StatelessWidget {
  final Color color;
  final double size;
  final bool isTransfer;

  const _StationDot({
    required this.color,
    required this.size,
    required this.isTransfer,
  });

  @override
  Widget build(BuildContext context) {
    if (isTransfer) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 3.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.45),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: size * 0.32,
            height: size * 0.32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0.8)],
        ),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }
}

// ─── Animated map control button ────────────────────────────────────────

class _AnimatedMapButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDark;
  final bool accent;
  final int delay;

  const _AnimatedMapButton({
    required this.icon,
    required this.onPressed,
    required this.isDark,
    this.accent = false,
    this.delay = 0,
  });

  @override
  State<_AnimatedMapButton> createState() => _AnimatedMapButtonState();
}

class _AnimatedMapButtonState extends State<_AnimatedMapButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scale.value,
          child: Opacity(
            opacity: _opacity.value,
            child: child,
          ),
        );
      },
      child: Material(
        color: widget.accent
            ? Theme.of(context).colorScheme.primary
            : (widget.isDark ? Colors.grey[850] : Colors.white),
        elevation: 4,
        shadowColor: Colors.black38,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 46,
            height: 46,
            child: Icon(
              widget.icon,
              size: 22,
              color: widget.accent
                  ? Colors.white
                  : (widget.isDark ? Colors.white : Colors.grey[700]),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Animated legend ────────────────────────────────────────────────────

class _AnimatedLegend extends StatefulWidget {
  final bool isDark;
  const _AnimatedLegend({required this.isDark});

  @override
  State<_AnimatedLegend> createState() => _AnimatedLegendState();
}

class _AnimatedLegendState extends State<_AnimatedLegend>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;
  late Animation<double> _fade;
  bool _expanded = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slide = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(
              horizontal: _expanded ? 12 : 8,
              vertical: _expanded ? 10 : 8,
            ),
            decoration: BoxDecoration(
              color: (widget.isDark ? Colors.grey[900] : Colors.white)!
                  .withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _expanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _legendRow(AppColors.line1Red, 'Line 1', 'الخط الأول'),
                      const SizedBox(height: 6),
                      _legendRow(AppColors.line2Yellow, 'Line 2', 'الخط الثاني'),
                      const SizedBox(height: 6),
                      _legendRow(AppColors.line3Green, 'Line 3', 'الخط الثالث'),
                    ],
                  )
                : const Icon(Icons.layers_rounded, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _legendRow(Color color, String label, String labelAr) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 5,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 3),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          isAr ? labelAr : label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ─── Bottom sheet ───────────────────────────────────────────────────────

class _StationBottomSheet extends StatefulWidget {
  final Station station;
  final AppL10n l10n;
  final Locale locale;
  final Color primaryColor;
  final bool isDark;
  final VoidCallback onFromHere;
  final VoidCallback onToHere;
  final VoidCallback onDetails;

  const _StationBottomSheet({
    required this.station,
    required this.l10n,
    required this.locale,
    required this.primaryColor,
    required this.isDark,
    required this.onFromHere,
    required this.onToHere,
    required this.onDetails,
  });

  @override
  State<_StationBottomSheet> createState() => _StationBottomSheetState();
}

class _StationBottomSheetState extends State<_StationBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _slideUp;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideUp = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final station = widget.station;
    final lang = widget.locale.languageCode;

    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideUp.value),
          child: Opacity(opacity: _fadeIn.value, child: child),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.isDark ? const Color(0xFF1A1A2E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Color accent strip
            Container(
              margin: const EdgeInsets.only(top: 16, left: 20, right: 20),
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: station.lineIds
                      .map((id) => AppColors.lineColor(id))
                      .toList(),
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Station name
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Colored icon
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: widget.primaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          station.isTransfer
                              ? Icons.swap_horiz_rounded
                              : Icons.train_rounded,
                          color: widget.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              station.localizedName(lang),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              station.localizedName(
                                lang == 'ar' ? 'en' : 'ar',
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: widget.isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[500],
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Line chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: station.lineIds.map((id) {
                      final lineName = switch (id) {
                        'L1' => 'Line 1',
                        'L2' => 'Line 2',
                        'L3' => 'Line 3',
                        _ => id,
                      };
                      return LineChip(lineId: id, label: lineName);
                    }).toList(),
                  ),
                  if (station.isTransfer) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.swap_horiz_rounded,
                              size: 14, color: Colors.amber[700]),
                          const SizedBox(width: 4),
                          Text(
                            'Transfer Station',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: _SheetActionButton(
                          icon: Icons.play_arrow_rounded,
                          label: widget.l10n.goFromHere,
                          color: widget.primaryColor,
                          filled: true,
                          onTap: widget.onFromHere,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SheetActionButton(
                          icon: Icons.flag_rounded,
                          label: widget.l10n.goToHere,
                          color: widget.primaryColor,
                          filled: false,
                          onTap: widget.onToHere,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Details button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: widget.onDetails,
                      icon: Icon(Icons.info_outline_rounded,
                          size: 18, color: widget.primaryColor),
                      label: Text(
                        widget.l10n.stationDetails,
                        style: TextStyle(color: widget.primaryColor),
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
}

class _SheetActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  const _SheetActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? color : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: filled
              ? null
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color, width: 1.5),
                ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: filled ? Colors.white : color),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: filled ? Colors.white : color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
