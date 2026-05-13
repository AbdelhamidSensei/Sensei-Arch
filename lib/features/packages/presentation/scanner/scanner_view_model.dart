import 'package:sensei/core/base/base_view_model.dart';
import 'package:sensei/core/domain/domain_error.dart';
import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/core/result/resource.dart';
import 'package:sensei/features/packages/domain/usecase/add_sample_use_case.dart';
import 'package:sensei/features/packages/domain/usecase/close_package_use_case.dart';
import 'package:sensei/features/packages/presentation/scanner/scanner_ui_state.dart';

class ScannerViewModel extends BaseViewModel<ScannerUiState> {
  ScannerViewModel({
    required int packageId,
    required AddSampleUseCase addSampleUseCase,
    required ClosePackageUseCase closePackageUseCase,
    required AppLogger appLogger,
  })  : _packageId = packageId,
        _addSampleUseCase = addSampleUseCase,
        _closePackageUseCase = closePackageUseCase,
        super(const ScannerUiState(), logger: appLogger);

  final int _packageId;
  final AddSampleUseCase _addSampleUseCase;
  final ClosePackageUseCase _closePackageUseCase;

  Future<void> addSample(String barcode) async {
    if (barcode.trim().isEmpty) return;

    emit(
      state.copyWith(isProcessing: true, message: null, lastScannedBarcode: barcode),
      reason: 'Adding sample',
    );

    final result = await _addSampleUseCase(_packageId, barcode.trim());

    switch (result) {
      case ResourceSuccess():
        emit(
          state.copyWith(isProcessing: false, message: 'Sample added: $barcode'),
          reason: 'Sample added',
        );
      case ResourceError(:final error):
        emit(
          state.copyWith(isProcessing: false, message: _mapError(error)),
          reason: 'Add sample error',
        );
      case ResourceLoading():
        break;
    }
  }

  Future<void> closePackage() async {
    emit(state.copyWith(isProcessing: true, message: null),
        reason: 'Closing package');

    final result = await _closePackageUseCase(_packageId);

    switch (result) {
      case ResourceSuccess():
        emit(
          state.copyWith(
              isProcessing: false, isClosed: true, message: 'Package closed'),
          reason: 'Package closed',
        );
      case ResourceError(:final error):
        emit(
          state.copyWith(isProcessing: false, message: _mapError(error)),
          reason: 'Close package error',
        );
      case ResourceLoading():
        break;
    }
  }

  String _mapError(DomainError error) {
    return switch (error) {
      NetworkError() => 'No internet connection.',
      ServerError(:final message) => message ?? 'Server error.',
      UnauthorizedError() => 'Session expired. Please login again.',
      _ => 'Something went wrong.',
    };
  }
}
