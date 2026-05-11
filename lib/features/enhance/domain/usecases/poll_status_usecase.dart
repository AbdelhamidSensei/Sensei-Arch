import '../entities/enhancement_job.dart';
import '../repositories/enhancement_repository.dart';

class PollStatusUseCase {
  final EnhancementRepository _repository;

  PollStatusUseCase(this._repository);

  Stream<EnhancementJob> call(String predictionId, EnhancementMode mode) {
    return _repository.pollStatus(predictionId, mode);
  }
}
