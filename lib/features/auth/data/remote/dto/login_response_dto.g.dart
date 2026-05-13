// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseDtoImpl _$$LoginResponseDtoImplFromJson(
  Map<String, dynamic> json,
) => _$LoginResponseDtoImpl(
  token: json['token'] as String?,
  id: json['id'] as String?,
  name: json['name'] as String?,
  email: json['email'] as String?,
  code: json['code'] as String?,
  companiesBranches:
      (json['companiesBranches'] as List<dynamic>?)
          ?.map((e) => CompanyBranchesDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  statusCode: (json['statusCode'] as num?)?.toInt(),
  msg: json['msg'] as String?,
);

Map<String, dynamic> _$$LoginResponseDtoImplToJson(
  _$LoginResponseDtoImpl instance,
) => <String, dynamic>{
  'token': instance.token,
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'code': instance.code,
  'companiesBranches': instance.companiesBranches,
  'statusCode': instance.statusCode,
  'msg': instance.msg,
};

_$CompanyBranchesDtoImpl _$$CompanyBranchesDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CompanyBranchesDtoImpl(
  companyID: (json['companyID'] as num?)?.toInt(),
  branchesList:
      (json['branchesList'] as List<dynamic>?)
          ?.map((e) => BranchItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CompanyBranchesDtoImplToJson(
  _$CompanyBranchesDtoImpl instance,
) => <String, dynamic>{
  'companyID': instance.companyID,
  'branchesList': instance.branchesList,
};

_$BranchItemDtoImpl _$$BranchItemDtoImplFromJson(Map<String, dynamic> json) =>
    _$BranchItemDtoImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$BranchItemDtoImplToJson(_$BranchItemDtoImpl instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
