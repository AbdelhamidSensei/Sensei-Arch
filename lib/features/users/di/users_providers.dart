// ═══════════════════════════════════════════════════════════════════
// FILE:     users_providers.dart
// LAYER:    features/users/di (Dependency Injection)
// PURPOSE:  Riverpod providers for the entire users feature — wires
//           together API, DAO, Repository, UseCases, and ViewModels.
//
// PLAIN ENGLISH:
//   This is the "wiring diagram" for the users feature. It tells
//   Riverpod: "to create a UsersListViewModel, you need a UseCase;
//   to create a UseCase, you need a Repository; to create a Repository,
//   you need an API and a DAO." Riverpod resolves this chain for us.
//
// WHO CREATES ME:
//   Dart loads this when any provider in here is first accessed.
//
// WHO USES ME:
//   Screens (via ref.watch) to get ViewModels.
//   Other providers that depend on users feature components.
//
// WHAT I TALK TO:
//   Core providers (dio, logger, database) + feature implementations.
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sensei/core/di/core_providers.dart';
import 'package:sensei/features/users/data/local/dao/users_dao.dart';
import 'package:sensei/features/users/data/local/database/app_database.dart';
import 'package:sensei/features/users/data/remote/api/users_api.dart';
import 'package:sensei/features/users/data/repository/users_repository_impl.dart';
import 'package:sensei/features/users/domain/repository/users_repository.dart';
import 'package:sensei/features/users/domain/usecase/get_user_by_id_use_case.dart';
import 'package:sensei/features/users/domain/usecase/get_users_use_case.dart';
import 'package:sensei/features/users/presentation/detail/user_detail_ui_state.dart';
import 'package:sensei/features/users/presentation/detail/user_detail_view_model.dart';
import 'package:sensei/features/users/presentation/list/users_list_ui_state.dart';
import 'package:sensei/features/users/presentation/list/users_list_view_model.dart';

import 'package:drift/native.dart';

// ──────────────────────────────────────────────────────────────────
// DATABASE
// ──────────────────────────────────────────────────────────────────

/// Provides the Drift database instance.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase(NativeDatabase.memory());
});

/// Provides the [UsersDao] from the database.
final usersDaoProvider = Provider<UsersDao>((ref) {
  return UsersDao(ref.watch(appDatabaseProvider));
});

// ──────────────────────────────────────────────────────────────────
// DATA LAYER
// ──────────────────────────────────────────────────────────────────

/// Provides the Retrofit [UsersApi] for network calls.
final usersApiProvider = Provider<UsersApi>((ref) {
  return UsersApi(ref.watch(dioProvider));
});

/// Provides the [UsersRepository] implementation.
///
/// PLAIN ENGLISH: the recipe for our repository. Notice the return type
/// is the INTERFACE (UsersRepository) — consumers never know they're
/// getting UsersRepositoryImpl. This is dependency inversion in action.
final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepositoryImpl(
    api: ref.watch(usersApiProvider),
    dao: ref.watch(usersDaoProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

// ──────────────────────────────────────────────────────────────────
// DOMAIN LAYER (Use Cases)
// ──────────────────────────────────────────────────────────────────

/// Provides [GetUsersUseCase].
final getUsersUseCaseProvider = Provider<GetUsersUseCase>((ref) {
  return GetUsersUseCase(
    repository: ref.watch(usersRepositoryProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

/// Provides [GetUserByIdUseCase].
final getUserByIdUseCaseProvider = Provider<GetUserByIdUseCase>((ref) {
  return GetUserByIdUseCase(
    repository: ref.watch(usersRepositoryProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

// ──────────────────────────────────────────────────────────────────
// PRESENTATION LAYER (ViewModels)
// ──────────────────────────────────────────────────────────────────

// 'StateNotifierProvider' = like Provider, but for objects that change
// state over time (our ViewModels). The Widget rebuilds when state changes.

/// Provides the [UsersListViewModel] and its [UsersListUiState].
///
/// `.autoDispose` means Riverpod destroys the ViewModel when no screen
/// is watching it anymore — preventing memory leaks.
final usersListViewModelProvider =
    StateNotifierProvider.autoDispose<UsersListViewModel, UsersListUiState>(
  (ref) {
    return UsersListViewModel(
      getUsersUseCase: ref.watch(getUsersUseCaseProvider),
      logger: ref.watch(appLoggerProvider),
    );
  },
);

/// Provides the [UserDetailViewModel] for a specific user ID.
///
/// `.family` creates a separate instance per parameter (userId).
/// So /users/1 and /users/2 each get their own ViewModel.
final userDetailViewModelProvider = StateNotifierProvider.autoDispose
    .family<UserDetailViewModel, UserDetailUiState, int>(
  (ref, userId) {
    return UserDetailViewModel(
      userId: userId,
      getUserByIdUseCase: ref.watch(getUserByIdUseCaseProvider),
      logger: ref.watch(appLoggerProvider),
    );
  },
);
