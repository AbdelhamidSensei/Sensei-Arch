// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_detail_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UserDetailUiState {
  bool get isLoading => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of UserDetailUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserDetailUiStateCopyWith<UserDetailUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDetailUiStateCopyWith<$Res> {
  factory $UserDetailUiStateCopyWith(
    UserDetailUiState value,
    $Res Function(UserDetailUiState) then,
  ) = _$UserDetailUiStateCopyWithImpl<$Res, UserDetailUiState>;
  @useResult
  $Res call({bool isLoading, User? user, String? errorMessage});

  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$UserDetailUiStateCopyWithImpl<$Res, $Val extends UserDetailUiState>
    implements $UserDetailUiStateCopyWith<$Res> {
  _$UserDetailUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserDetailUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? user = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as User?,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of UserDetailUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserDetailUiStateImplCopyWith<$Res>
    implements $UserDetailUiStateCopyWith<$Res> {
  factory _$$UserDetailUiStateImplCopyWith(
    _$UserDetailUiStateImpl value,
    $Res Function(_$UserDetailUiStateImpl) then,
  ) = __$$UserDetailUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, User? user, String? errorMessage});

  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$UserDetailUiStateImplCopyWithImpl<$Res>
    extends _$UserDetailUiStateCopyWithImpl<$Res, _$UserDetailUiStateImpl>
    implements _$$UserDetailUiStateImplCopyWith<$Res> {
  __$$UserDetailUiStateImplCopyWithImpl(
    _$UserDetailUiStateImpl _value,
    $Res Function(_$UserDetailUiStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserDetailUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? user = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$UserDetailUiStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$UserDetailUiStateImpl implements _UserDetailUiState {
  const _$UserDetailUiStateImpl({
    this.isLoading = false,
    this.user,
    this.errorMessage,
  });

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final User? user;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'UserDetailUiState(isLoading: $isLoading, user: $user, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDetailUiStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, user, errorMessage);

  /// Create a copy of UserDetailUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDetailUiStateImplCopyWith<_$UserDetailUiStateImpl> get copyWith =>
      __$$UserDetailUiStateImplCopyWithImpl<_$UserDetailUiStateImpl>(
        this,
        _$identity,
      );
}

abstract class _UserDetailUiState implements UserDetailUiState {
  const factory _UserDetailUiState({
    final bool isLoading,
    final User? user,
    final String? errorMessage,
  }) = _$UserDetailUiStateImpl;

  @override
  bool get isLoading;
  @override
  User? get user;
  @override
  String? get errorMessage;

  /// Create a copy of UserDetailUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserDetailUiStateImplCopyWith<_$UserDetailUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
