// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch_selection_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BranchSelectionUiState {
  List<BranchItem> get branches => throw _privateConstructorUsedError;
  SelectedBranch? get selectedBranch => throw _privateConstructorUsedError;
  bool get isNavigating => throw _privateConstructorUsedError;

  /// Create a copy of BranchSelectionUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BranchSelectionUiStateCopyWith<BranchSelectionUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BranchSelectionUiStateCopyWith<$Res> {
  factory $BranchSelectionUiStateCopyWith(
    BranchSelectionUiState value,
    $Res Function(BranchSelectionUiState) then,
  ) = _$BranchSelectionUiStateCopyWithImpl<$Res, BranchSelectionUiState>;
  @useResult
  $Res call({
    List<BranchItem> branches,
    SelectedBranch? selectedBranch,
    bool isNavigating,
  });

  $SelectedBranchCopyWith<$Res>? get selectedBranch;
}

/// @nodoc
class _$BranchSelectionUiStateCopyWithImpl<
  $Res,
  $Val extends BranchSelectionUiState
>
    implements $BranchSelectionUiStateCopyWith<$Res> {
  _$BranchSelectionUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BranchSelectionUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? branches = null,
    Object? selectedBranch = freezed,
    Object? isNavigating = null,
  }) {
    return _then(
      _value.copyWith(
            branches: null == branches
                ? _value.branches
                : branches // ignore: cast_nullable_to_non_nullable
                      as List<BranchItem>,
            selectedBranch: freezed == selectedBranch
                ? _value.selectedBranch
                : selectedBranch // ignore: cast_nullable_to_non_nullable
                      as SelectedBranch?,
            isNavigating: null == isNavigating
                ? _value.isNavigating
                : isNavigating // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of BranchSelectionUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SelectedBranchCopyWith<$Res>? get selectedBranch {
    if (_value.selectedBranch == null) {
      return null;
    }

    return $SelectedBranchCopyWith<$Res>(_value.selectedBranch!, (value) {
      return _then(_value.copyWith(selectedBranch: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BranchSelectionUiStateImplCopyWith<$Res>
    implements $BranchSelectionUiStateCopyWith<$Res> {
  factory _$$BranchSelectionUiStateImplCopyWith(
    _$BranchSelectionUiStateImpl value,
    $Res Function(_$BranchSelectionUiStateImpl) then,
  ) = __$$BranchSelectionUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<BranchItem> branches,
    SelectedBranch? selectedBranch,
    bool isNavigating,
  });

  @override
  $SelectedBranchCopyWith<$Res>? get selectedBranch;
}

/// @nodoc
class __$$BranchSelectionUiStateImplCopyWithImpl<$Res>
    extends
        _$BranchSelectionUiStateCopyWithImpl<$Res, _$BranchSelectionUiStateImpl>
    implements _$$BranchSelectionUiStateImplCopyWith<$Res> {
  __$$BranchSelectionUiStateImplCopyWithImpl(
    _$BranchSelectionUiStateImpl _value,
    $Res Function(_$BranchSelectionUiStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BranchSelectionUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? branches = null,
    Object? selectedBranch = freezed,
    Object? isNavigating = null,
  }) {
    return _then(
      _$BranchSelectionUiStateImpl(
        branches: null == branches
            ? _value._branches
            : branches // ignore: cast_nullable_to_non_nullable
                  as List<BranchItem>,
        selectedBranch: freezed == selectedBranch
            ? _value.selectedBranch
            : selectedBranch // ignore: cast_nullable_to_non_nullable
                  as SelectedBranch?,
        isNavigating: null == isNavigating
            ? _value.isNavigating
            : isNavigating // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$BranchSelectionUiStateImpl implements _BranchSelectionUiState {
  const _$BranchSelectionUiStateImpl({
    final List<BranchItem> branches = const [],
    this.selectedBranch,
    this.isNavigating = false,
  }) : _branches = branches;

  final List<BranchItem> _branches;
  @override
  @JsonKey()
  List<BranchItem> get branches {
    if (_branches is EqualUnmodifiableListView) return _branches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_branches);
  }

  @override
  final SelectedBranch? selectedBranch;
  @override
  @JsonKey()
  final bool isNavigating;

  @override
  String toString() {
    return 'BranchSelectionUiState(branches: $branches, selectedBranch: $selectedBranch, isNavigating: $isNavigating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BranchSelectionUiStateImpl &&
            const DeepCollectionEquality().equals(other._branches, _branches) &&
            (identical(other.selectedBranch, selectedBranch) ||
                other.selectedBranch == selectedBranch) &&
            (identical(other.isNavigating, isNavigating) ||
                other.isNavigating == isNavigating));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_branches),
    selectedBranch,
    isNavigating,
  );

  /// Create a copy of BranchSelectionUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BranchSelectionUiStateImplCopyWith<_$BranchSelectionUiStateImpl>
  get copyWith =>
      __$$BranchSelectionUiStateImplCopyWithImpl<_$BranchSelectionUiStateImpl>(
        this,
        _$identity,
      );
}

abstract class _BranchSelectionUiState implements BranchSelectionUiState {
  const factory _BranchSelectionUiState({
    final List<BranchItem> branches,
    final SelectedBranch? selectedBranch,
    final bool isNavigating,
  }) = _$BranchSelectionUiStateImpl;

  @override
  List<BranchItem> get branches;
  @override
  SelectedBranch? get selectedBranch;
  @override
  bool get isNavigating;

  /// Create a copy of BranchSelectionUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BranchSelectionUiStateImplCopyWith<_$BranchSelectionUiStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
