import 'package:freezed_annotation/freezed_annotation.dart';

part 'scanner_ui_state.freezed.dart';

@freezed
class ScannerUiState with _$ScannerUiState {
  const factory ScannerUiState({
    @Default(false) bool isProcessing,
    String? lastScannedBarcode,
    String? message,
    @Default(false) bool isClosed,
  }) = _ScannerUiState;
}
