import '../entities/enhancement_job.dart';

abstract class EnhancementRepository {
  Future<EnhancementJob> startEnhancement({
    required String localImagePath,
    required EnhancementMode mode,
  });

  Stream<EnhancementJob> pollStatus(String predictionId, EnhancementMode mode);

  Future<String> downloadResultToCache(String url);
}
