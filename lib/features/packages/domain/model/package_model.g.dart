// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PackageModelImpl _$$PackageModelImplFromJson(Map<String, dynamic> json) =>
    _$PackageModelImpl(
      id: (json['id'] as num).toInt(),
      barcode: json['barcode'] as String? ?? '',
      companyID: (json['companyID'] as num).toInt(),
      sourceBranchID: (json['sourceBranchID'] as num).toInt(),
      destinationBranchID: (json['destinationBranchID'] as num).toInt(),
      statusID: (json['statusID'] as num).toInt(),
      sourceBranchName: json['sourceBranchName'] as String? ?? '',
      destinationBranchName: json['destinationBranchName'] as String? ?? '',
    );

Map<String, dynamic> _$$PackageModelImplToJson(_$PackageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'barcode': instance.barcode,
      'companyID': instance.companyID,
      'sourceBranchID': instance.sourceBranchID,
      'destinationBranchID': instance.destinationBranchID,
      'statusID': instance.statusID,
      'sourceBranchName': instance.sourceBranchName,
      'destinationBranchName': instance.destinationBranchName,
    };
