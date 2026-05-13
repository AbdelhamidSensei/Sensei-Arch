// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PackageResponseDto _$PackageResponseDtoFromJson(Map<String, dynamic> json) {
  return _PackageResponseDto.fromJson(json);
}

/// @nodoc
mixin _$PackageResponseDto {
  PackageDataDto? get data => throw _privateConstructorUsedError;
  int? get statusCode => throw _privateConstructorUsedError;
  String? get msg => throw _privateConstructorUsedError;

  /// Serializes this PackageResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PackageResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PackageResponseDtoCopyWith<PackageResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackageResponseDtoCopyWith<$Res> {
  factory $PackageResponseDtoCopyWith(
    PackageResponseDto value,
    $Res Function(PackageResponseDto) then,
  ) = _$PackageResponseDtoCopyWithImpl<$Res, PackageResponseDto>;
  @useResult
  $Res call({PackageDataDto? data, int? statusCode, String? msg});

  $PackageDataDtoCopyWith<$Res>? get data;
}

/// @nodoc
class _$PackageResponseDtoCopyWithImpl<$Res, $Val extends PackageResponseDto>
    implements $PackageResponseDtoCopyWith<$Res> {
  _$PackageResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PackageResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? statusCode = freezed,
    Object? msg = freezed,
  }) {
    return _then(
      _value.copyWith(
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as PackageDataDto?,
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

  /// Create a copy of PackageResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PackageDataDtoCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $PackageDataDtoCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PackageResponseDtoImplCopyWith<$Res>
    implements $PackageResponseDtoCopyWith<$Res> {
  factory _$$PackageResponseDtoImplCopyWith(
    _$PackageResponseDtoImpl value,
    $Res Function(_$PackageResponseDtoImpl) then,
  ) = __$$PackageResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PackageDataDto? data, int? statusCode, String? msg});

  @override
  $PackageDataDtoCopyWith<$Res>? get data;
}

/// @nodoc
class __$$PackageResponseDtoImplCopyWithImpl<$Res>
    extends _$PackageResponseDtoCopyWithImpl<$Res, _$PackageResponseDtoImpl>
    implements _$$PackageResponseDtoImplCopyWith<$Res> {
  __$$PackageResponseDtoImplCopyWithImpl(
    _$PackageResponseDtoImpl _value,
    $Res Function(_$PackageResponseDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PackageResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? statusCode = freezed,
    Object? msg = freezed,
  }) {
    return _then(
      _$PackageResponseDtoImpl(
        data: freezed == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as PackageDataDto?,
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
class _$PackageResponseDtoImpl implements _PackageResponseDto {
  const _$PackageResponseDtoImpl({this.data, this.statusCode, this.msg});

  factory _$PackageResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackageResponseDtoImplFromJson(json);

  @override
  final PackageDataDto? data;
  @override
  final int? statusCode;
  @override
  final String? msg;

  @override
  String toString() {
    return 'PackageResponseDto(data: $data, statusCode: $statusCode, msg: $msg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackageResponseDtoImpl &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.msg, msg) || other.msg == msg));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data, statusCode, msg);

  /// Create a copy of PackageResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PackageResponseDtoImplCopyWith<_$PackageResponseDtoImpl> get copyWith =>
      __$$PackageResponseDtoImplCopyWithImpl<_$PackageResponseDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PackageResponseDtoImplToJson(this);
  }
}

abstract class _PackageResponseDto implements PackageResponseDto {
  const factory _PackageResponseDto({
    final PackageDataDto? data,
    final int? statusCode,
    final String? msg,
  }) = _$PackageResponseDtoImpl;

  factory _PackageResponseDto.fromJson(Map<String, dynamic> json) =
      _$PackageResponseDtoImpl.fromJson;

  @override
  PackageDataDto? get data;
  @override
  int? get statusCode;
  @override
  String? get msg;

  /// Create a copy of PackageResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PackageResponseDtoImplCopyWith<_$PackageResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PackageDataDto _$PackageDataDtoFromJson(Map<String, dynamic> json) {
  return _PackageDataDto.fromJson(json);
}

/// @nodoc
mixin _$PackageDataDto {
  List<PackageItemDto> get packages => throw _privateConstructorUsedError;

  /// Serializes this PackageDataDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PackageDataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PackageDataDtoCopyWith<PackageDataDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackageDataDtoCopyWith<$Res> {
  factory $PackageDataDtoCopyWith(
    PackageDataDto value,
    $Res Function(PackageDataDto) then,
  ) = _$PackageDataDtoCopyWithImpl<$Res, PackageDataDto>;
  @useResult
  $Res call({List<PackageItemDto> packages});
}

/// @nodoc
class _$PackageDataDtoCopyWithImpl<$Res, $Val extends PackageDataDto>
    implements $PackageDataDtoCopyWith<$Res> {
  _$PackageDataDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PackageDataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? packages = null}) {
    return _then(
      _value.copyWith(
            packages: null == packages
                ? _value.packages
                : packages // ignore: cast_nullable_to_non_nullable
                      as List<PackageItemDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PackageDataDtoImplCopyWith<$Res>
    implements $PackageDataDtoCopyWith<$Res> {
  factory _$$PackageDataDtoImplCopyWith(
    _$PackageDataDtoImpl value,
    $Res Function(_$PackageDataDtoImpl) then,
  ) = __$$PackageDataDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<PackageItemDto> packages});
}

/// @nodoc
class __$$PackageDataDtoImplCopyWithImpl<$Res>
    extends _$PackageDataDtoCopyWithImpl<$Res, _$PackageDataDtoImpl>
    implements _$$PackageDataDtoImplCopyWith<$Res> {
  __$$PackageDataDtoImplCopyWithImpl(
    _$PackageDataDtoImpl _value,
    $Res Function(_$PackageDataDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PackageDataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? packages = null}) {
    return _then(
      _$PackageDataDtoImpl(
        packages: null == packages
            ? _value._packages
            : packages // ignore: cast_nullable_to_non_nullable
                  as List<PackageItemDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PackageDataDtoImpl implements _PackageDataDto {
  const _$PackageDataDtoImpl({final List<PackageItemDto> packages = const []})
    : _packages = packages;

  factory _$PackageDataDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackageDataDtoImplFromJson(json);

  final List<PackageItemDto> _packages;
  @override
  @JsonKey()
  List<PackageItemDto> get packages {
    if (_packages is EqualUnmodifiableListView) return _packages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_packages);
  }

  @override
  String toString() {
    return 'PackageDataDto(packages: $packages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackageDataDtoImpl &&
            const DeepCollectionEquality().equals(other._packages, _packages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_packages));

  /// Create a copy of PackageDataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PackageDataDtoImplCopyWith<_$PackageDataDtoImpl> get copyWith =>
      __$$PackageDataDtoImplCopyWithImpl<_$PackageDataDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PackageDataDtoImplToJson(this);
  }
}

abstract class _PackageDataDto implements PackageDataDto {
  const factory _PackageDataDto({final List<PackageItemDto> packages}) =
      _$PackageDataDtoImpl;

  factory _PackageDataDto.fromJson(Map<String, dynamic> json) =
      _$PackageDataDtoImpl.fromJson;

  @override
  List<PackageItemDto> get packages;

  /// Create a copy of PackageDataDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PackageDataDtoImplCopyWith<_$PackageDataDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PackageItemDto _$PackageItemDtoFromJson(Map<String, dynamic> json) {
  return _PackageItemDto.fromJson(json);
}

/// @nodoc
mixin _$PackageItemDto {
  int? get id => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  int? get companyID => throw _privateConstructorUsedError;
  int? get sourceBranchID => throw _privateConstructorUsedError;
  int? get destinationBranchID => throw _privateConstructorUsedError;
  int? get statusID => throw _privateConstructorUsedError;
  String? get sourceBranchName => throw _privateConstructorUsedError;
  String? get destinationBranchName => throw _privateConstructorUsedError;

  /// Serializes this PackageItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PackageItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PackageItemDtoCopyWith<PackageItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackageItemDtoCopyWith<$Res> {
  factory $PackageItemDtoCopyWith(
    PackageItemDto value,
    $Res Function(PackageItemDto) then,
  ) = _$PackageItemDtoCopyWithImpl<$Res, PackageItemDto>;
  @useResult
  $Res call({
    int? id,
    String? barcode,
    int? companyID,
    int? sourceBranchID,
    int? destinationBranchID,
    int? statusID,
    String? sourceBranchName,
    String? destinationBranchName,
  });
}

/// @nodoc
class _$PackageItemDtoCopyWithImpl<$Res, $Val extends PackageItemDto>
    implements $PackageItemDtoCopyWith<$Res> {
  _$PackageItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PackageItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? barcode = freezed,
    Object? companyID = freezed,
    Object? sourceBranchID = freezed,
    Object? destinationBranchID = freezed,
    Object? statusID = freezed,
    Object? sourceBranchName = freezed,
    Object? destinationBranchName = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            barcode: freezed == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String?,
            companyID: freezed == companyID
                ? _value.companyID
                : companyID // ignore: cast_nullable_to_non_nullable
                      as int?,
            sourceBranchID: freezed == sourceBranchID
                ? _value.sourceBranchID
                : sourceBranchID // ignore: cast_nullable_to_non_nullable
                      as int?,
            destinationBranchID: freezed == destinationBranchID
                ? _value.destinationBranchID
                : destinationBranchID // ignore: cast_nullable_to_non_nullable
                      as int?,
            statusID: freezed == statusID
                ? _value.statusID
                : statusID // ignore: cast_nullable_to_non_nullable
                      as int?,
            sourceBranchName: freezed == sourceBranchName
                ? _value.sourceBranchName
                : sourceBranchName // ignore: cast_nullable_to_non_nullable
                      as String?,
            destinationBranchName: freezed == destinationBranchName
                ? _value.destinationBranchName
                : destinationBranchName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PackageItemDtoImplCopyWith<$Res>
    implements $PackageItemDtoCopyWith<$Res> {
  factory _$$PackageItemDtoImplCopyWith(
    _$PackageItemDtoImpl value,
    $Res Function(_$PackageItemDtoImpl) then,
  ) = __$$PackageItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    String? barcode,
    int? companyID,
    int? sourceBranchID,
    int? destinationBranchID,
    int? statusID,
    String? sourceBranchName,
    String? destinationBranchName,
  });
}

/// @nodoc
class __$$PackageItemDtoImplCopyWithImpl<$Res>
    extends _$PackageItemDtoCopyWithImpl<$Res, _$PackageItemDtoImpl>
    implements _$$PackageItemDtoImplCopyWith<$Res> {
  __$$PackageItemDtoImplCopyWithImpl(
    _$PackageItemDtoImpl _value,
    $Res Function(_$PackageItemDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PackageItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? barcode = freezed,
    Object? companyID = freezed,
    Object? sourceBranchID = freezed,
    Object? destinationBranchID = freezed,
    Object? statusID = freezed,
    Object? sourceBranchName = freezed,
    Object? destinationBranchName = freezed,
  }) {
    return _then(
      _$PackageItemDtoImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        barcode: freezed == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String?,
        companyID: freezed == companyID
            ? _value.companyID
            : companyID // ignore: cast_nullable_to_non_nullable
                  as int?,
        sourceBranchID: freezed == sourceBranchID
            ? _value.sourceBranchID
            : sourceBranchID // ignore: cast_nullable_to_non_nullable
                  as int?,
        destinationBranchID: freezed == destinationBranchID
            ? _value.destinationBranchID
            : destinationBranchID // ignore: cast_nullable_to_non_nullable
                  as int?,
        statusID: freezed == statusID
            ? _value.statusID
            : statusID // ignore: cast_nullable_to_non_nullable
                  as int?,
        sourceBranchName: freezed == sourceBranchName
            ? _value.sourceBranchName
            : sourceBranchName // ignore: cast_nullable_to_non_nullable
                  as String?,
        destinationBranchName: freezed == destinationBranchName
            ? _value.destinationBranchName
            : destinationBranchName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PackageItemDtoImpl implements _PackageItemDto {
  const _$PackageItemDtoImpl({
    this.id,
    this.barcode,
    this.companyID,
    this.sourceBranchID,
    this.destinationBranchID,
    this.statusID,
    this.sourceBranchName,
    this.destinationBranchName,
  });

  factory _$PackageItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackageItemDtoImplFromJson(json);

  @override
  final int? id;
  @override
  final String? barcode;
  @override
  final int? companyID;
  @override
  final int? sourceBranchID;
  @override
  final int? destinationBranchID;
  @override
  final int? statusID;
  @override
  final String? sourceBranchName;
  @override
  final String? destinationBranchName;

  @override
  String toString() {
    return 'PackageItemDto(id: $id, barcode: $barcode, companyID: $companyID, sourceBranchID: $sourceBranchID, destinationBranchID: $destinationBranchID, statusID: $statusID, sourceBranchName: $sourceBranchName, destinationBranchName: $destinationBranchName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackageItemDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.companyID, companyID) ||
                other.companyID == companyID) &&
            (identical(other.sourceBranchID, sourceBranchID) ||
                other.sourceBranchID == sourceBranchID) &&
            (identical(other.destinationBranchID, destinationBranchID) ||
                other.destinationBranchID == destinationBranchID) &&
            (identical(other.statusID, statusID) ||
                other.statusID == statusID) &&
            (identical(other.sourceBranchName, sourceBranchName) ||
                other.sourceBranchName == sourceBranchName) &&
            (identical(other.destinationBranchName, destinationBranchName) ||
                other.destinationBranchName == destinationBranchName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    barcode,
    companyID,
    sourceBranchID,
    destinationBranchID,
    statusID,
    sourceBranchName,
    destinationBranchName,
  );

  /// Create a copy of PackageItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PackageItemDtoImplCopyWith<_$PackageItemDtoImpl> get copyWith =>
      __$$PackageItemDtoImplCopyWithImpl<_$PackageItemDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PackageItemDtoImplToJson(this);
  }
}

abstract class _PackageItemDto implements PackageItemDto {
  const factory _PackageItemDto({
    final int? id,
    final String? barcode,
    final int? companyID,
    final int? sourceBranchID,
    final int? destinationBranchID,
    final int? statusID,
    final String? sourceBranchName,
    final String? destinationBranchName,
  }) = _$PackageItemDtoImpl;

  factory _PackageItemDto.fromJson(Map<String, dynamic> json) =
      _$PackageItemDtoImpl.fromJson;

  @override
  int? get id;
  @override
  String? get barcode;
  @override
  int? get companyID;
  @override
  int? get sourceBranchID;
  @override
  int? get destinationBranchID;
  @override
  int? get statusID;
  @override
  String? get sourceBranchName;
  @override
  String? get destinationBranchName;

  /// Create a copy of PackageItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PackageItemDtoImplCopyWith<_$PackageItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GenericResponseDto _$GenericResponseDtoFromJson(Map<String, dynamic> json) {
  return _GenericResponseDto.fromJson(json);
}

/// @nodoc
mixin _$GenericResponseDto {
  int? get statusCode => throw _privateConstructorUsedError;
  String? get msg => throw _privateConstructorUsedError;

  /// Serializes this GenericResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GenericResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GenericResponseDtoCopyWith<GenericResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenericResponseDtoCopyWith<$Res> {
  factory $GenericResponseDtoCopyWith(
    GenericResponseDto value,
    $Res Function(GenericResponseDto) then,
  ) = _$GenericResponseDtoCopyWithImpl<$Res, GenericResponseDto>;
  @useResult
  $Res call({int? statusCode, String? msg});
}

/// @nodoc
class _$GenericResponseDtoCopyWithImpl<$Res, $Val extends GenericResponseDto>
    implements $GenericResponseDtoCopyWith<$Res> {
  _$GenericResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GenericResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? statusCode = freezed, Object? msg = freezed}) {
    return _then(
      _value.copyWith(
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
abstract class _$$GenericResponseDtoImplCopyWith<$Res>
    implements $GenericResponseDtoCopyWith<$Res> {
  factory _$$GenericResponseDtoImplCopyWith(
    _$GenericResponseDtoImpl value,
    $Res Function(_$GenericResponseDtoImpl) then,
  ) = __$$GenericResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? statusCode, String? msg});
}

/// @nodoc
class __$$GenericResponseDtoImplCopyWithImpl<$Res>
    extends _$GenericResponseDtoCopyWithImpl<$Res, _$GenericResponseDtoImpl>
    implements _$$GenericResponseDtoImplCopyWith<$Res> {
  __$$GenericResponseDtoImplCopyWithImpl(
    _$GenericResponseDtoImpl _value,
    $Res Function(_$GenericResponseDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GenericResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? statusCode = freezed, Object? msg = freezed}) {
    return _then(
      _$GenericResponseDtoImpl(
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
class _$GenericResponseDtoImpl implements _GenericResponseDto {
  const _$GenericResponseDtoImpl({this.statusCode, this.msg});

  factory _$GenericResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GenericResponseDtoImplFromJson(json);

  @override
  final int? statusCode;
  @override
  final String? msg;

  @override
  String toString() {
    return 'GenericResponseDto(statusCode: $statusCode, msg: $msg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenericResponseDtoImpl &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.msg, msg) || other.msg == msg));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, statusCode, msg);

  /// Create a copy of GenericResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GenericResponseDtoImplCopyWith<_$GenericResponseDtoImpl> get copyWith =>
      __$$GenericResponseDtoImplCopyWithImpl<_$GenericResponseDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GenericResponseDtoImplToJson(this);
  }
}

abstract class _GenericResponseDto implements GenericResponseDto {
  const factory _GenericResponseDto({
    final int? statusCode,
    final String? msg,
  }) = _$GenericResponseDtoImpl;

  factory _GenericResponseDto.fromJson(Map<String, dynamic> json) =
      _$GenericResponseDtoImpl.fromJson;

  @override
  int? get statusCode;
  @override
  String? get msg;

  /// Create a copy of GenericResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GenericResponseDtoImplCopyWith<_$GenericResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
