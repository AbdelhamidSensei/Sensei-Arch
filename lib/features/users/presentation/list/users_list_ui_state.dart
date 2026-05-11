// ═══════════════════════════════════════════════════════════════════
// FILE:     users_list_ui_state.dart
// LAYER:    presentation (the "State" in MVVM)
// PURPOSE:  A single immutable object describing everything the users
//           list screen needs to render itself.
//
// PLAIN ENGLISH:
//   Instead of having separate variables for `isLoading`, `users`,
//   `errorMessage` scattered around, we bundle them into ONE object.
//   The screen says "give me the current state" and it gets everything
//   it needs in one shot. Immutability means we create a NEW state
//   object for every change — this makes state changes predictable
//   and debuggable (you can log every transition).
//
// WHO CREATES ME:
//   UsersListViewModel creates and emits new instances via `copyWith`.
//
// WHO USES ME:
//   UsersListScreen reads my fields to decide what to draw.
//
// WHAT I TALK TO:
//   User (domain model) — I hold a list of them.
// ═══════════════════════════════════════════════════════════════════

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:sensei/features/users/domain/model/user.dart';

part 'users_list_ui_state.freezed.dart';

// ┌─ WHY UiState AS A SINGLE OBJECT ────────────────────────────
// │ If you have `bool isLoading`, `List<User> users`, and
// │ `String? error` as separate fields, it's possible to have
// │ `isLoading = true` AND `error != null` simultaneously — an
// │ impossible state that leads to bugs. One @freezed object with
// │ all fields means we control valid combinations explicitly.
// │ Plus, `copyWith` makes partial updates clean and readable.
// └──────────────────────────────────────────────────────────────

/// The complete UI state for the users list screen.
///
/// PLAIN ENGLISH: one object = one snapshot of the screen's reality.
/// The ViewModel updates this, and the screen redraws accordingly.
///
/// Called by: UsersListViewModel creates/updates instances.
/// Calls: nothing — pure data.
@freezed
class UsersListUiState with _$UsersListUiState {
  /// Creates a [UsersListUiState] with sensible defaults.
  ///
  /// [isLoading] — true when data is being fetched.
  /// [users] — the list of users to display (empty by default).
  /// [errorMessage] — non-null when an error should be shown.
  const factory UsersListUiState({
    // '@Default(false)' = if not provided, defaults to false.
    @Default(false) bool isLoading,
    @Default(<User>[]) List<User> users,
    // 'String?' = a String OR null (see secure_storage.dart for explanation).
    String? errorMessage,
  }) = _UsersListUiState;
}
