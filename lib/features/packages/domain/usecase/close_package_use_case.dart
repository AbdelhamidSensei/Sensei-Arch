import 'package:sensei/core/result/resource.dart';
import 'package:sensei/features/packages/domain/repository/packages_repository.dart';

class ClosePackageUseCase {
  ClosePackageUseCase({required PackagesRepository repository})
      : _repository = repository;

  final PackagesRepository _repository;

  Future<Resource<void>> call(int packageId) {
    return _repository.updatePackageStatus(packageId, 3);
  }
}
