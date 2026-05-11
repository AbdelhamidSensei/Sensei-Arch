// ═══════════════════════════════════════════════════════════════════
// FILE:     user_detail_ui_state.dart
// LAYER:    presentation
// PURPOSE:  The UiState for the user detail screen.
//
// PLAIN ENGLISH:
//   Same concept as UsersListUiState but for the detail page.
//   Holds the single user's data (or loading/error status).
//
// WHO CREATES ME:
//   UserDetailViewModel creates and updates instances.
//
// WHO USES ME:
//   UserDetailScreen reads my fields to render the detail view.
// ═══════════════════════════════════════════════════════════════════

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:sensei/features/users/domain/model/user.dart';

part 'user_detail_ui_state.freezed.dart';

/// The complete UI state for the user detail screen.
///
/// PLAIN ENGLISH: one snapshot of what the detail screen should show.
///
/// Called by: UserDetailViewModel.
/// Calls: nothing — pure data.
@freezed
class UserDetailUiState with _$UserDetailUiState {
  const factory UserDetailUiState({
    @Default(false) bool isLoading,
    User? user,
    String? errorMessage,
  }) = _UserDetailUiState;
}
