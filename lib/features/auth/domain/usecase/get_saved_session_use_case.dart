// ═══════════════════════════════════════════════════════════════════
// FILE:     get_saved_session_use_case.dart
// LAYER:    domain (business logic)
// PURPOSE:  Checks if a previously saved login session exists.
//
// PLAIN ENGLISH:
//   When the app starts, we don't want the user to login every time.
//   This UseCase checks secure storage for a saved session. If found,
//   the user skips the login screen and goes straight to branch selection.
//
// ANDROID EQUIVALENT:
//   class GetSavedSessionUseCase(
//     private val repository: AuthRepository
//   ) {
//     suspend operator fun invoke(): UserModel? {
//       return repository.getSavedSession()
//     }
//   }
//
// WHO CREATES ME:
//   Riverpod provider `getSavedSessionUseCaseProvider`.
//
// WHO USES ME:
//   LoginViewModel calls me in its constructor to check for saved session.
// ═══════════════════════════════════════════════════════════════════

import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/features/auth/domain/model/user_model.dart';
import 'package:sensei/features/auth/domain/repository/auth_repository.dart';

class GetSavedSessionUseCase {
  GetSavedSessionUseCase({
    required AuthRepository repository,
    required AppLogger logger,
  })  : _repository = repository,
        _logger = logger;

  final AuthRepository _repository;
  final AppLogger _logger;

  // Returns UserModel if a saved session exists, null otherwise.
  // The ViewModel uses this to decide: show login form or auto-navigate.
  Future<UserModel?> call() async {
    _logger.d('call() checking saved session',
        useCase: 'GetSavedSessionUseCase');
    final user = await _repository.getSavedSession();
    _logger.d(
      'call() result=${user != null ? "user(id=${user.id})" : "null"}',
      useCase: 'GetSavedSessionUseCase',
    );
    return user;
  }
}
