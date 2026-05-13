import 'package:freezed_annotation/freezed_annotation.dart';

part 'package_response_dto.freezed.dart';
part 'package_response_dto.g.dart';

@freezed
class PackageResponseDto with _$PackageResponseDto {
  const factory PackageResponseDto({
    PackageDataDto? data,
    int? statusCode,
    String? msg,
  }) = _PackageResponseDto;

  factory PackageResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PackageResponseDtoFromJson(json);
}

@freezed
class PackageDataDto with _$PackageDataDto {
  const factory PackageDataDto({
    @Default([]) List<PackageItemDto> packages,
  }) = _PackageDataDto;

  factory PackageDataDto.fromJson(Map<String, dynamic> json) =>
      _$PackageDataDtoFromJson(json);
}

@freezed
class PackageItemDto with _$PackageItemDto {
  const factory PackageItemDto({
    int? id,
    String? barcode,
    int? companyID,
    int? sourceBranchID,
    int? destinationBranchID,
    int? statusID,
    String? sourceBranchName,
    String? destinationBranchName,
  }) = _PackageItemDto;

  factory PackageItemDto.fromJson(Map<String, dynamic> json) =>
      _$PackageItemDtoFromJson(json);
}

@freezed
class GenericResponseDto with _$GenericResponseDto {
  const factory GenericResponseDto({
    int? statusCode,
    String? msg,
  }) = _GenericResponseDto;

  factory GenericResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GenericResponseDtoFromJson(json);
}
