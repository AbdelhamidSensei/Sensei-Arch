import 'package:sensei/features/packages/data/remote/dto/package_response_dto.dart';
import 'package:sensei/features/packages/domain/model/package_model.dart';

extension PackageItemDtoMapper on PackageItemDto {
  PackageModel toDomain() {
    return PackageModel(
      id: id ?? 0,
      barcode: barcode ?? '',
      companyID: companyID ?? 0,
      sourceBranchID: sourceBranchID ?? 0,
      destinationBranchID: destinationBranchID ?? 0,
      statusID: statusID ?? 0,
      sourceBranchName: sourceBranchName ?? '',
      destinationBranchName: destinationBranchName ?? '',
    );
  }
}
