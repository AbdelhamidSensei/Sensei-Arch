import 'package:freezed_annotation/freezed_annotation.dart';

part 'selected_branch.freezed.dart';
part 'selected_branch.g.dart';

@freezed
class SelectedBranch with _$SelectedBranch {
  const factory SelectedBranch({
    required int companyID,
    required int branchID,
    required String branchName,
  }) = _SelectedBranch;

  factory SelectedBranch.fromJson(Map<String, dynamic> json) =>
      _$SelectedBranchFromJson(json);
}
