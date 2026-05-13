import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sensei/core/di/core_providers.dart';
import 'package:sensei/features/auth/di/auth_providers.dart';
import 'package:sensei/features/auth/domain/model/user_model.dart';
import 'package:sensei/features/branch_selection/data/repository/branch_repository_impl.dart';
import 'package:sensei/features/branch_selection/domain/repository/branch_repository.dart';
import 'package:sensei/features/branch_selection/presentation/branch_selection_ui_state.dart';
import 'package:sensei/features/branch_selection/presentation/branch_selection_view_model.dart';

final branchRepositoryProvider = Provider<BranchRepository>((ref) {
  return BranchRepositoryImpl(prefs: ref.watch(sharedPreferencesProvider));
});

/// Holds the current authenticated user, set after login.
final currentUserProvider = StateProvider<UserModel?>((ref) => null);

final branchSelectionViewModelProvider = StateNotifierProvider.autoDispose<
    BranchSelectionViewModel, BranchSelectionUiState>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    throw StateError('No authenticated user for branch selection');
  }
  return BranchSelectionViewModel(
    user: user,
    branchRepository: ref.watch(branchRepositoryProvider),
    appLogger: ref.watch(appLoggerProvider),
  );
});
