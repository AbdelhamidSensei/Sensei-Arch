import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sensei/core/di/core_providers.dart';
import 'package:sensei/features/branch_selection/di/branch_selection_providers.dart';
import 'package:sensei/features/packages/data/remote/api/packages_api.dart';
import 'package:sensei/features/packages/data/repository/packages_repository_impl.dart';
import 'package:sensei/features/packages/domain/repository/packages_repository.dart';
import 'package:sensei/features/packages/domain/usecase/add_sample_use_case.dart';
import 'package:sensei/features/packages/domain/usecase/close_package_use_case.dart';
import 'package:sensei/features/packages/domain/usecase/get_packages_use_case.dart';
import 'package:sensei/features/packages/domain/usecase/send_package_use_case.dart';
import 'package:sensei/features/packages/presentation/closed/closed_packages_ui_state.dart';
import 'package:sensei/features/packages/presentation/closed/closed_packages_view_model.dart';
import 'package:sensei/features/packages/presentation/open/open_packages_ui_state.dart';
import 'package:sensei/features/packages/presentation/open/open_packages_view_model.dart';
import 'package:sensei/features/packages/presentation/scanner/scanner_ui_state.dart';
import 'package:sensei/features/packages/presentation/scanner/scanner_view_model.dart';

final packagesApiProvider = Provider<PackagesApi>((ref) {
  return PackagesApi(dio: ref.watch(dioProvider));
});

final packagesRepositoryProvider = Provider<PackagesRepository>((ref) {
  return PackagesRepositoryImpl(api: ref.watch(packagesApiProvider));
});

final getPackagesUseCaseProvider = Provider<GetPackagesUseCase>((ref) {
  return GetPackagesUseCase(repository: ref.watch(packagesRepositoryProvider));
});

final addSampleUseCaseProvider = Provider<AddSampleUseCase>((ref) {
  return AddSampleUseCase(repository: ref.watch(packagesRepositoryProvider));
});

final closePackageUseCaseProvider = Provider<ClosePackageUseCase>((ref) {
  return ClosePackageUseCase(repository: ref.watch(packagesRepositoryProvider));
});

final sendPackageUseCaseProvider = Provider<SendPackageUseCase>((ref) {
  return SendPackageUseCase(repository: ref.watch(packagesRepositoryProvider));
});

final openPackagesViewModelProvider = StateNotifierProvider.autoDispose<
    OpenPackagesViewModel, OpenPackagesUiState>((ref) {
  final branch = ref.watch(selectedBranchProvider);
  return OpenPackagesViewModel(
    getPackagesUseCase: ref.watch(getPackagesUseCaseProvider),
    companyId: branch?.companyID ?? 0,
    branchId: branch?.branchID ?? 0,
    appLogger: ref.watch(appLoggerProvider),
  );
});

final closedPackagesViewModelProvider = StateNotifierProvider.autoDispose<
    ClosedPackagesViewModel, ClosedPackagesUiState>((ref) {
  final branch = ref.watch(selectedBranchProvider);
  return ClosedPackagesViewModel(
    getPackagesUseCase: ref.watch(getPackagesUseCaseProvider),
    sendPackageUseCase: ref.watch(sendPackageUseCaseProvider),
    companyId: branch?.companyID ?? 0,
    branchId: branch?.branchID ?? 0,
    appLogger: ref.watch(appLoggerProvider),
  );
});

final scannerViewModelProvider = StateNotifierProvider.autoDispose
    .family<ScannerViewModel, ScannerUiState, int>((ref, packageId) {
  return ScannerViewModel(
    packageId: packageId,
    addSampleUseCase: ref.watch(addSampleUseCaseProvider),
    closePackageUseCase: ref.watch(closePackageUseCaseProvider),
    appLogger: ref.watch(appLoggerProvider),
  );
});
