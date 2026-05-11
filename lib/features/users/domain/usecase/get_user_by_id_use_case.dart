// ═══════════���════════════════════════════════��══════════════════════
// FILE:     get_user_by_id_use_case.dart
// LAYER:    domain (business logic)
// PURPOSE:  Encapsulates the business rule "fetch a single user by ID".
//
// PLAIN ENGLISH:
//   When the user taps a row in the list, we need that specific user's
//   full details. This UseCase handles that single responsibility.
//
// WHO CREATES ME:
//   Riverpod provider `getUserByIdUseCaseProvider` in users_providers.dart.
//
// WHO USES ME:
//   UserDetailViewModel calls my `call(id)` method.
//
// WHAT I TALK TO:
//   UsersRepository (interface), AppLogger.
// ═════════════��═════════════════════════════════════════════════════

import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/core/result/resource.dart';
import 'package:sensei/features/users/domain/model/user.dart';
import 'package:sensei/features/users/domain/repository/users_repository.dart';

/// Fetches a single user by their unique ID.
///
/// PLAIN ENGLISH: the "show user details" action.
///
/// Called by: UserDetailViewModel.
/// Calls: [UsersRepository.getUserById], [AppLogger].
class GetUserByIdUseCase {
  GetUserByIdUseCase({
    required UsersRepository repository,
    required AppLogger logger,
  })  : _repository = repository,
        _logger = logger;

  final UsersRepository _repository;
  final AppLogger _logger;

  /// Executes the use case for a given [userId].
  ///
  /// [userId] — the unique identifier of the user to fetch.
  /// Returns a [Stream] of [Resource] wrapping a single [User].
  Stream<Resource<User>> call(int userId) {
    _logger.d('GetUserByIdUseCase invoked (id=$userId)', useCase: 'GetUserByIdUseCase');
    // → Calls into DOMAIN layer (Repository interface).
    return _repository.getUserById(userId);
  }
}
