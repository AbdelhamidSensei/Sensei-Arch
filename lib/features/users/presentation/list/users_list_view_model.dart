// ═══════════════════════════════════════════════════════════════════
// FILE:     users_list_view_model.dart
// LAYER:    presentation (the "View-Model" in MVVM)
// PURPOSE:  Holds the state for the users-list screen and decides
//           what happens when the user opens the screen or taps retry.
//
// PLAIN ENGLISH:
//   This is the "brain" behind the users list screen. The Screen
//   (View) only knows how to draw pixels — this file decides WHAT
//   to draw and reacts to user taps.
//
// WHO CREATES ME:
//   The Riverpod provider `usersListViewModelProvider` in
//   `features/users/di/users_providers.dart` builds me when the
//   Screen first asks for me via `ref.watch(...)`.
//
// WHO USES ME:
//   `users_list_screen.dart` watches my `state` and calls my methods.
//
// WHAT I TALK TO (my dependencies):
//   ⤵ GetUsersUseCase  → domain/usecase/get_users_use_case.dart
//   ⤵ AppLogger        → core/logger/app_logger.dart
//
// FULL DATA FLOW THROUGH ME:
//   Screen → [me: ViewModel] → UseCase → Repository → Api → Network
//   Network → Api → Repository → UseCase → [me: ViewModel] → Screen
// ═══════════════════════════════════════════════════════════════════

import 'dart:async';

import 'package:sensei/core/base/base_view_model.dart';
import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/core/result/resource.dart';
import 'package:sensei/features/users/domain/usecase/get_users_use_case.dart';
import 'package:sensei/features/users/presentation/list/users_list_ui_state.dart';

/// ViewModel for the users list screen.
///
/// PLAIN ENGLISH: the brain of the users list. It calls the UseCase,
/// listens to the Resource stream, and updates the UiState which
/// triggers the screen to redraw.
///
/// Called by: the Screen watches my state via Riverpod.
/// Calls: [GetUsersUseCase], [AppLogger].
class UsersListViewModel extends BaseViewModel<UsersListUiState> {
  UsersListViewModel({
    required GetUsersUseCase getUsersUseCase,
    required AppLogger logger,
  })  : _getUsersUseCase = getUsersUseCase,
        super(const UsersListUiState(), logger: logger) {
    // Automatically load users when the ViewModel is created.
    loadUsers();
  }

  final GetUsersUseCase _getUsersUseCase;

  /// Subscription to the users stream — stored so we can cancel it.
  StreamSubscription<Resource<List<dynamic>>>? _subscription;

  /// Fetches the users list from the data layer.
  ///
  /// PLAIN ENGLISH: kicks off the data fetch. The UseCase returns a Stream
  /// that emits loading → cache → network results. We listen to each
  /// emission and update the screen state accordingly.
  ///
  /// Called by: constructor (initial load) and [refresh] (retry button).
  void loadUsers() {
    logger.d('loadUsers() invoked', viewModel: 'UsersListViewModel');

    // Cancel any previous subscription to avoid duplicate streams.
    _subscription?.cancel();

    // → Calls into DOMAIN layer (UseCase).
    _subscription = _getUsersUseCase.call().listen(
      (resource) {
        // Pattern-match on the Resource to update UI state.
        switch (resource) {
          case ResourceLoading():
            emit(
              state.copyWith(isLoading: true, errorMessage: null),
              reason: 'Loading started',
            );
            // 'copyWith' makes a new object copying all fields, replacing
            // only the ones you pass. Comes free with @freezed.

          case ResourceSuccess(data: final users):
            emit(
              state.copyWith(
                isLoading: false,
                users: users,
                errorMessage: null,
              ),
              reason: 'Users loaded (${users.length})',
            );

          case ResourceError(error: final domainError):
            final message = _mapErrorToMessage(domainError);
            emit(
              state.copyWith(isLoading: false, errorMessage: message),
              reason: 'Error: $message',
            );
        }
      },
      onError: (Object error) {
        logger.e('Unexpected stream error', viewModel: 'UsersListViewModel', error: error);
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'An unexpected error occurred.',
          ),
          reason: 'Unexpected error',
        );
      },
    );
  }

  /// Called when the user taps the retry button.
  ///
  /// PLAIN ENGLISH: same as initial load — try again from scratch.
  void refresh() {
    logger.d('refresh() invoked', viewModel: 'UsersListViewModel');
    loadUsers();
  }

  /// Converts a DomainError into a user-friendly message.
  String _mapErrorToMessage(dynamic error) {
    return switch (error.runtimeType.toString()) {
      'NetworkError' => 'No internet connection. Please check your network.',
      'UnauthorizedError' => 'Session expired. Please log in again.',
      'ServerError' => 'Server error. Please try again later.',
      _ => 'Something went wrong. Please try again.',
    };
  }

  // 'dispose' is called by Riverpod when this ViewModel is no longer needed
  // (e.g., the screen is popped off the navigation stack).
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
