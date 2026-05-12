import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../metro_data/presentation/providers/metro_provider.dart';
import '../../../metro_data/domain/entities/station.dart';
import '../../../../core/theme/app_colors.dart';

class SchematicMetroDiagram extends ConsumerStatefulWidget {
  const SchematicMetroDiagram({super.key});

  @override
  ConsumerState<SchematicMetroDiagram> createState() =>
      _SchematicMetroDiagramState();
}

class _SchematicMetroDiagramState extends ConsumerState<SchematicMetroDiagram>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawController;
  late Animation<double> _drawProgress;
  String? _hoveredStationId;

  @override
  void initState() {
    super.initState();
    _drawController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _drawProgress = CurvedAnimation(
      parent: _drawController,
      curve: Curves.easeInOutCubic,
    );
    _drawController.forward();
  }

  @override
  void dispose() {
    _drawController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stationsAsync = ref.watch(stationsProvider);

    return stationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (stations) {
        final locale = Localizations.localeOf(context);
        final isDark = Theme.of(context).brightness == Brightness.dark;

        final lineGroups = <String, List<Station>>{};
        for (final s in stations) {
          final primaryLine = s.lineIds.first;
          (lineGroups[primaryLine] ??= []).add(s);
        }

        final maxStations = lineGroups.values
            .fold<int>(0, (m, list) => list.length > m ? list.length : m);

        final canvasWidth = 100.0 + maxStations * 44.0;
        const canvasHeight = 560.0;

        return Container(
          color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8F9FB),
          child: InteractiveViewer(
            minScale: 0.3,
            maxScale: 5.0,
            constrained: false,
            boundaryMargin: const EdgeInsets.all(120),
            child: SizedBox(
              width: canvasWidth,
              height: canvasHeight,
              child: AnimatedBuilder(
                animation: _drawProgress,
                builder: (context, _) {
                  return CustomPaint(
                    size: Size(canvasWidth, canvasHeight),
                    painter: _SchematicPainter(
                      stations: stations,
                      lineGroups: lineGroups,
                      locale: locale,
                      isDark: isDark,
                      progress: _drawProgress.value,
                      hoveredId: _hoveredStationId,
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTapDown: (details) {
                        _handleTap(context, lineGroups, details.localPosition);
                      },
                      onLongPressStart: (details) {
                        _handleHover(lineGroups, details.localPosition);
                      },
                      onLongPressEnd: (_) {
                        setState(() => _hoveredStationId = null);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleTap(
    BuildContext context,
    Map<String, List<Station>> lineGroups,
    Offset position,
  ) {
    final station = _hitTest(lineGroups, position);
    if (station != null) {
      context.push('/station/${station.id}');
    }
  }

  void _handleHover(
    Map<String, List<Station>> lineGroups,
    Offset position,
  ) {
    final station = _hitTest(lineGroups, position);
    if (station != null) {
      setState(() => _hoveredStationId = station.id);
    }
  }

  Station? _hitTest(Map<String, List<Station>> lineGroups, Offset position) {
    const lines = ['L1', 'L2', 'L3'];
    for (int lineIdx = 0; lineIdx < lines.length; lineIdx++) {
      final lineStations = lineGroups[lines[lineIdx]] ?? [];
      final y = _SchematicPainter._startY + lineIdx * _SchematicPainter._lineSpacing;
      for (int i = 0; i < lineStations.length; i++) {
        final x = _SchematicPainter._startX + i * _SchematicPainter._stationSpacing;
        if ((position - Offset(x, y)).distance < 20) {
          return lineStations[i];
        }
      }
    }
    return null;
  }
}

class _SchematicPainter extends CustomPainter {
  final List<Station> stations;
  final Map<String, List<Station>> lineGroups;
  final Locale locale;
  final bool isDark;
  final double progress;
  final String? hoveredId;

  _SchematicPainter({
    required this.stations,
    required this.lineGroups,
    required this.locale,
    required this.isDark,
    required this.progress,
    this.hoveredId,
  });

  static const _lineSpacing = 170.0;
  static const _stationSpacing = 44.0;
  static const _startX = 70.0;
  static const _startY = 110.0;

  static const _lines = ['L1', 'L2', 'L3'];
  static const _colors = [
    AppColors.line1Red,
    AppColors.line2Yellow,
    AppColors.line3Green,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Background grid dots
    _drawBackgroundGrid(canvas, size);

    // Draw transfer connections first (behind)
    if (progress > 0.5) {
      _drawTransferConnections(canvas, (progress - 0.5) * 2);
    }

    for (int lineIdx = 0; lineIdx < _lines.length; lineIdx++) {
      final lineStations = lineGroups[_lines[lineIdx]] ?? [];
      if (lineStations.isEmpty) continue;

      final color = _colors[lineIdx];
      final y = _startY + lineIdx * _lineSpacing;
      final visibleCount = (lineStations.length * progress).ceil();

      // Track
      if (visibleCount >= 2) {
        final endX = _startX + (visibleCount - 1) * _stationSpacing;
        _drawTrack(canvas, _startX, endX, y, color);
      }

      // Line badge
      if (progress > 0.1) {
        _drawLineBadge(canvas, _lines[lineIdx], color, y);
      }

      // Stations
      for (int i = 0; i < visibleCount && i < lineStations.length; i++) {
        final x = _startX + i * _stationSpacing;
        final station = lineStations[i];
        final isHovered = station.id == hoveredId;

        _drawStation(canvas, Offset(x, y), color, station.isTransfer, isHovered);
        _drawStationName(canvas, Offset(x, y), station, color, lineIdx);
      }
    }
  }

  void _drawBackgroundGrid(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withAlpha(15);
    for (double x = 0; x < size.width; x += 20) {
      for (double y = 0; y < size.height; y += 20) {
        canvas.drawCircle(Offset(x, y), 0.8, dotPaint);
      }
    }
  }

  void _drawTrack(
      Canvas canvas, double startX, double endX, double y, Color color) {
    // Glow
    canvas.drawLine(
      Offset(startX, y),
      Offset(endX, y),
      Paint()
        ..color = color.withAlpha(30)
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round,
    );
    // Track background
    canvas.drawLine(
      Offset(startX, y),
      Offset(endX, y),
      Paint()
        ..color = color.withAlpha(50)
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );
    // Main line
    canvas.drawLine(
      Offset(startX, y),
      Offset(endX, y),
      Paint()
        ..color = color
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawLineBadge(Canvas canvas, String label, Color color, double y) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(8, y - 16, 42, 32),
      const Radius.circular(8),
    );
    // Shadow
    canvas.drawRRect(
      rect.shift(const Offset(0, 2)),
      Paint()
        ..color = color.withAlpha(40)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawRRect(rect, Paint()..color = color);

    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(8 + (42 - tp.width) / 2, y - tp.height / 2));
  }

  void _drawStation(
    Canvas canvas,
    Offset center,
    Color color,
    bool isTransfer,
    bool isHovered,
  ) {
    final scale = isHovered ? 1.3 : 1.0;

    if (isTransfer) {
      // Outer glow
      canvas.drawCircle(
        center,
        12 * scale,
        Paint()
          ..color = color.withAlpha(35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
      // White fill
      canvas.drawCircle(center, 10 * scale, Paint()..color = Colors.white);
      // Colored ring
      canvas.drawCircle(
        center,
        10 * scale,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5,
      );
      // Inner dot
      canvas.drawCircle(center, 3.5 * scale, Paint()..color = color);
    } else {
      // Shadow
      canvas.drawCircle(
        center.translate(0, 1),
        7 * scale,
        Paint()
          ..color = Colors.black.withAlpha(25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
      // Gradient fill effect
      canvas.drawCircle(center, 7 * scale, Paint()..color = color);
      // White border
      canvas.drawCircle(
        center,
        7 * scale,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
      // Specular highlight
      canvas.drawCircle(
        center.translate(-2 * scale, -2 * scale),
        2.5 * scale,
        Paint()..color = Colors.white.withAlpha(70),
      );
    }
  }

  void _drawStationName(
    Canvas canvas,
    Offset center,
    Station station,
    Color lineColor,
    int lineIdx,
  ) {
    final name = station.localizedName(locale.languageCode);
    final textColor = isDark ? Colors.white.withAlpha(200) : Colors.black87;

    final tp = TextPainter(
      text: TextSpan(
        text: name,
        style: TextStyle(
          color: station.isTransfer ? lineColor : textColor,
          fontSize: station.isTransfer ? 10.5 : 9,
          fontWeight: station.isTransfer ? FontWeight.w700 : FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
      textDirection:
          locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
    )..layout(maxWidth: 95);

    final labelAbove = lineIdx.isEven;

    canvas.save();
    if (labelAbove) {
      canvas.translate(center.dx + 2, center.dy - 20);
    } else {
      canvas.translate(center.dx + 2, center.dy + 16);
    }
    canvas.rotate(-0.5);
    tp.paint(canvas, Offset.zero);
    canvas.restore();
  }

  void _drawTransferConnections(Canvas canvas, double connectionProgress) {
    final transferStations = stations.where((s) => s.isTransfer);

    for (final ts in transferStations) {
      final positions = <Offset>[];
      for (final lineId in ts.lineIds) {
        final lineIdx = _lines.indexOf(lineId);
        if (lineIdx < 0) continue;
        final lineStations = lineGroups[lineId] ?? [];
        final stIdx = lineStations.indexWhere((s) => s.id == ts.id);
        if (stIdx >= 0) {
          positions.add(Offset(
            _startX + stIdx * _stationSpacing,
            _startY + lineIdx * _lineSpacing,
          ));
        }
      }

      if (positions.length >= 2) {
        for (int i = 0; i < positions.length - 1; i++) {
          _drawAnimatedDashedLine(
            canvas,
            positions[i],
            positions[i + 1],
            connectionProgress,
          );
        }
      }
    }
  }

  void _drawAnimatedDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    double animProgress,
  ) {
    final paint = Paint()
      ..color = (isDark ? Colors.white38 : Colors.grey[400]!)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final dist = sqrt(dx * dx + dy * dy);
    const dashLen = 6.0;
    const gapLen = 4.0;
    final totalLen = dashLen + gapLen;
    final steps = (dist / totalLen).floor();

    final unitX = dx / dist;
    final unitY = dy / dist;

    final visibleSteps = (steps * animProgress).ceil();
    for (int i = 0; i < visibleSteps; i++) {
      final sx = start.dx + unitX * i * totalLen;
      final sy = start.dy + unitY * i * totalLen;
      final ex = sx + unitX * dashLen;
      final ey = sy + unitY * dashLen;
      canvas.drawLine(Offset(sx, sy), Offset(ex, ey), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SchematicPainter old) =>
      old.progress != progress ||
      old.locale != locale ||
      old.isDark != isDark ||
      old.hoveredId != hoveredId;
}
