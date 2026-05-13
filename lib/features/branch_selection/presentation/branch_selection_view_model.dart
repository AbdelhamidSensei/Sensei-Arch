import 'package:sensei/core/base/base_view_model.dart';
import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/features/auth/domain/model/user_model.dart';
import 'package:sensei/features/branch_selection/domain/model/selected_branch.dart';
import 'package:sensei/features/branch_selection/domain/repository/branch_repository.dart';
import 'package:sensei/features/branch_selection/presentation/branch_selection_ui_state.dart';

class BranchSelectionViewModel
    extends BaseViewModel<BranchSelectionUiState> {
  BranchSelectionViewModel({
    required UserModel user,
    required BranchRepository branchRepository,
    required AppLogger appLogger,
  })  : _user = user,
        _branchRepository = branchRepository,
        super(const BranchSelectionUiState(), logger: appLogger) {
    _loadBranches();
  }

  final UserModel _user;
  final BranchRepository _branchRepository;

  Future<void> _loadBranches() async {
    // Flatten all branches from all companies
    final allBranches = <BranchItem>[];
    for (final cb in _user.companiesBranches) {
      allBranches.addAll(cb.branchesList);
    }
    emit(state.copyWith(branches: allBranches), reason: 'Branches loaded');

    // Check for saved branch
    final saved = await _branchRepository.getSavedBranch();
    if (saved != null) {
      emit(state.copyWith(selectedBranch: saved, isNavigating: true),
          reason: 'Restored saved branch');
    }
  }

  void selectBranch(BranchItem branch) {
    // Find the company for this branch
    int companyID = 0;
    for (final cb in _user.companiesBranches) {
      if (cb.branchesList.any((b) => b.id == branch.id)) {
        companyID = cb.companyID;
        break;
      }
    }

    final selected = SelectedBranch(
      companyID: companyID,
      branchID: branch.id,
      branchName: branch.name,
    );
    emit(state.copyWith(selectedBranch: selected), reason: 'Branch selected');
  }

  Future<void> confirmSelection() async {
    final branch = state.selectedBranch;
    if (branch == null) return;

    await _branchRepository.saveBranch(branch);
    emit(state.copyWith(isNavigating: true), reason: 'Branch confirmed');
  }
}
