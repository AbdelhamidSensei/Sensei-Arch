// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'open_packages_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OpenPackagesUiState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<PackageModel> get packages => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of OpenPackagesUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpenPackagesUiStateCopyWith<OpenPackagesUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenPackagesUiStateCopyWith<$Res> {
  factory $OpenPackagesUiStateCopyWith(
    OpenPackagesUiState value,
    $Res Function(OpenPackagesUiState) then,
  ) = _$OpenPackagesUiStateCopyWithImpl<$Res, OpenPackagesUiState>;
  @useResult
  $Res call({
    bool isLoading,
    List<PackageModel> packages,
    String? errorMessage,
  });
}

/// @nodoc
class _$OpenPackagesUiStateCopyWithImpl<$Res, $Val extends OpenPackagesUiState>
    implements $OpenPackagesUiStateCopyWith<$Res> {
  _$OpenPackagesUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpenPackagesUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? packages = null,
    Object? errorMessage = freezed,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OpenPackagesUiStateImplCopyWith<$Res>
    implements $OpenPackagesUiStateCopyWith<$Res> {
  factory _$$OpenPackagesUiStateImplCopyWith(
    _$OpenPackagesUiStateImpl value,
    $Res Function(_$OpenPackagesUiStateImpl) then,
  ) = __$$OpenPackagesUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    List<PackageModel> packages,
    String? errorMessage,
  });
}

/// @nodoc
class __$$OpenPackagesUiStateImplCopyWithImpl<$Res>
    extends _$OpenPackagesUiStateCopyWithImpl<$Res, _$OpenPackagesUiStateImpl>
    implements _$$OpenPackagesUiStateImplCopyWith<$Res> {
  __$$OpenPackagesUiStateImplCopyWithImpl(
    _$OpenPackagesUiStateImpl _value,
    $Res Function(_$OpenPackagesUiStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OpenPackagesUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? packages = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$OpenPackagesUiStateImpl(
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
      ),
    );
  }
}

/// @nodoc

class _$OpenPackagesUiStateImpl implements _OpenPackagesUiState {
  const _$OpenPackagesUiStateImpl({
    this.isLoading = false,
    final List<PackageModel> packages = const [],
    this.errorMessage,
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
  String toString() {
    return 'OpenPackagesUiState(isLoading: $isLoading, packages: $packages, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenPackagesUiStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._packages, _packages) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    const DeepCollectionEquality().hash(_packages),
    errorMessage,
  );

  /// Create a copy of OpenPackagesUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenPackagesUiStateImplCopyWith<_$OpenPackagesUiStateImpl> get copyWith =>
      __$$OpenPackagesUiStateImplCopyWithImpl<_$OpenPackagesUiStateImpl>(
        this,
        _$identity,
      );
}

abstract class _OpenPackagesUiState implements OpenPackagesUiState {
  const factory _OpenPackagesUiState({
    final bool isLoading,
    final List<PackageModel> packages,
    final String? errorMessage,
  }) = _$OpenPackagesUiStateImpl;

  @override
  bool get isLoading;
  @override
  List<PackageModel> get packages;
  @override
  String? get errorMessage;

  /// Create a copy of OpenPackagesUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpenPackagesUiStateImplCopyWith<_$OpenPackagesUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
