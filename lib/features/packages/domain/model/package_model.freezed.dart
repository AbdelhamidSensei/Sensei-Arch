// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PackageModel _$PackageModelFromJson(Map<String, dynamic> json) {
  return _PackageModel.fromJson(json);
}

/// @nodoc
mixin _$PackageModel {
  int get id => throw _privateConstructorUsedError;
  String get barcode => throw _privateConstructorUsedError;
  int get companyID => throw _privateConstructorUsedError;
  int get sourceBranchID => throw _privateConstructorUsedError;
  int get destinationBranchID => throw _privateConstructorUsedError;
  int get statusID => throw _privateConstructorUsedError;
  String get sourceBranchName => throw _privateConstructorUsedError;
  String get destinationBranchName => throw _privateConstructorUsedError;

  /// Serializes this PackageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PackageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PackageModelCopyWith<PackageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackageModelCopyWith<$Res> {
  factory $PackageModelCopyWith(
    PackageModel value,
    $Res Function(PackageModel) then,
  ) = _$PackageModelCopyWithImpl<$Res, PackageModel>;
  @useResult
  $Res call({
    int id,
    String barcode,
    int companyID,
    int sourceBranchID,
    int destinationBranchID,
    int statusID,
    String sourceBranchName,
    String destinationBranchName,
  });
}

/// @nodoc
class _$PackageModelCopyWithImpl<$Res, $Val extends PackageModel>
    implements $PackageModelCopyWith<$Res> {
  _$PackageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PackageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? barcode = null,
    Object? companyID = null,
    Object? sourceBranchID = null,
    Object? destinationBranchID = null,
    Object? statusID = null,
    Object? sourceBranchName = null,
    Object? destinationBranchName = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            barcode: null == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String,
            companyID: null == companyID
                ? _value.companyID
                : companyID // ignore: cast_nullable_to_non_nullable
                      as int,
            sourceBranchID: null == sourceBranchID
                ? _value.sourceBranchID
                : sourceBranchID // ignore: cast_nullable_to_non_nullable
                      as int,
            destinationBranchID: null == destinationBranchID
                ? _value.destinationBranchID
                : destinationBranchID // ignore: cast_nullable_to_non_nullable
                      as int,
            statusID: null == statusID
                ? _value.statusID
                : statusID // ignore: cast_nullable_to_non_nullable
                      as int,
            sourceBranchName: null == sourceBranchName
                ? _value.sourceBranchName
                : sourceBranchName // ignore: cast_nullable_to_non_nullable
                      as String,
            destinationBranchName: null == destinationBranchName
                ? _value.destinationBranchName
                : destinationBranchName // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PackageModelImplCopyWith<$Res>
    implements $PackageModelCopyWith<$Res> {
  factory _$$PackageModelImplCopyWith(
    _$PackageModelImpl value,
    $Res Function(_$PackageModelImpl) then,
  ) = __$$PackageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String barcode,
    int companyID,
    int sourceBranchID,
    int destinationBranchID,
    int statusID,
    String sourceBranchName,
    String destinationBranchName,
  });
}

/// @nodoc
class __$$PackageModelImplCopyWithImpl<$Res>
    extends _$PackageModelCopyWithImpl<$Res, _$PackageModelImpl>
    implements _$$PackageModelImplCopyWith<$Res> {
  __$$PackageModelImplCopyWithImpl(
    _$PackageModelImpl _value,
    $Res Function(_$PackageModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PackageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? barcode = null,
    Object? companyID = null,
    Object? sourceBranchID = null,
    Object? destinationBranchID = null,
    Object? statusID = null,
    Object? sourceBranchName = null,
    Object? destinationBranchName = null,
  }) {
    return _then(
      _$PackageModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        barcode: null == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String,
        companyID: null == companyID
            ? _value.companyID
            : companyID // ignore: cast_nullable_to_non_nullable
                  as int,
        sourceBranchID: null == sourceBranchID
            ? _value.sourceBranchID
            : sourceBranchID // ignore: cast_nullable_to_non_nullable
                  as int,
        destinationBranchID: null == destinationBranchID
            ? _value.destinationBranchID
            : destinationBranchID // ignore: cast_nullable_to_non_nullable
                  as int,
        statusID: null == statusID
            ? _value.statusID
            : statusID // ignore: cast_nullable_to_non_nullable
                  as int,
        sourceBranchName: null == sourceBranchName
            ? _value.sourceBranchName
            : sourceBranchName // ignore: cast_nullable_to_non_nullable
                  as String,
        destinationBranchName: null == destinationBranchName
            ? _value.destinationBranchName
            : destinationBranchName // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PackageModelImpl implements _PackageModel {
  const _$PackageModelImpl({
    required this.id,
    this.barcode = '',
    required this.companyID,
    required this.sourceBranchID,
    required this.destinationBranchID,
    required this.statusID,
    this.sourceBranchName = '',
    this.destinationBranchName = '',
  });

  factory _$PackageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackageModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey()
  final String barcode;
  @override
  final int companyID;
  @override
  final int sourceBranchID;
  @override
  final int destinationBranchID;
  @override
  final int statusID;
  @override
  @JsonKey()
  final String sourceBranchName;
  @override
  @JsonKey()
  final String destinationBranchName;

  @override
  String toString() {
    return 'PackageModel(id: $id, barcode: $barcode, companyID: $companyID, sourceBranchID: $sourceBranchID, destinationBranchID: $destinationBranchID, statusID: $statusID, sourceBranchName: $sourceBranchName, destinationBranchName: $destinationBranchName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackageModelImpl &&
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

  /// Create a copy of PackageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PackageModelImplCopyWith<_$PackageModelImpl> get copyWith =>
      __$$PackageModelImplCopyWithImpl<_$PackageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PackageModelImplToJson(this);
  }
}

abstract class _PackageModel implements PackageModel {
  const factory _PackageModel({
    required final int id,
    final String barcode,
    required final int companyID,
    required final int sourceBranchID,
    required final int destinationBranchID,
    required final int statusID,
    final String sourceBranchName,
    final String destinationBranchName,
  }) = _$PackageModelImpl;

  factory _PackageModel.fromJson(Map<String, dynamic> json) =
      _$PackageModelImpl.fromJson;

  @override
  int get id;
  @override
  String get barcode;
  @override
  int get companyID;
  @override
  int get sourceBranchID;
  @override
  int get destinationBranchID;
  @override
  int get statusID;
  @override
  String get sourceBranchName;
  @override
  String get destinationBranchName;

  /// Create a copy of PackageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PackageModelImplCopyWith<_$PackageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
