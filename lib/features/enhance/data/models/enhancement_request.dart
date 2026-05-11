import '../../domain/entities/enhancement_job.dart';

class EnhancementRequest {
  final String imageBase64;
  final EnhancementMode mode;
  final int scale;
  final double fidelity;

  const EnhancementRequest({
    required this.imageBase64,
    required this.mode,
    this.scale = 2,
    this.fidelity = 0.7,
  });

  Map<String, dynamic> toInputJson() {
    switch (mode) {
      case EnhancementMode.enhance:
        return {
          'image': imageBase64,
          'scale': scale,
        };
      case EnhancementMode.restoreFace:
        return {
          'image': imageBase64,
          'fidelity': fidelity,
          'scale': scale,
        };
      case EnhancementMode.colorize:
        return {
          'image': imageBase64,
        };
      case EnhancementMode.removeWatermark:
        return {
          'image': imageBase64,
        };
      case EnhancementMode.removeBackground:
        return {
          'image': imageBase64,
        };
    }
  }
}
