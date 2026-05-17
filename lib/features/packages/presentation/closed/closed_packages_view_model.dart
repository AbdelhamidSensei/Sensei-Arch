import 'package:sensei/core/base/base_view_model.dart';
import 'package:sensei/core/domain/domain_error.dart';
import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/core/result/resource.dart';
import 'package:sensei/features/packages/domain/usecase/get_packages_use_case.dart';
import 'package:sensei/features/packages/domain/usecase/send_package_use_case.dart';
import 'package:sensei/features/packages/presentation/closed/closed_packages_ui_state.dart';

class ClosedPackagesViewModel extends BaseViewModel<ClosedPackagesUiState> {
  ClosedPackagesViewModel({
    required GetPackagesUseCase getPackagesUseCase,
    required SendPackageUseCase sendPackageUseCase,
    required int companyId,
    required int branchId,
    required AppLogger appLogger,
  })  : _getPackagesUseCase = getPackagesUseCase,
        _sendPackageUseCase = sendPackageUseCase,
        _companyId = companyId,
        _branchId = branchId,
        super(const ClosedPackagesUiState(), logger: appLogger) {
    loadPackages();
  }

  final GetPackagesUseCase _getPackagesUseCase;
  final SendPackageUseCase _sendPackageUseCase;
  final int _companyId;
  final int _branchId;

  /// Status 3 = closed packages
  Future<void> loadPackages() async {
    emit(state.copyWith(isLoading: true, errorMessage: null),
        reason: 'Loading closed packages');

    final result = await _getPackagesUseCase(
      statusId: 3,
      companyId: _companyId,
      branchId: _branchId,
    );

    switch (result) {
      case ResourceSuccess(:final data):
        emit(state.copyWith(isLoading: false, packages: data),
            reason: 'Closed packages loaded');
      case ResourceError(:final error):
        emit(
          state.copyWith(isLoading: false, errorMessage: _mapError(error)),
          reason: 'Closed packages error',
        );
      case ResourceLoading():
        break;
    }
  }

  Future<void> sendToShipox(int packageId) async {
    emit(state.copyWith(sendingPackageId: packageId),
        reason: 'Sending package $packageId');

    final result = await _sendPackageUseCase(packageId);

    switch (result) {
      case ResourceSuccess():
        // Remove sent package from list
        final updated =
            state.packages.where((p) => p.id != packageId).toList();
        emit(
          state.copyWith(sendingPackageId: null, packages: updated),
          reason: 'Package sent successfully',
        );
      case ResourceError(:final error):
        emit(
          state.copyWith(
              sendingPackageId: null, errorMessage: _mapError(error)),
          reason: 'Send package error',
        );
      case ResourceLoading():
        break;
    }
  }

  Future<void> refresh() => loadPackages();

  String _mapError(DomainError error) {
    return switch (error) {
      NetworkError() => 'No internet connection.',
      ServerError(:final message) => message ?? 'Server error.',
      UnauthorizedError() => 'Session expired. Please login again.',
      _ => 'Something went wrong.',
    };
  }
}
