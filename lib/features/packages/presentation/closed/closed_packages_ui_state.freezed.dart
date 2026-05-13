// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'closed_packages_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ClosedPackagesUiState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<PackageModel> get packages => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  int? get sendingPackageId => throw _privateConstructorUsedError;

  /// Create a copy of ClosedPackagesUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClosedPackagesUiStateCopyWith<ClosedPackagesUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClosedPackagesUiStateCopyWith<$Res> {
  factory $ClosedPackagesUiStateCopyWith(
    ClosedPackagesUiState value,
    $Res Function(ClosedPackagesUiState) then,
  ) = _$ClosedPackagesUiStateCopyWithImpl<$Res, ClosedPackagesUiState>;
  @useResult
  $Res call({
    bool isLoading,
    List<PackageModel> packages,
    String? errorMessage,
    int? sendingPackageId,
  });
}

/// @nodoc
class _$ClosedPackagesUiStateCopyWithImpl<
  $Res,
  $Val extends ClosedPackagesUiState
>
    implements $ClosedPackagesUiStateCopyWith<$Res> {
  _$ClosedPackagesUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClosedPackagesUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? packages = null,
    Object? errorMessage = freezed,
    Object? sendingPackageId = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            packages: null == packages
                ? _value.packages
                : packages // ignore: cast_nullable_to_non_nullable
                      as List<PackageModel>,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            sendingPackageId: freezed == sendingPackageId
                ? _value.sendingPackageId
                : sendingPackageId // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ClosedPackagesUiStateImplCopyWith<$Res>
    implements $ClosedPackagesUiStateCopyWith<$Res> {
  factory _$$ClosedPackagesUiStateImplCopyWith(
    _$ClosedPackagesUiStateImpl value,
    $Res Function(_$ClosedPackagesUiStateImpl) then,
  ) = __$$ClosedPackagesUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    List<PackageModel> packages,
    String? errorMessage,
    int? sendingPackageId,
  });
}

/// @nodoc
class __$$ClosedPackagesUiStateImplCopyWithImpl<$Res>
    extends
        _$ClosedPackagesUiStateCopyWithImpl<$Res, _$ClosedPackagesUiStateImpl>
    implements _$$ClosedPackagesUiStateImplCopyWith<$Res> {
  __$$ClosedPackagesUiStateImplCopyWithImpl(
    _$ClosedPackagesUiStateImpl _value,
    $Res Function(_$ClosedPackagesUiStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ClosedPackagesUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? packages = null,
    Object? errorMessage = freezed,
    Object? sendingPackageId = freezed,
  }) {
    return _then(
      _$ClosedPackagesUiStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        packages: null == packages
            ? _value._packages
            : packages // ignore: cast_nullable_to_non_nullable
                  as List<PackageModel>,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        sendingPackageId: freezed == sendingPackageId
            ? _value.sendingPackageId
            : sendingPackageId // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$ClosedPackagesUiStateImpl implements _ClosedPackagesUiState {
  const _$ClosedPackagesUiStateImpl({
    this.isLoading = false,
    final List<PackageModel> packages = const [],
    this.errorMessage,
    this.sendingPackageId,
  }) : _packages = packages;

  @override
  @JsonKey()
  final bool isLoading;
  final List<PackageModel> _packages;
  @override
  @JsonKey()
  List<PackageModel> get packages {
    if (_packages is EqualUnmodifiableListView) return _packages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_packages);
  }

  @override
  final String? errorMessage;
  @override
  final int? sendingPackageId;

  @override
  String toString() {
    return 'ClosedPackagesUiState(isLoading: $isLoading, packages: $packages, errorMessage: $errorMessage, sendingPackageId: $sendingPackageId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClosedPackagesUiStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._packages, _packages) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.sendingPackageId, sendingPackageId) ||
                other.sendingPackageId == sendingPackageId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    const DeepCollectionEquality().hash(_packages),
    errorMessage,
    sendingPackageId,
  );

  /// Create a copy of ClosedPackagesUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClosedPackagesUiStateImplCopyWith<_$ClosedPackagesUiStateImpl>
  get copyWith =>
      __$$ClosedPackagesUiStateImplCopyWithImpl<_$ClosedPackagesUiStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ClosedPackagesUiState implements ClosedPackagesUiState {
  const factory _ClosedPackagesUiState({
    final bool isLoading,
    final List<PackageModel> packages,
    final String? errorMessage,
    final int? sendingPackageId,
  }) = _$ClosedPackagesUiStateImpl;

  @override
  bool get isLoading;
  @override
  List<PackageModel> get packages;
  @override
  String? get errorMessage;
  @override
  int? get sendingPackageId;

  /// Create a copy of ClosedPackagesUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClosedPackagesUiStateImplCopyWith<_$ClosedPackagesUiStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
