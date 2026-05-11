// ═══════════════════════════════════════════════════════���═══════════
// FILE:     get_users_use_case.dart
// LAYER:    domain (business logic)
// PURPOSE:  Encapsulates the business rule "fetch the list of users".
//
// PLAIN ENGLISH:
//   A UseCase is a single action the app can perform. This one says
//   "get me all users." Right now it just delegates to the repository,
//   but having it as a separate class means:
//   1. If we need to add business rules later (filtering, sorting,
//      combining with another data source), we add them HERE — not
//      in the ViewModel or Repository.
//   2. It's trivially testable — one class, one responsibility.
//   3. It documents what the app CAN DO as a list of UseCase files.
//
// WHO CREATES ME:
//   The Riverpod provider `getUsersUseCaseProvider` in users_providers.dart.
//
// WHO USES ME:
//   UsersListViewModel calls my `call()` method.
//
// WHAT I TALK TO:
//   UsersRepository (interface) — never the implementation directly.
//   AppLogger — logs entry and exit.
//
// FULL DATA FLOW THROUGH ME:
//   ViewModel → [ME: UseCase] → Repository(interface) → ...data layer
// ════════════════════════════════════════��══════════════════════════

import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/core/result/resource.dart';
import 'package:sensei/features/users/domain/model/user.dart';
import 'package:sensei/features/users/domain/repository/users_repository.dart';

// ┌─ WHY USE CASES EXIST ──────────────────���─────────────────────
// │ "Why not call the repository directly from the ViewModel?"
// │ You could — and for simple CRUD it feels like overkill. But:
// │  1. Business rules accumulate. Sorting? Pagination? Merge two
// │     sources? Those belong in a UseCase, not the ViewModel.
// │  2. Multiple ViewModels may need the same data with the same
// │     rules — the UseCase is the single source of that logic.
// │  3. Testing is simpler: test the rule in isolation from the UI.
// │ Think of UseCases as "what the app can do" — a menu of actions.
// └──────────────���───────────────────────────────────────────────

/// Fetches the complete list of users.
///
/// PLAIN ENGLISH: the "get all users" action. Call it like a function:
/// `getUsersUseCase()` (Dart lets us call objects with `call()`).
///
/// Called by: UsersListViewModel.
/// Calls: [UsersRepository.getUsers], [AppLogger].
class GetUsersUseCase {
  GetUsersUseCase({
    required UsersRepository repository,
    required AppLogger logger,
  })  : _repository = repository,
        _logger = logger;

  final UsersRepository _repository;
  final AppLogger _logger;

  /// Executes the use case — fetches all users.
  ///
  /// PLAIN ENGLISH: the single public method. In Kotlin you'd use
  /// `operator fun invoke()` — in Dart we name it `call()` which
  /// lets you invoke the object directly: `useCase()`.
  ///
  /// Returns a [Stream] of [Resource] wrapping a list of [User]s.
  Stream<Resource<List<User>>> call() {
    _logger.d('GetUsersUseCase invoked', useCase: 'GetUsersUseCase');
    // → Calls into DOMAIN layer (Repository interface).
    return _repository.getUsers();
  }
}
