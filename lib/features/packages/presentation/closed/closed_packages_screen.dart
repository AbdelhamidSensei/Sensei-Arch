import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sensei/features/packages/di/packages_providers.dart';
import 'package:sensei/features/packages/presentation/closed/closed_packages_ui_state.dart';
import 'package:sensei/features/packages/presentation/widgets/package_card.dart';

class ClosedPackagesScreen extends ConsumerWidget {
  const ClosedPackagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(closedPackagesViewModelProvider);

    ref.listen<ClosedPackagesUiState>(
      closedPackagesViewModelProvider,
      (prev, next) {
        if (next.errorMessage != null &&
            prev?.errorMessage != next.errorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.errorMessage!)),
          );
        }
      },
    );

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(closedPackagesViewModelProvider.notifier).refresh(),
      child: state.isLoading && state.packages.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null && state.packages.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.errorMessage!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref
                              .read(closedPackagesViewModelProvider.notifier)
                              .refresh(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : state.packages.isEmpty
                  ? const Center(child: Text('No closed packages'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: state.packages.length,
                      itemBuilder: (context, index) {
                        final pkg = state.packages[index];
                        final isSending =
                            state.sendingPackageId == pkg.id;
                        return PackageCard(
                          package: pkg,
                          trailing: SizedBox(
                            width: 120,
                            child: ElevatedButton(
                              onPressed: isSending
                                  ? null
                                  : () => ref
                                      .read(closedPackagesViewModelProvider
                                          .notifier)
                                      .sendToShipox(pkg.id),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFB20018),
                                foregroundColor: Colors.white,
                              ),
                              child: isSending
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Send to Shipox'),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
