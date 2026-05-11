enum EnhancementMode { enhance, restoreFace, colorize, removeWatermark, removeBackground }

class EnhancementJob {
  final String id;
  final String status;
  final String? outputUrl;
  final String? error;
  final EnhancementMode mode;

  const EnhancementJob({
    required this.id,
    required this.status,
    this.outputUrl,
    this.error,
    required this.mode,
  });

  bool get isTerminal =>
      status == 'succeeded' || status == 'failed' || status == 'canceled';
  bool get isSucceeded => status == 'succeeded';
  bool get isFailed => status == 'failed';

  EnhancementJob copyWith({
    String? id,
    String? status,
    String? outputUrl,
    String? error,
    EnhancementMode? mode,
  }) {
    return EnhancementJob(
      id: id ?? this.id,
      status: status ?? this.status,
      outputUrl: outputUrl ?? this.outputUrl,
      error: error ?? this.error,
      mode: mode ?? this.mode,
    );
  }
}
