import 'package:sensei/core/result/resource.dart';
import 'package:sensei/features/packages/domain/model/package_model.dart';
import 'package:sensei/features/packages/domain/repository/packages_repository.dart';

class GetPackagesUseCase {
  GetPackagesUseCase({required PackagesRepository repository})
      : _repository = repository;

  final PackagesRepository _repository;

  Future<Resource<List<PackageModel>>> call(int statusId) {
    return _repository.getPackagesByStatus(statusId);
  }
}
