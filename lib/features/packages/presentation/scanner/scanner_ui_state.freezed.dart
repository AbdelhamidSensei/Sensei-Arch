// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scanner_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ScannerUiState {
  bool get isProcessing => throw _privateConstructorUsedError;
  String? get lastScannedBarcode => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  bool get isClosed => throw _privateConstructorUsedError;

  /// Create a copy of ScannerUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScannerUiStateCopyWith<ScannerUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScannerUiStateCopyWith<$Res> {
  factory $ScannerUiStateCopyWith(
    ScannerUiState value,
    $Res Function(ScannerUiState) then,
  ) = _$ScannerUiStateCopyWithImpl<$Res, ScannerUiState>;
  @useResult
  $Res call({
    bool isProcessing,
    String? lastScannedBarcode,
    String? message,
    bool isClosed,
  });
}

/// @nodoc
class _$ScannerUiStateCopyWithImpl<$Res, $Val extends ScannerUiState>
    implements $ScannerUiStateCopyWith<$Res> {
  _$ScannerUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScannerUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isProcessing = null,
    Object? lastScannedBarcode = freezed,
    Object? message = freezed,
    Object? isClosed = null,
  }) {
    return _then(
      _value.copyWith(
            isProcessing: null == isProcessing
                ? _value.isProcessing
                : isProcessing // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastScannedBarcode: freezed == lastScannedBarcode
                ? _value.lastScannedBarcode
                : lastScannedBarcode // ignore: cast_nullable_to_non_nullable
                      as String?,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            isClosed: null == isClosed
                ? _value.isClosed
                : isClosed // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScannerUiStateImplCopyWith<$Res>
    implements $ScannerUiStateCopyWith<$Res> {
  factory _$$ScannerUiStateImplCopyWith(
    _$ScannerUiStateImpl value,
    $Res Function(_$ScannerUiStateImpl) then,
  ) = __$$ScannerUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isProcessing,
    String? lastScannedBarcode,
    String? message,
    bool isClosed,
  });
}

/// @nodoc
class __$$ScannerUiStateImplCopyWithImpl<$Res>
    extends _$ScannerUiStateCopyWithImpl<$Res, _$ScannerUiStateImpl>
    implements _$$ScannerUiStateImplCopyWith<$Res> {
  __$$ScannerUiStateImplCopyWithImpl(
    _$ScannerUiStateImpl _value,
    $Res Function(_$ScannerUiStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScannerUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isProcessing = null,
    Object? lastScannedBarcode = freezed,
    Object? message = freezed,
    Object? isClosed = null,
  }) {
    return _then(
      _$ScannerUiStateImpl(
        isProcessing: null == isProcessing
            ? _value.isProcessing
            : isProcessing // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastScannedBarcode: freezed == lastScannedBarcode
            ? _value.lastScannedBarcode
            : lastScannedBarcode // ignore: cast_nullable_to_non_nullable
                  as String?,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        isClosed: null == isClosed
            ? _value.isClosed
            : isClosed // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$ScannerUiStateImpl implements _ScannerUiState {
  const _$ScannerUiStateImpl({
    this.isProcessing = false,
    this.lastScannedBarcode,
    this.message,
    this.isClosed = false,
  });

  @override
  @JsonKey()
  final bool isProcessing;
  @override
  final String? lastScannedBarcode;
  @override
  final String? message;
  @override
  @JsonKey()
  final bool isClosed;

  @override
  String toString() {
    return 'ScannerUiState(isProcessing: $isProcessing, lastScannedBarcode: $lastScannedBarcode, message: $message, isClosed: $isClosed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScannerUiStateImpl &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.lastScannedBarcode, lastScannedBarcode) ||
                other.lastScannedBarcode == lastScannedBarcode) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isClosed, isClosed) ||
                other.isClosed == isClosed));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isProcessing,
    lastScannedBarcode,
    message,
    isClosed,
  );

  /// Create a copy of ScannerUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScannerUiStateImplCopyWith<_$ScannerUiStateImpl> get copyWith =>
      __$$ScannerUiStateImplCopyWithImpl<_$ScannerUiStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ScannerUiState implements ScannerUiState {
  const factory _ScannerUiState({
    final bool isProcessing,
    final String? lastScannedBarcode,
    final String? message,
    final bool isClosed,
  }) = _$ScannerUiStateImpl;

  @override
  bool get isProcessing;
  @override
  String? get lastScannedBarcode;
  @override
  String? get message;
  @override
  bool get isClosed;

  /// Create a copy of ScannerUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScannerUiStateImplCopyWith<_$ScannerUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
