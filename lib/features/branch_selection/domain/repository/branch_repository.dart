import 'package:sensei/features/branch_selection/domain/model/selected_branch.dart';

abstract class BranchRepository {
  Future<void> saveBranch(SelectedBranch branch);
  Future<SelectedBranch?> getSavedBranch();
  Future<void> clearBranch();
}
