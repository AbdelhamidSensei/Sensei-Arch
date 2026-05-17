import 'package:sensei/core/result/resource.dart';
import 'package:sensei/features/packages/domain/model/package_model.dart';

abstract class PackagesRepository {
  Future<Resource<List<PackageModel>>> getPackagesByStatus({
    required int statusId,
    required int companyId,
    required int branchId,
  });
  Future<Resource<void>> addSample(int packageId, String barcode);
  Future<Resource<void>> updatePackageStatus(int packageId, int statusId);
  Future<Resource<void>> sendPackage(int packageId);
}
