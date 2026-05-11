import '../entities/enhancement_job.dart';
import '../repositories/enhancement_repository.dart';

class EnhancePhotoUseCase {
  final EnhancementRepository _repository;

  EnhancePhotoUseCase(this._repository);

  Future<EnhancementJob> call({
    required String localImagePath,
    required EnhancementMode mode,
  }) {
    return _repository.startEnhancement(
      localImagePath: localImagePath,
      mode: mode,
    );
  }
}
