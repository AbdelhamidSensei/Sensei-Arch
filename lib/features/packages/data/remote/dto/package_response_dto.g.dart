// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PackageResponseDtoImpl _$$PackageResponseDtoImplFromJson(
  Map<String, dynamic> json,
) => _$PackageResponseDtoImpl(
  data: json['data'] == null
      ? null
      : PackageDataDto.fromJson(json['data'] as Map<String, dynamic>),
  statusCode: (json['statusCode'] as num?)?.toInt(),
  msg: json['msg'] as String?,
);

Map<String, dynamic> _$$PackageResponseDtoImplToJson(
  _$PackageResponseDtoImpl instance,
) => <String, dynamic>{
  'data': instance.data,
  'statusCode': instance.statusCode,
  'msg': instance.msg,
};

_$PackageDataDtoImpl _$$PackageDataDtoImplFromJson(Map<String, dynamic> json) =>
    _$PackageDataDtoImpl(
      packages:
          (json['packages'] as List<dynamic>?)
              ?.map((e) => PackageItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PackageDataDtoImplToJson(
  _$PackageDataDtoImpl instance,
) => <String, dynamic>{'packages': instance.packages};

_$PackageItemDtoImpl _$$PackageItemDtoImplFromJson(Map<String, dynamic> json) =>
    _$PackageItemDtoImpl(
      id: (json['id'] as num?)?.toInt(),
      barcode: json['barcode'] as String?,
      companyID: (json['companyID'] as num?)?.toInt(),
      sourceBranchID: (json['sourceBranchID'] as num?)?.toInt(),
      destinationBranchID: (json['destinationBranchID'] as num?)?.toInt(),
      statusID: (json['statusID'] as num?)?.toInt(),
      sourceBranchName: json['sourceBranchName'] as String?,
      destinationBranchName: json['destinationBranchName'] as String?,
    );

Map<String, dynamic> _$$PackageItemDtoImplToJson(
  _$PackageItemDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'barcode': instance.barcode,
  'companyID': instance.companyID,
  'sourceBranchID': instance.sourceBranchID,
  'destinationBranchID': instance.destinationBranchID,
  'statusID': instance.statusID,
  'sourceBranchName': instance.sourceBranchName,
  'destinationBranchName': instance.destinationBranchName,
};

_$GenericResponseDtoImpl _$$GenericResponseDtoImplFromJson(
  Map<String, dynamic> json,
) => _$GenericResponseDtoImpl(
  statusCode: (json['statusCode'] as num?)?.toInt(),
  msg: json['msg'] as String?,
);

Map<String, dynamic> _$$GenericResponseDtoImplToJson(
  _$GenericResponseDtoImpl instance,
) => <String, dynamic>{'statusCode': instance.statusCode, 'msg': instance.msg};
