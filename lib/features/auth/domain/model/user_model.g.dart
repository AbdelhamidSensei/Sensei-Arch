// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      token: json['token'] as String,
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      companiesBranches:
          (json['companiesBranches'] as List<dynamic>?)
              ?.map((e) => CompanyBranches.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'code': instance.code,
      'companiesBranches': instance.companiesBranches,
    };

_$CompanyBranchesImpl _$$CompanyBranchesImplFromJson(
  Map<String, dynamic> json,
) => _$CompanyBranchesImpl(
  companyID: (json['companyID'] as num).toInt(),
  branchesList:
      (json['branchesList'] as List<dynamic>?)
          ?.map((e) => BranchItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CompanyBranchesImplToJson(
  _$CompanyBranchesImpl instance,
) => <String, dynamic>{
  'companyID': instance.companyID,
  'branchesList': instance.branchesList,
};

_$BranchItemImpl _$$BranchItemImplFromJson(Map<String, dynamic> json) =>
    _$BranchItemImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$$BranchItemImplToJson(_$BranchItemImpl instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
