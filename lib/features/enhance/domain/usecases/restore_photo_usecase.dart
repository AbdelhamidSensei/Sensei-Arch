import '../entities/enhancement_job.dart';
import '../repositories/enhancement_repository.dart';

class RestorePhotoUseCase {
  final EnhancementRepository _repository;

  RestorePhotoUseCase(this._repository);

  Future<EnhancementJob> call({required String localImagePath}) {
    return _repository.startEnhancement(
      localImagePath: localImagePath,
      mode: EnhancementMode.restoreFace,
    );
  }
}
