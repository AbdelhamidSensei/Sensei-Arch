import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sensei/features/auth/domain/model/user_model.dart';
import 'package:sensei/features/branch_selection/domain/model/selected_branch.dart';

part 'branch_selection_ui_state.freezed.dart';

@freezed
class BranchSelectionUiState with _$BranchSelectionUiState {
  const factory BranchSelectionUiState({
    @Default([]) List<BranchItem> branches,
    SelectedBranch? selectedBranch,
    @Default(false) bool isNavigating,
  }) = _BranchSelectionUiState;
}
