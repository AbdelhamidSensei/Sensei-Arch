// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users_list_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UsersListUiState {
  // '@Default(false)' = if not provided, defaults to false.
  bool get isLoading => throw _privateConstructorUsedError;
  List<User> get users =>
      throw _privateConstructorUsedError; // 'String?' = a String OR null (see secure_storage.dart for explanation).
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of UsersListUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UsersListUiStateCopyWith<UsersListUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsersListUiStateCopyWith<$Res> {
  factory $UsersListUiStateCopyWith(
    UsersListUiState value,
    $Res Function(UsersListUiState) then,
  ) = _$UsersListUiStateCopyWithImpl<$Res, UsersListUiState>;
  @useResult
  $Res call({bool isLoading, List<User> users, String? errorMessage});
}

/// @nodoc
class _$UsersListUiStateCopyWithImpl<$Res, $Val extends UsersListUiState>
    implements $UsersListUiStateCopyWith<$Res> {
  _$UsersListUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UsersListUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? users = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            users: null == users
                ? _value.users
                : users // ignore: cast_nullable_to_non_nullable
                      as List<User>,
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
abstract class _$$UsersListUiStateImplCopyWith<$Res>
    implements $UsersListUiStateCopyWith<$Res> {
  factory _$$UsersListUiStateImplCopyWith(
    _$UsersListUiStateImpl value,
    $Res Function(_$UsersListUiStateImpl) then,
  ) = __$$UsersListUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, List<User> users, String? errorMessage});
}

/// @nodoc
class __$$UsersListUiStateImplCopyWithImpl<$Res>
    extends _$UsersListUiStateCopyWithImpl<$Res, _$UsersListUiStateImpl>
    implements _$$UsersListUiStateImplCopyWith<$Res> {
  __$$UsersListUiStateImplCopyWithImpl(
    _$UsersListUiStateImpl _value,
    $Res Function(_$UsersListUiStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UsersListUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? users = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$UsersListUiStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        users: null == users
            ? _value._users
            : users // ignore: cast_nullable_to_non_nullable
                  as List<User>,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$UsersListUiStateImpl implements _UsersListUiState {
  const _$UsersListUiStateImpl({
    this.isLoading = false,
    final List<User> users = const <User>[],
    this.errorMessage,
  }) : _users = users;

  // '@Default(false)' = if not provided, defaults to false.
  @override
  @JsonKey()
  final bool isLoading;
  final List<User> _users;
  @override
  @JsonKey()
  List<User> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  // 'String?' = a String OR null (see secure_storage.dart for explanation).
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'UsersListUiState(isLoading: $isLoading, users: $users, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsersListUiStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    const DeepCollectionEquality().hash(_users),
    errorMessage,
  );

  /// Create a copy of UsersListUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UsersListUiStateImplCopyWith<_$UsersListUiStateImpl> get copyWith =>
      __$$UsersListUiStateImplCopyWithImpl<_$UsersListUiStateImpl>(
        this,
        _$identity,
      );
}

abstract class _UsersListUiState implements UsersListUiState {
  const factory _UsersListUiState({
    final bool isLoading,
    final List<User> users,
    final String? errorMessage,
  }) = _$UsersListUiStateImpl;

  // '@Default(false)' = if not provided, defaults to false.
  @override
  bool get isLoading;
  @override
  List<User> get users; // 'String?' = a String OR null (see secure_storage.dart for explanation).
  @override
  String? get errorMessage;

  /// Create a copy of UsersListUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UsersListUiStateImplCopyWith<_$UsersListUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
