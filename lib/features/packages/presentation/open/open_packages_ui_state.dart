import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sensei/features/packages/domain/model/package_model.dart';

part 'open_packages_ui_state.freezed.dart';

@freezed
class OpenPackagesUiState with _$OpenPackagesUiState {
  const factory OpenPackagesUiState({
    @Default(false) bool isLoading,
    @Default([]) List<PackageModel> packages,
    String? errorMessage,
  }) = _OpenPackagesUiState;
}
