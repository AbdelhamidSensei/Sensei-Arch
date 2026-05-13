import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:sensei/features/packages/di/packages_providers.dart';
import 'package:sensei/features/packages/presentation/scanner/scanner_ui_state.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key, required this.packageId});

  final int packageId;

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  MobileScannerController? _controller;
  final _manualController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _controller?.dispose();
    _manualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = scannerViewModelProvider(widget.packageId);
    final state = ref.watch(provider);

    ref.listen<ScannerUiState>(provider, (prev, next) {
      if (next.message != null && prev?.message != next.message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message!)),
        );
      }
      if (next.isClosed && prev?.isClosed != true) {
        context.pop();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Package #${widget.packageId}'),
        actions: [
          TextButton(
            onPressed: state.isProcessing
                ? null
                : () => ref.read(provider.notifier).closePackage(),
            child: const Text(
              'Send & Close',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Scanner area
          Expanded(
            flex: 3,
            child: _controller != null
                ? MobileScanner(
                    controller: _controller!,
                    onDetect: (capture) {
                      final barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty && !state.isProcessing) {
                        final value = barcodes.first.rawValue;
                        if (value != null && value.isNotEmpty) {
                          ref.read(provider.notifier).addSample(value);
                        }
                      }
                    },
                  )
                : const Center(child: Text('Camera not available')),
          ),
          // Manual entry + status
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (state.lastScannedBarcode != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Last scanned: ${state.lastScannedBarcode}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _manualController,
                          decoration: const InputDecoration(
                            labelText: 'Manual barcode entry',
                            border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _addManualBarcode(provider),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: state.isProcessing
                            ? null
                            : () => _addManualBarcode(provider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB20018),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 48),
                        ),
                        child: state.isProcessing
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Add Sample'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addManualBarcode(dynamic provider) {
    final barcode = _manualController.text.trim();
    if (barcode.isEmpty) return;
    ref.read(provider.notifier).addSample(barcode);
    _manualController.clear();
  }
}
