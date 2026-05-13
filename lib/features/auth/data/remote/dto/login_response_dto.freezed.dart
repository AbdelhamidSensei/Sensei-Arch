// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoginResponseDto _$LoginResponseDtoFromJson(Map<String, dynamic> json) {
  return _LoginResponseDto.fromJson(json);
}

/// @nodoc
mixin _$LoginResponseDto {
  // ── Success fields (present when login succeeds) ──
  String? get token =>
      throw _privateConstructorUsedError; // JWT token for authenticating future API calls
  String? get id =>
      throw _privateConstructorUsedError; // User ID — STRING from API, converted to int in mapper
  String? get name => throw _privateConstructorUsedError; // User's display name
  String? get email =>
      throw _privateConstructorUsedError; // User's email (often null for this API)
  String? get code =>
      throw _privateConstructorUsedError; // User's login code (same as LoginID)
  List<CompanyBranchesDto> get companiesBranches =>
      throw _privateConstructorUsedError; // Branch list
  // ── Error fields (present when login fails) ──
  int? get statusCode =>
      throw _privateConstructorUsedError; // Server's custom status code (not HTTP status)
  String? get msg => throw _privateConstructorUsedError;

  /// Serializes this LoginResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginResponseDtoCopyWith<LoginResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginResponseDtoCopyWith<$Res> {
  factory $LoginResponseDtoCopyWith(
    LoginResponseDto value,
    $Res Function(LoginResponseDto) then,
  ) = _$LoginResponseDtoCopyWithImpl<$Res, LoginResponseDto>;
  @useResult
  $Res call({
    String? token,
    String? id,
    String? name,
    String? email,
    String? code,
    List<CompanyBranchesDto> companiesBranches,
    int? statusCode,
    String? msg,
  });
}

/// @nodoc
class _$LoginResponseDtoCopyWithImpl<$Res, $Val extends LoginResponseDto>
    implements $LoginResponseDtoCopyWith<$Res> {
  _$LoginResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = freezed,
    Object? id = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? code = freezed,
    Object? companiesBranches = null,
    Object? statusCode = freezed,
    Object? msg = freezed,
  }) {
    return _then(
      _value.copyWith(
            token: freezed == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String?,
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            code: freezed == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String?,
            companiesBranches: null == companiesBranches
                ? _value.companiesBranches
                : companiesBranches // ignore: cast_nullable_to_non_nullable
                      as List<CompanyBranchesDto>,
            statusCode: freezed == statusCode
                ? _value.statusCode
                : statusCode // ignore: cast_nullable_to_non_nullable
                      as int?,
            msg: freezed == msg
                ? _value.msg
                : msg // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginResponseDtoImplCopyWith<$Res>
    implements $LoginResponseDtoCopyWith<$Res> {
  factory _$$LoginResponseDtoImplCopyWith(
    _$LoginResponseDtoImpl value,
    $Res Function(_$LoginResponseDtoImpl) then,
  ) = __$$LoginResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? token,
    String? id,
    String? name,
    String? email,
    String? code,
    List<CompanyBranchesDto> companiesBranches,
    int? statusCode,
    String? msg,
  });
}

/// @nodoc
class __$$LoginResponseDtoImplCopyWithImpl<$Res>
    extends _$LoginResponseDtoCopyWithImpl<$Res, _$LoginResponseDtoImpl>
    implements _$$LoginResponseDtoImplCopyWith<$Res> {
  __$$LoginResponseDtoImplCopyWithImpl(
    _$LoginResponseDtoImpl _value,
    $Res Function(_$LoginResponseDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = freezed,
    Object? id = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? code = freezed,
    Object? companiesBranches = null,
    Object? statusCode = freezed,
    Object? msg = freezed,
  }) {
    return _then(
      _$LoginResponseDtoImpl(
        token: freezed == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String?,
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String?,
        companiesBranches: null == companiesBranches
            ? _value._companiesBranches
            : companiesBranches // ignore: cast_nullable_to_non_nullable
                  as List<CompanyBranchesDto>,
        statusCode: freezed == statusCode
            ? _value.statusCode
            : statusCode // ignore: cast_nullable_to_non_nullable
                  as int?,
        msg: freezed == msg
            ? _value.msg
            : msg // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginResponseDtoImpl implements _LoginResponseDto {
  const _$LoginResponseDtoImpl({
    this.token,
    this.id,
    this.name,
    this.email,
    this.code,
    final List<CompanyBranchesDto> companiesBranches = const [],
    this.statusCode,
    this.msg,
  }) : _companiesBranches = companiesBranches;

  factory _$LoginResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginResponseDtoImplFromJson(json);

  // ── Success fields (present when login succeeds) ──
  @override
  final String? token;
  // JWT token for authenticating future API calls
  @override
  final String? id;
  // User ID — STRING from API, converted to int in mapper
  @override
  final String? name;
  // User's display name
  @override
  final String? email;
  // User's email (often null for this API)
  @override
  final String? code;
  // User's login code (same as LoginID)
  final List<CompanyBranchesDto> _companiesBranches;
  // User's login code (same as LoginID)
  @override
  @JsonKey()
  List<CompanyBranchesDto> get companiesBranches {
    if (_companiesBranches is EqualUnmodifiableListView)
      return _companiesBranches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_companiesBranches);
  }

  // Branch list
  // ── Error fields (present when login fails) ──
  @override
  final int? statusCode;
  // Server's custom status code (not HTTP status)
  @override
  final String? msg;

  @override
  String toString() {
    return 'LoginResponseDto(token: $token, id: $id, name: $name, email: $email, code: $code, companiesBranches: $companiesBranches, statusCode: $statusCode, msg: $msg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginResponseDtoImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.code, code) || other.code == code) &&
            const DeepCollectionEquality().equals(
              other._companiesBranches,
              _companiesBranches,
            ) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.msg, msg) || other.msg == msg));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    token,
    id,
    name,
    email,
    code,
    const DeepCollectionEquality().hash(_companiesBranches),
    statusCode,
    msg,
  );

  /// Create a copy of LoginResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginResponseDtoImplCopyWith<_$LoginResponseDtoImpl> get copyWith =>
      __$$LoginResponseDtoImplCopyWithImpl<_$LoginResponseDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginResponseDtoImplToJson(this);
  }
}

abstract class _LoginResponseDto implements LoginResponseDto {
  const factory _LoginResponseDto({
    final String? token,
    final String? id,
    final String? name,
    final String? email,
    final String? code,
    final List<CompanyBranchesDto> companiesBranches,
    final int? statusCode,
    final String? msg,
  }) = _$LoginResponseDtoImpl;

  factory _LoginResponseDto.fromJson(Map<String, dynamic> json) =
      _$LoginResponseDtoImpl.fromJson;

  // ── Success fields (present when login succeeds) ──
  @override
  String? get token; // JWT token for authenticating future API calls
  @override
  String? get id; // User ID — STRING from API, converted to int in mapper
  @override
  String? get name; // User's display name
  @override
  String? get email; // User's email (often null for this API)
  @override
  String? get code; // User's login code (same as LoginID)
  @override
  List<CompanyBranchesDto> get companiesBranches; // Branch list
  // ── Error fields (present when login fails) ──
  @override
  int? get statusCode; // Server's custom status code (not HTTP status)
  @override
  String? get msg;

  /// Create a copy of LoginResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginResponseDtoImplCopyWith<_$LoginResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CompanyBranchesDto _$CompanyBranchesDtoFromJson(Map<String, dynamic> json) {
  return _CompanyBranchesDto.fromJson(json);
}

/// @nodoc
mixin _$CompanyBranchesDto {
  int? get companyID => throw _privateConstructorUsedError;
  List<BranchItemDto> get branchesList => throw _privateConstructorUsedError;

  /// Serializes this CompanyBranchesDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompanyBranchesDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompanyBranchesDtoCopyWith<CompanyBranchesDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyBranchesDtoCopyWith<$Res> {
  factory $CompanyBranchesDtoCopyWith(
    CompanyBranchesDto value,
    $Res Function(CompanyBranchesDto) then,
  ) = _$CompanyBranchesDtoCopyWithImpl<$Res, CompanyBranchesDto>;
  @useResult
  $Res call({int? companyID, List<BranchItemDto> branchesList});
}

/// @nodoc
class _$CompanyBranchesDtoCopyWithImpl<$Res, $Val extends CompanyBranchesDto>
    implements $CompanyBranchesDtoCopyWith<$Res> {
  _$CompanyBranchesDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompanyBranchesDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? companyID = freezed, Object? branchesList = null}) {
    return _then(
      _value.copyWith(
            companyID: freezed == companyID
                ? _value.companyID
                : companyID // ignore: cast_nullable_to_non_nullable
                      as int?,
            branchesList: null == branchesList
                ? _value.branchesList
                : branchesList // ignore: cast_nullable_to_non_nullable
                      as List<BranchItemDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CompanyBranchesDtoImplCopyWith<$Res>
    implements $CompanyBranchesDtoCopyWith<$Res> {
  factory _$$CompanyBranchesDtoImplCopyWith(
    _$CompanyBranchesDtoImpl value,
    $Res Function(_$CompanyBranchesDtoImpl) then,
  ) = __$$CompanyBranchesDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? companyID, List<BranchItemDto> branchesList});
}

/// @nodoc
class __$$CompanyBranchesDtoImplCopyWithImpl<$Res>
    extends _$CompanyBranchesDtoCopyWithImpl<$Res, _$CompanyBranchesDtoImpl>
    implements _$$CompanyBranchesDtoImplCopyWith<$Res> {
  __$$CompanyBranchesDtoImplCopyWithImpl(
    _$CompanyBranchesDtoImpl _value,
    $Res Function(_$CompanyBranchesDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompanyBranchesDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? companyID = freezed, Object? branchesList = null}) {
    return _then(
      _$CompanyBranchesDtoImpl(
        companyID: freezed == companyID
            ? _value.companyID
            : companyID // ignore: cast_nullable_to_non_nullable
                  as int?,
        branchesList: null == branchesList
            ? _value._branchesList
            : branchesList // ignore: cast_nullable_to_non_nullable
                  as List<BranchItemDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanyBranchesDtoImpl implements _CompanyBranchesDto {
  const _$CompanyBranchesDtoImpl({
    this.companyID,
    final List<BranchItemDto> branchesList = const [],
  }) : _branchesList = branchesList;

  factory _$CompanyBranchesDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyBranchesDtoImplFromJson(json);

  @override
  final int? companyID;
  final List<BranchItemDto> _branchesList;
  @override
  @JsonKey()
  List<BranchItemDto> get branchesList {
    if (_branchesList is EqualUnmodifiableListView) return _branchesList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_branchesList);
  }

  @override
  String toString() {
    return 'CompanyBranchesDto(companyID: $companyID, branchesList: $branchesList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyBranchesDtoImpl &&
            (identical(other.companyID, companyID) ||
                other.companyID == companyID) &&
            const DeepCollectionEquality().equals(
              other._branchesList,
              _branchesList,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    companyID,
    const DeepCollectionEquality().hash(_branchesList),
  );

  /// Create a copy of CompanyBranchesDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyBranchesDtoImplCopyWith<_$CompanyBranchesDtoImpl> get copyWith =>
      __$$CompanyBranchesDtoImplCopyWithImpl<_$CompanyBranchesDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyBranchesDtoImplToJson(this);
  }
}

abstract class _CompanyBranchesDto implements CompanyBranchesDto {
  const factory _CompanyBranchesDto({
    final int? companyID,
    final List<BranchItemDto> branchesList,
  }) = _$CompanyBranchesDtoImpl;

  factory _CompanyBranchesDto.fromJson(Map<String, dynamic> json) =
      _$CompanyBranchesDtoImpl.fromJson;

  @override
  int? get companyID;
  @override
  List<BranchItemDto> get branchesList;

  /// Create a copy of CompanyBranchesDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompanyBranchesDtoImplCopyWith<_$CompanyBranchesDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BranchItemDto _$BranchItemDtoFromJson(Map<String, dynamic> json) {
  return _BranchItemDto.fromJson(json);
}

/// @nodoc
mixin _$BranchItemDto {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  /// Serializes this BranchItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BranchItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BranchItemDtoCopyWith<BranchItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BranchItemDtoCopyWith<$Res> {
  factory $BranchItemDtoCopyWith(
    BranchItemDto value,
    $Res Function(BranchItemDto) then,
  ) = _$BranchItemDtoCopyWithImpl<$Res, BranchItemDto>;
  @useResult
  $Res call({int? id, String? name});
}

/// @nodoc
class _$BranchItemDtoCopyWithImpl<$Res, $Val extends BranchItemDto>
    implements $BranchItemDtoCopyWith<$Res> {
  _$BranchItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BranchItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = freezed, Object? name = freezed}) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BranchItemDtoImplCopyWith<$Res>
    implements $BranchItemDtoCopyWith<$Res> {
  factory _$$BranchItemDtoImplCopyWith(
    _$BranchItemDtoImpl value,
    $Res Function(_$BranchItemDtoImpl) then,
  ) = __$$BranchItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String? name});
}

/// @nodoc
class __$$BranchItemDtoImplCopyWithImpl<$Res>
    extends _$BranchItemDtoCopyWithImpl<$Res, _$BranchItemDtoImpl>
    implements _$$BranchItemDtoImplCopyWith<$Res> {
  __$$BranchItemDtoImplCopyWithImpl(
    _$BranchItemDtoImpl _value,
    $Res Function(_$BranchItemDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BranchItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = freezed, Object? name = freezed}) {
    return _then(
      _$BranchItemDtoImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BranchItemDtoImpl implements _BranchItemDto {
  const _$BranchItemDtoImpl({this.id, this.name});

  factory _$BranchItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BranchItemDtoImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;

  @override
  String toString() {
    return 'BranchItemDto(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BranchItemDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of BranchItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BranchItemDtoImplCopyWith<_$BranchItemDtoImpl> get copyWith =>
      __$$BranchItemDtoImplCopyWithImpl<_$BranchItemDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BranchItemDtoImplToJson(this);
  }
}

abstract class _BranchItemDto implements BranchItemDto {
  const factory _BranchItemDto({final int? id, final String? name}) =
      _$BranchItemDtoImpl;

  factory _BranchItemDto.fromJson(Map<String, dynamic> json) =
      _$BranchItemDtoImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;

  /// Create a copy of BranchItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BranchItemDtoImplCopyWith<_$BranchItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
