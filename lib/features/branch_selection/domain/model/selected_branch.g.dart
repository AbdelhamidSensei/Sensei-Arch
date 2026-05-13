// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SelectedBranchImpl _$$SelectedBranchImplFromJson(Map<String, dynamic> json) =>
    _$SelectedBranchImpl(
      companyID: (json['companyID'] as num).toInt(),
      branchID: (json['branchID'] as num).toInt(),
      branchName: json['branchName'] as String,
    );

Map<String, dynamic> _$$SelectedBranchImplToJson(
  _$SelectedBranchImpl instance,
) => <String, dynamic>{
  'companyID': instance.companyID,
  'branchID': instance.branchID,
  'branchName': instance.branchName,
};
