import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A shipping-themed loading indicator — an animated delivery box
/// that bounces and moves, with motion lines for a sense of speed.
///
/// Use this everywhere instead of CircularProgressIndicator.
class ShippingLoading extends StatefulWidget {
  const ShippingLoading({super.key, this.size = 64, this.message});

  /// The width/height of the box area.
  final double size;

  /// Optional text displayed below the animation.
  final String? message;

  @override
  State<ShippingLoading> createState() => _ShippingLoadingState();
}

class _ShippingLoadingState extends State<ShippingLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size * 2.2,
          height: widget.size * 1.6,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: _ShippingBoxPainter(
                  progress: _controller.value,
                  isDark: isDark,
                  primaryColor: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
        ),
        if (widget.message != null) ...[
          const SizedBox(height: 12),
          Text(
            widget.message!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white60 : Colors.black45,
            ),
          ),
        ],
      ],
    );
  }
}

class _ShippingBoxPainter extends CustomPainter {
  final double progress;
  final bool isDark;
  final Color primaryColor;

  _ShippingBoxPainter({
    required this.progress,
    required this.isDark,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.5;

    // Box bounce: smooth up-down cycle
    final bounceT = math.sin(progress * 2 * math.pi);
    final bounceY = bounceT.abs() * -12;
    // Slight tilt when bouncing
    final tiltAngle = math.sin(progress * 2 * math.pi) * 0.06;
    // Subtle horizontal sway
    final swayX = math.sin(progress * 2 * math.pi + 0.5) * 3;

    // ── Motion lines (behind the box) ──
    _drawMotionLines(canvas, size, cx + swayX, cy + bounceY);

    // ── Shadow on ground ──
    final shadowWidth = 36.0 + bounceT.abs() * 8;
    final shadowOpacity = (0.15 - bounceT.abs() * 0.08).clamp(0.04, 0.15);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx + swayX, cy + 28),
        width: shadowWidth,
        height: 6,
      ),
      Paint()
        ..color = (isDark ? Colors.white : Colors.black)
            .withValues(alpha: shadowOpacity),
    );

    // ── Draw the box ──
    canvas.save();
    canvas.translate(cx + swayX, cy + bounceY);
    canvas.rotate(tiltAngle);
    _drawBox(canvas);
    canvas.restore();
  }

  void _drawMotionLines(Canvas canvas, Size size, double boxX, double boxY) {
    final paint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // 3 horizontal speed lines behind the box
    for (var i = 0; i < 3; i++) {
      // Each line has its own phase offset
      final phase = (progress * 2 + i * 0.33) % 1.0;
      final opacity = (1.0 - phase) * 0.4;
      final lineX = boxX - 30 - phase * 40;
      final lineY = boxY - 8 + i * 8.0;
      final lineLen = 12 + (1 - phase) * 14;

      paint.color = (isDark ? Colors.white : Colors.black54)
          .withValues(alpha: opacity.clamp(0.0, 0.4));
      canvas.drawLine(
        Offset(lineX, lineY),
        Offset(lineX - lineLen, lineY),
        paint,
      );
    }
  }

  void _drawBox(Canvas canvas) {
    const w = 40.0;
    const h = 32.0;

    // Box body
    final bodyRect = Rect.fromCenter(
      center: Offset.zero,
      width: w,
      height: h,
    );

    // Main box fill
    final boxPaint = Paint()..style = PaintingStyle.fill;
    final boxColor = isDark ? const Color(0xFF8B6914) : const Color(0xFFD4A245);
    boxPaint.color = boxColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, const Radius.circular(3)),
      boxPaint,
    );

    // Darker bottom half for 3D effect
    final bottomRect = Rect.fromLTRB(
      bodyRect.left,
      0,
      bodyRect.right,
      bodyRect.bottom,
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        bottomRect,
        bottomLeft: const Radius.circular(3),
        bottomRight: const Radius.circular(3),
      ),
      Paint()
        ..color = (isDark ? const Color(0xFF6B4F0E) : const Color(0xFFBB8C30)),
    );

    // Box outline
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, const Radius.circular(3)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = isDark ? const Color(0xFF5A3E0A) : const Color(0xFF9A7520),
    );

    // Tape / center stripe (vertical)
    canvas.drawLine(
      Offset(0, bodyRect.top),
      Offset(0, bodyRect.bottom),
      Paint()
        ..color = isDark ? const Color(0xFFAA8830) : const Color(0xFFE8C870)
        ..strokeWidth = 6,
    );

    // Tape cross (horizontal)
    canvas.drawLine(
      Offset(bodyRect.left + 6, -2),
      Offset(bodyRect.right - 6, -2),
      Paint()
        ..color = isDark ? const Color(0xFFAA8830) : const Color(0xFFE8C870)
        ..strokeWidth = 4,
    );

    // Flap lines (top of box)
    final flapPaint = Paint()
      ..color = isDark ? const Color(0xFF5A3E0A) : const Color(0xFF9A7520)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(bodyRect.left, bodyRect.top + 2),
      Offset(bodyRect.right, bodyRect.top + 2),
      flapPaint,
    );

    // Small shipping label
    final labelRect = Rect.fromCenter(
      center: Offset(w * 0.2, h * 0.15),
      width: 10,
      height: 8,
    );
    canvas.drawRect(
      labelRect,
      Paint()..color = Colors.white.withValues(alpha: 0.8),
    );
    // Tiny lines on label
    final tinyPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.6)
      ..strokeWidth = 0.8;
    canvas.drawLine(
      Offset(labelRect.left + 2, labelRect.top + 2.5),
      Offset(labelRect.right - 2, labelRect.top + 2.5),
      tinyPaint,
    );
    canvas.drawLine(
      Offset(labelRect.left + 2, labelRect.top + 5),
      Offset(labelRect.right - 2, labelRect.top + 5),
      tinyPaint,
    );
  }

  @override
  bool shouldRepaint(_ShippingBoxPainter old) => old.progress != progress;
}
