// ═══════════════════════════════════════════════════════════════════
// FILE:     login_view_model.dart
// LAYER:    presentation (MVVM ViewModel)
// PURPOSE:  Manages the login screen's state and business logic.
//           The screen only draws; this class decides what to draw.
//
// PLAIN ENGLISH:
//   The ViewModel is the "brain" of the screen. It:
//   1. Checks for a saved session on startup (auto-login)
//   2. Calls the login API when the user taps "Login"
//   3. Updates the UI state so the screen reacts (loading, error, success)
//   The screen NEVER calls APIs directly — it talks to the ViewModel.
//
// ANDROID EQUIVALENT:
//   Like a Jetpack ViewModel + StateFlow:
//     class LoginViewModel(
//       private val loginUseCase: LoginUseCase,
//       private val getSavedSessionUseCase: GetSavedSessionUseCase
//     ) : ViewModel() {
//       private val _state = MutableStateFlow(LoginUiState())
//       val state: StateFlow<LoginUiState> = _state.asStateFlow()
//
//       fun login(id: String, pass: String) {
//         viewModelScope.launch {
//           _state.value = _state.value.copy(isLoading = true)
//           when (val result = loginUseCase(id, pass)) {
//             is Resource.Success -> _state.value = _state.value.copy(user = result.data)
//             is Resource.Error -> _state.value = _state.value.copy(error = result.message)
//           }
//         }
//       }
//     }
//
// WHY StateNotifier (not ChangeNotifier)?
//   - StateNotifier holds an IMMUTABLE state (replace the whole object).
//   - ChangeNotifier holds MUTABLE state (mutate fields, call notifyListeners).
//   - StateNotifier is safer (no partial updates) and works better with Riverpod.
//   - Riverpod 2.x uses StateNotifier; Riverpod 3.x uses Notifier (newer API,
//     similar concept). We use StateNotifier for compatibility.
//
// WHY BaseViewModel?
//   BaseViewModel extends StateNotifier and adds:
//   - emit() — updates state with logging
//   - logger — available for debugging
//   All ViewModels extend it to avoid repeating this setup.
//
// WHO CREATES ME:
//   Riverpod provider `loginViewModelProvider` in auth_providers.dart.
//
// WHO USES ME:
//   LoginScreen watches my state and calls my methods.
// ═══════════════════════════════════════════════════════════════════

import 'package:sensei/core/base/base_view_model.dart';
import 'package:sensei/core/domain/domain_error.dart';
import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/core/result/resource.dart';
import 'package:sensei/features/auth/domain/usecase/get_saved_session_use_case.dart';
import 'package:sensei/features/auth/domain/usecase/login_use_case.dart';
import 'package:sensei/features/auth/presentation/login/login_ui_state.dart';

class LoginViewModel extends BaseViewModel<LoginUiState> {
  LoginViewModel({
    required LoginUseCase loginUseCase,
    required GetSavedSessionUseCase getSavedSessionUseCase,
    required AppLogger appLogger,
  })  : _loginUseCase = loginUseCase,
        _getSavedSessionUseCase = getSavedSessionUseCase,
        // 'super(initialState, logger: ...)' calls BaseViewModel's constructor.
        // The initial state has isCheckingSession=true (loading while we check).
        super(const LoginUiState(), logger: appLogger) {
    // Called immediately when the ViewModel is created.
    // Checks if the user was previously logged in.
    logger.d('constructor → checkSavedSession()',
        viewModel: 'LoginViewModel');
    checkSavedSession();
  }

  final LoginUseCase _loginUseCase;
  final GetSavedSessionUseCase _getSavedSessionUseCase;

  /// Check if a saved session exists (auto-login on app restart).
  ///
  /// Flow:
  ///   1. Read session from secure storage
  ///   2. If found → set user in state → screen navigates to branch selection
  ///   3. If not found → set isCheckingSession=false → screen shows login form
  Future<void> checkSavedSession() async {
    logger.d('checkSavedSession() started', viewModel: 'LoginViewModel');
    try {
      final user = await _getSavedSessionUseCase();
      if (user != null) {
        logger.i(
          'checkSavedSession() found user: id=${user.id}, name=${user.name}',
          viewModel: 'LoginViewModel',
        );
        // 'emit()' is from BaseViewModel — sets the new state and logs it.
        // 'state.copyWith(...)' creates a NEW LoginUiState with only the
        // specified fields changed. All other fields keep their current values.
        // Like Kotlin's data class .copy(isCheckingSession = false, user = user)
        emit(state.copyWith(isCheckingSession: false, user: user),
            reason: 'Restored saved session');
      } else {
        logger.d('checkSavedSession() no saved session',
            viewModel: 'LoginViewModel');
        emit(state.copyWith(isCheckingSession: false),
            reason: 'No saved session');
      }
    } catch (e, stack) {
      logger.e(
        'checkSavedSession() EXCEPTION: $e',
        viewModel: 'LoginViewModel',
        error: e,
        stack: stack,
      );
      // Even if checking fails, still show the login form (don't crash).
      emit(state.copyWith(isCheckingSession: false),
          reason: 'Session check failed');
    }
  }

  /// Called when the user taps the "Login" button.
  ///
  /// Flow:
  ///   1. Set isLoading=true (show loading overlay)
  ///   2. Call the login API via UseCase
  ///   3. On success → set user in state → screen navigates
  ///   4. On error → set errorMessage → screen shows AlertDialog
  Future<void> login(String loginId, String password) async {
    logger.d('login() called with loginId=$loginId',
        viewModel: 'LoginViewModel');

    // Show loading overlay, clear any previous error
    emit(state.copyWith(isLoading: true, errorMessage: null),
        reason: 'Login started');

    logger.d('login() calling LoginUseCase...', viewModel: 'LoginViewModel');
    final result = await _loginUseCase(loginId, password);
    logger.d('login() result type=${result.runtimeType}',
        viewModel: 'LoginViewModel');

    // 'switch' on a sealed class — Dart checks all cases at compile time.
    // If you forget a case, the compiler warns you (exhaustiveness check).
    // Like Kotlin's 'when (result) { is Success -> ... is Error -> ... }'
    switch (result) {
      case ResourceSuccess(:final data):
        // ':final data' = destructuring. Extracts the 'data' field from
        // ResourceSuccess and assigns it to a local variable 'data'.
        // Like Kotlin's 'val data = (result as Success).data'
        logger.i(
          'login() SUCCESS: userId=${data.id}, name=${data.name}',
          viewModel: 'LoginViewModel',
        );
        emit(state.copyWith(isLoading: false, user: data),
            reason: 'Login success');

      case ResourceError(:final error):
        final msg = _mapError(error);
        logger.w(
          'login() FAILED: error=${error.runtimeType}, message=$msg',
          viewModel: 'LoginViewModel',
        );
        emit(
          state.copyWith(isLoading: false, errorMessage: msg),
          reason: 'Login failed',
        );

      case ResourceLoading():
        // This shouldn't happen (we don't emit Loading from the repository),
        // but the compiler requires handling all cases.
        logger.d('login() got ResourceLoading (unexpected)',
            viewModel: 'LoginViewModel');
        break;
    }
  }

  /// Converts a DomainError to a user-friendly message.
  ///
  /// This is the ONLY place where error messages are defined.
  /// The UI just displays whatever string it gets — it never sees DomainError.
  String _mapError(DomainError error) {
    // Dart's 'switch expression' — returns a value based on the error type.
    // Like Kotlin's when(error) { is NetworkError -> "No internet" ... }
    return switch (error) {
      NetworkError() => 'No internet connection. Please check your network.',
      ServerError(:final message) =>
        message ?? 'Server error. Please try again.',
      UnauthorizedError() => 'Invalid credentials. Please try again.',
      ValidationError(:final reason) => reason,
      UnknownError() => 'Something went wrong. Please try again.',
    };
  }
}
