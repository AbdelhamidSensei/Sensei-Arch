// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LoginUiState {
  // Is the login API call in progress? Shows full-screen loading overlay.
  bool get isLoading =>
      throw _privateConstructorUsedError; // Are we checking for a saved session? Shows splash/loading on first load.
  // Starts as true, set to false once we finish checking.
  bool get isCheckingSession =>
      throw _privateConstructorUsedError; // Error message to show in an AlertDialog. Null = no error.
  String? get errorMessage =>
      throw _privateConstructorUsedError; // The logged-in user. Null = not logged in.
  // When this becomes non-null, the screen navigates to branch selection.
  UserModel? get user => throw _privateConstructorUsedError;

  /// Create a copy of LoginUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginUiStateCopyWith<LoginUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginUiStateCopyWith<$Res> {
  factory $LoginUiStateCopyWith(
    LoginUiState value,
    $Res Function(LoginUiState) then,
  ) = _$LoginUiStateCopyWithImpl<$Res, LoginUiState>;
  @useResult
  $Res call({
    bool isLoading,
    bool isCheckingSession,
    String? errorMessage,
    UserModel? user,
  });

  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class _$LoginUiStateCopyWithImpl<$Res, $Val extends LoginUiState>
    implements $LoginUiStateCopyWith<$Res> {
  _$LoginUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isCheckingSession = null,
    Object? errorMessage = freezed,
    Object? user = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCheckingSession: null == isCheckingSession
                ? _value.isCheckingSession
                : isCheckingSession // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of LoginUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LoginUiStateImplCopyWith<$Res>
    implements $LoginUiStateCopyWith<$Res> {
  factory _$$LoginUiStateImplCopyWith(
    _$LoginUiStateImpl value,
    $Res Function(_$LoginUiStateImpl) then,
  ) = __$$LoginUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    bool isCheckingSession,
    String? errorMessage,
    UserModel? user,
  });

  @override
  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class __$$LoginUiStateImplCopyWithImpl<$Res>
    extends _$LoginUiStateCopyWithImpl<$Res, _$LoginUiStateImpl>
    implements _$$LoginUiStateImplCopyWith<$Res> {
  __$$LoginUiStateImplCopyWithImpl(
    _$LoginUiStateImpl _value,
    $Res Function(_$LoginUiStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isCheckingSession = null,
    Object? errorMessage = freezed,
    Object? user = freezed,
  }) {
    return _then(
      _$LoginUiStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCheckingSession: null == isCheckingSession
            ? _value.isCheckingSession
            : isCheckingSession // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel?,
      ),
    );
  }
}

/// @nodoc

class _$LoginUiStateImpl implements _LoginUiState {
  const _$LoginUiStateImpl({
    this.isLoading = false,
    this.isCheckingSession = true,
    this.errorMessage,
    this.user,
  });

  // Is the login API call in progress? Shows full-screen loading overlay.
  @override
  @JsonKey()
  final bool isLoading;
  // Are we checking for a saved session? Shows splash/loading on first load.
  // Starts as true, set to false once we finish checking.
  @override
  @JsonKey()
  final bool isCheckingSession;
  // Error message to show in an AlertDialog. Null = no error.
  @override
  final String? errorMessage;
  // The logged-in user. Null = not logged in.
  // When this becomes non-null, the screen navigates to branch selection.
  @override
  final UserModel? user;

  @override
  String toString() {
    return 'LoginUiState(isLoading: $isLoading, isCheckingSession: $isCheckingSession, errorMessage: $errorMessage, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginUiStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isCheckingSession, isCheckingSession) ||
                other.isCheckingSession == isCheckingSession) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    isCheckingSession,
    errorMessage,
    user,
  );

  /// Create a copy of LoginUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginUiStateImplCopyWith<_$LoginUiStateImpl> get copyWith =>
      __$$LoginUiStateImplCopyWithImpl<_$LoginUiStateImpl>(this, _$identity);
}

abstract class _LoginUiState implements LoginUiState {
  const factory _LoginUiState({
    final bool isLoading,
    final bool isCheckingSession,
    final String? errorMessage,
    final UserModel? user,
  }) = _$LoginUiStateImpl;

  // Is the login API call in progress? Shows full-screen loading overlay.
  @override
  bool get isLoading; // Are we checking for a saved session? Shows splash/loading on first load.
  // Starts as true, set to false once we finish checking.
  @override
  bool get isCheckingSession; // Error message to show in an AlertDialog. Null = no error.
  @override
  String? get errorMessage; // The logged-in user. Null = not logged in.
  // When this becomes non-null, the screen navigates to branch selection.
  @override
  UserModel? get user;

  /// Create a copy of LoginUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginUiStateImplCopyWith<_$LoginUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
