// ═══════════════════════════════════════════════════════════════════
// FILE:     login_ui_state.dart
// LAYER:    presentation (UI state)
// PURPOSE:  A single immutable object that describes EVERYTHING the
//           login screen needs to render itself.
//
// PLAIN ENGLISH:
//   Instead of having separate variables like:
//     bool isLoading = false;
//     String? error = null;
//     UserModel? user = null;
//   We combine them into ONE object. The screen reads this object
//   and draws itself accordingly. When anything changes, a NEW object
//   is created (the old one is never modified — immutability).
//
// ANDROID EQUIVALENT:
//   Like a Kotlin data class used as UI state in a ViewModel:
//     data class LoginUiState(
//       val isLoading: Boolean = false,
//       val isCheckingSession: Boolean = true,
//       val errorMessage: String? = null,
//       val user: UserModel? = null
//     )
//
// WHY A SINGLE STATE OBJECT (not separate StateFlows)?
//   1. Consistency — impossible to have isLoading=true AND error="msg"
//      AND user=valid all at once (you control the transitions).
//   2. Atomic updates — the UI gets one notification per state change,
//      not multiple partial updates that cause flickering.
//   3. Debugging — print the state and see EVERYTHING at a glance.
//   4. Time travel — save old states, replay them for debugging.
//
// WHY @freezed?
//   Generates copyWith() so we can create new states easily:
//     emit(state.copyWith(isLoading: true, errorMessage: null))
//   Without freezed, we'd manually write a constructor with all fields.
//
// STATE TRANSITIONS:
//   Initial:     isCheckingSession=true, isLoading=false, error=null, user=null
//   No session:  isCheckingSession=false
//   Logging in:  isLoading=true, error=null
//   Success:     isLoading=false, user=UserModel
//   Error:       isLoading=false, error="message"
//
// WHO CREATES ME:
//   LoginViewModel creates and emits new instances.
//
// WHO USES ME:
//   LoginScreen reads me via ref.watch(loginViewModelProvider).
// ═══════════════════════════════════════════════════════════════════

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sensei/features/auth/domain/model/user_model.dart';

part 'login_ui_state.freezed.dart';

@freezed
class LoginUiState with _$LoginUiState {
  const factory LoginUiState({
    // Is the login API call in progress? Shows full-screen loading overlay.
    @Default(false) bool isLoading,

    // Are we checking for a saved session? Shows splash/loading on first load.
    // Starts as true, set to false once we finish checking.
    @Default(true) bool isCheckingSession,

    // Error message to show in an AlertDialog. Null = no error.
    String? errorMessage,

    // The logged-in user. Null = not logged in.
    // When this becomes non-null, the screen navigates to branch selection.
    UserModel? user,
  }) = _LoginUiState;
  // '_LoginUiState' is the generated implementation class.
  // We never use it directly — always use 'LoginUiState'.
}
