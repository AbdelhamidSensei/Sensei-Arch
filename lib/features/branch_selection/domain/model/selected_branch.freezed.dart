// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selected_branch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SelectedBranch _$SelectedBranchFromJson(Map<String, dynamic> json) {
  return _SelectedBranch.fromJson(json);
}

/// @nodoc
mixin _$SelectedBranch {
  int get companyID => throw _privateConstructorUsedError;
  int get branchID => throw _privateConstructorUsedError;
  String get branchName => throw _privateConstructorUsedError;

  /// Serializes this SelectedBranch to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SelectedBranch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SelectedBranchCopyWith<SelectedBranch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectedBranchCopyWith<$Res> {
  factory $SelectedBranchCopyWith(
    SelectedBranch value,
    $Res Function(SelectedBranch) then,
  ) = _$SelectedBranchCopyWithImpl<$Res, SelectedBranch>;
  @useResult
  $Res call({int companyID, int branchID, String branchName});
}

/// @nodoc
class _$SelectedBranchCopyWithImpl<$Res, $Val extends SelectedBranch>
    implements $SelectedBranchCopyWith<$Res> {
  _$SelectedBranchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SelectedBranch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyID = null,
    Object? branchID = null,
    Object? branchName = null,
  }) {
    return _then(
      _value.copyWith(
            companyID: null == companyID
                ? _value.companyID
                : companyID // ignore: cast_nullable_to_non_nullable
                      as int,
            branchID: null == branchID
                ? _value.branchID
                : branchID // ignore: cast_nullable_to_non_nullable
                      as int,
            branchName: null == branchName
                ? _value.branchName
                : branchName // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SelectedBranchImplCopyWith<$Res>
    implements $SelectedBranchCopyWith<$Res> {
  factory _$$SelectedBranchImplCopyWith(
    _$SelectedBranchImpl value,
    $Res Function(_$SelectedBranchImpl) then,
  ) = __$$SelectedBranchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int companyID, int branchID, String branchName});
}

/// @nodoc
class __$$SelectedBranchImplCopyWithImpl<$Res>
    extends _$SelectedBranchCopyWithImpl<$Res, _$SelectedBranchImpl>
    implements _$$SelectedBranchImplCopyWith<$Res> {
  __$$SelectedBranchImplCopyWithImpl(
    _$SelectedBranchImpl _value,
    $Res Function(_$SelectedBranchImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SelectedBranch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyID = null,
    Object? branchID = null,
    Object? branchName = null,
  }) {
    return _then(
      _$SelectedBranchImpl(
        companyID: null == companyID
            ? _value.companyID
            : companyID // ignore: cast_nullable_to_non_nullable
                  as int,
        branchID: null == branchID
            ? _value.branchID
            : branchID // ignore: cast_nullable_to_non_nullable
                  as int,
        branchName: null == branchName
            ? _value.branchName
            : branchName // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SelectedBranchImpl implements _SelectedBranch {
  const _$SelectedBranchImpl({
    required this.companyID,
    required this.branchID,
    required this.branchName,
  });

  factory _$SelectedBranchImpl.fromJson(Map<String, dynamic> json) =>
      _$$SelectedBranchImplFromJson(json);

  @override
  final int companyID;
  @override
  final int branchID;
  @override
  final String branchName;

  @override
  String toString() {
    return 'SelectedBranch(companyID: $companyID, branchID: $branchID, branchName: $branchName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectedBranchImpl &&
            (identical(other.companyID, companyID) ||
                other.companyID == companyID) &&
            (identical(other.branchID, branchID) ||
                other.branchID == branchID) &&
            (identical(other.branchName, branchName) ||
                other.branchName == branchName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, companyID, branchID, branchName);

  /// Create a copy of SelectedBranch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectedBranchImplCopyWith<_$SelectedBranchImpl> get copyWith =>
      __$$SelectedBranchImplCopyWithImpl<_$SelectedBranchImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SelectedBranchImplToJson(this);
  }
}

abstract class _SelectedBranch implements SelectedBranch {
  const factory _SelectedBranch({
    required final int companyID,
    required final int branchID,
    required final String branchName,
  }) = _$SelectedBranchImpl;

  factory _SelectedBranch.fromJson(Map<String, dynamic> json) =
      _$SelectedBranchImpl.fromJson;

  @override
  int get companyID;
  @override
  int get branchID;
  @override
  String get branchName;

  /// Create a copy of SelectedBranch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectedBranchImplCopyWith<_$SelectedBranchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
