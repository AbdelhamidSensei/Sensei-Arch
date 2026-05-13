import 'package:sensei/core/result/resource.dart';
import 'package:sensei/features/packages/domain/repository/packages_repository.dart';

class AddSampleUseCase {
  AddSampleUseCase({required PackagesRepository repository})
      : _repository = repository;

  final PackagesRepository _repository;

  Future<Resource<void>> call(int packageId, String barcode) {
    return _repository.addSample(packageId, barcode);
  }
}
