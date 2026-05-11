// ═══════════════════════════════════════════════════════════════════
// FILE:     user_detail_view_model.dart
// LAYER:    presentation (ViewModel)
// PURPOSE:  Manages state for the user detail screen.
//
// PLAIN ENGLISH:
//   Same pattern as UsersListViewModel but for a single user.
//   It receives the user ID, fetches that user's data, and updates
//   the detail screen's state.
//
// WHO CREATES ME:
//   The family provider `userDetailViewModelProvider` creates one
//   instance per user ID.
//
// WHO USES ME:
//   UserDetailScreen watches my state.
//
// WHAT I TALK TO:
//   ⤵ GetUserByIdUseCase → fetches single user.
//   ⤵ AppLogger → logs transitions.
// ═══════════════════════════════════════════════════════════════════

import 'dart:async';

import 'package:sensei/core/base/base_view_model.dart';
import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/core/result/resource.dart';
import 'package:sensei/features/users/domain/usecase/get_user_by_id_use_case.dart';
import 'package:sensei/features/users/presentation/detail/user_detail_ui_state.dart';

/// ViewModel for the user detail screen.
///
/// PLAIN ENGLISH: the brain behind the detail page. Fetches one user
/// by ID and keeps the screen's state up to date.
///
/// Called by: Riverpod (created via family provider with userId).
/// Calls: [GetUserByIdUseCase], [AppLogger].
class UserDetailViewModel extends BaseViewModel<UserDetailUiState> {
  UserDetailViewModel({
    required int userId,
    required GetUserByIdUseCase getUserByIdUseCase,
    required AppLogger logger,
  })  : _userId = userId,
        _getUserByIdUseCase = getUserByIdUseCase,
        super(const UserDetailUiState(), logger: logger) {
    loadUser();
  }

  final int _userId;
  final GetUserByIdUseCase _getUserByIdUseCase;
  StreamSubscription<Resource<dynamic>>? _subscription;

  /// Fetches the user by ID.
  void loadUser() {
    logger.d('loadUser(id=$_userId)', viewModel: 'UserDetailViewModel');
    _subscription?.cancel();

    // → Calls into DOMAIN layer (UseCase).
    _subscription = _getUserByIdUseCase.call(_userId).listen(
      (resource) {
        switch (resource) {
          case ResourceLoading():
            emit(
              state.copyWith(isLoading: true, errorMessage: null),
              reason: 'Loading user $_userId',
            );
          case ResourceSuccess(data: final user):
            emit(
              state.copyWith(isLoading: false, user: user, errorMessage: null),
              reason: 'User $_userId loaded',
            );
          case ResourceError(error: final domainError):
            emit(
              state.copyWith(
                isLoading: false,
                errorMessage: 'Failed to load user: $domainError',
              ),
              reason: 'Error loading user $_userId',
            );
        }
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
