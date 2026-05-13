import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sensei/features/packages/domain/model/package_model.dart';

part 'closed_packages_ui_state.freezed.dart';

@freezed
class ClosedPackagesUiState with _$ClosedPackagesUiState {
  const factory ClosedPackagesUiState({
    @Default(false) bool isLoading,
    @Default([]) List<PackageModel> packages,
    String? errorMessage,
    int? sendingPackageId,
  }) = _ClosedPackagesUiState;
}
