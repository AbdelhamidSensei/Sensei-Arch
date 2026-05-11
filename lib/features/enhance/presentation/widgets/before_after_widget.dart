import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

class BeforeAfterWidget extends StatefulWidget {
  final String beforePath;
  final String afterPath;

  const BeforeAfterWidget({
    super.key,
    required this.beforePath,
    required this.afterPath,
  });

  @override
  State<BeforeAfterWidget> createState() => _BeforeAfterWidgetState();
}

class _BeforeAfterWidgetState extends State<BeforeAfterWidget> {
  double _sliderPosition = 0.5;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                _sliderPosition =
                    (details.localPosition.dx / constraints.maxWidth)
                        .clamp(0.0, 1.0);
              });
            },
            child: Stack(
              children: [
                // After image (full)
                Image.file(
                  File(widget.afterPath),
                  width: constraints.maxWidth,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    color: Colors.grey[200],
                    child: const Center(child: Text('After')),
                  ),
                ),
                // Before image (clipped)
                ClipRect(
                  clipper: _BeforeClipper(_sliderPosition),
                  child: Image.file(
                    File(widget.beforePath),
                    width: constraints.maxWidth,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 300,
                      color: Colors.grey[400],
                      child: const Center(child: Text('Before')),
                    ),
                  ),
                ),
                // Slider line
                Positioned(
                  left: constraints.maxWidth * _sliderPosition - 1.5,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 3,
                    color: Colors.white,
                    child: Center(
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.drag_handle, size: 18),
                      ),
                    ),
                  ),
                ),
                // Labels
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: _label('Before'),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: _label('After'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _label(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }
}

class _BeforeClipper extends CustomClipper<Rect> {
  final double position;
  _BeforeClipper(this.position);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * position, size.height);
  }

  @override
  bool shouldReclip(_BeforeClipper oldClipper) => position != oldClipper.position;
}
