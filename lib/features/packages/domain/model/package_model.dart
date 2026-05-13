import 'package:freezed_annotation/freezed_annotation.dart';

part 'package_model.freezed.dart';
part 'package_model.g.dart';

@freezed
class PackageModel with _$PackageModel {
  const factory PackageModel({
    required int id,
    @Default('') String barcode,
    required int companyID,
    required int sourceBranchID,
    required int destinationBranchID,
    required int statusID,
    @Default('') String sourceBranchName,
    @Default('') String destinationBranchName,
  }) = _PackageModel;

  factory PackageModel.fromJson(Map<String, dynamic> json) =>
      _$PackageModelFromJson(json);
}
