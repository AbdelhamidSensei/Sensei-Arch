import 'package:sensei/core/base/base_view_model.dart';
import 'package:sensei/core/domain/domain_error.dart';
import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/core/result/resource.dart';
import 'package:sensei/features/packages/domain/usecase/get_packages_use_case.dart';
import 'package:sensei/features/packages/presentation/open/open_packages_ui_state.dart';

class OpenPackagesViewModel extends BaseViewModel<OpenPackagesUiState> {
  OpenPackagesViewModel({
    required GetPackagesUseCase getPackagesUseCase,
    required AppLogger appLogger,
  })  : _getPackagesUseCase = getPackagesUseCase,
        super(const OpenPackagesUiState(), logger: appLogger) {
    loadPackages();
  }

  final GetPackagesUseCase _getPackagesUseCase;

  /// Status 1 = open packages
  Future<void> loadPackages() async {
    emit(state.copyWith(isLoading: true, errorMessage: null),
        reason: 'Loading open packages');

    final result = await _getPackagesUseCase(1);

    switch (result) {
      case ResourceSuccess(:final data):
        emit(state.copyWith(isLoading: false, packages: data),
            reason: 'Open packages loaded');
      case ResourceError(:final error):
        emit(
          state.copyWith(isLoading: false, errorMessage: _mapError(error)),
          reason: 'Open packages error',
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
