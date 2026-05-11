class EnhancementResponse {
  final String id;
  final String status;
  final String? outputUrl;
  final String? error;

  const EnhancementResponse({
    required this.id,
    required this.status,
    this.outputUrl,
    this.error,
  });

  factory EnhancementResponse.fromJson(Map<String, dynamic> json) {
    String? output;
    final rawOutput = json['output'];
    if (rawOutput is String) {
      output = rawOutput;
    } else if (rawOutput is List && rawOutput.isNotEmpty) {
      output = rawOutput.first as String?;
    }

    return EnhancementResponse(
      id: json['id'] as String,
      status: json['status'] as String,
      outputUrl: output,
      error: json['error'] as String?,
    );
  }
}
