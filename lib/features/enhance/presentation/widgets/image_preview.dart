import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

class ImagePreview extends StatelessWidget {
  final String imagePath;

  const ImagePreview({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: Image.file(
        File(imagePath),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 300,
          color: Colors.grey[300],
          child: const Center(child: Icon(Icons.broken_image, size: 64)),
        ),
      ),
    );
  }
}
