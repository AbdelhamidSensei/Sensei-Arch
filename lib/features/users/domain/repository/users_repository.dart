// ═══════════��═══════════════════════════════════��═══════════════════
// FILE:     users_repository.dart
// LAYER:    domain (repository INTERFACE — not the implementation!)
// PURPOSE:  Defines the contract for getting user data, without knowing
//           WHERE the data comes from (network? database? both?).
//
// PLAIN ENGLISH:
//   The domain layer says "I need user data" but doesn't care HOW
//   you get it. This interface is that request. The data layer
//   provides the actual implementation (API + database).
//   This is called the "Dependency Inversion Principle" — domain
//   defines the contract, data fulfills it.
//
// WHO CREATES ME:
//   Nobody creates an interface — UsersRepositoryImpl implements it.
//
// WHO USES ME:
//   UseCases depend on this interface (not the implementation).
//
// WHAT I TALK TO:
//   Nothing — I'm a contract.
// ══════════���═════════════════════════════════════════════════════���══

import 'package:sensei/core/result/resource.dart';
import 'package:sensei/features/users/domain/model/user.dart';

// ┌─ WHY REPOSITORY INTERFACE IN DOMAIN ─────────────────────────
// │ If the UseCase imported the RepositoryImpl directly, it would
// │ depend on Dio, Drift, and the entire data layer — breaking the
// │ dependency rule (domain must not know about data).
// │ By depending on this INTERFACE, the domain stays pure. In tests
// │ we can pass a fake repository. The real impl is injected at
// │ runtime via Riverpod. This is "Dependency Inversion" — the D
// │ in SOLID.
// └─────────��──────────────────────���─────────────────────────────

/// Contract for accessing user data from any source.
///
/// PLAIN ENGLISH: "I need users. I don't care if they come from the
/// internet, a database, or a magic hat — just give them to me as
/// a Stream of Resource so I know when you're loading, done, or failed."
///
/// Called by: GetUsersUseCase, GetUserByIdUseCase.
/// Calls: nothing (interface).
abstract class UsersRepository {
  /// Fetches all users. Emits loading → cache (if any) → network result.
  ///
  /// Returns a [Stream] because data may arrive in stages (cache first,
  /// then fresh network data).
  // 'Stream<T>' = many values arriving over time (Kotlin's Flow).
  // Use 'await for' or '.listen' to consume.
  Stream<Resource<List<User>>> getUsers();

  /// Fetches a single user by their [id].
  ///
  /// [id] — the unique identifier of the user.
  Stream<Resource<User>> getUserById(int id);
}
