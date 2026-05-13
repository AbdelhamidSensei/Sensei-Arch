import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sensei/features/packages/di/packages_providers.dart';
import 'package:sensei/features/packages/presentation/widgets/package_card.dart';

class OpenPackagesScreen extends ConsumerWidget {
  const OpenPackagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(openPackagesViewModelProvider);

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(openPackagesViewModelProvider.notifier).refresh(),
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
                              .read(openPackagesViewModelProvider.notifier)
                              .refresh(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : state.packages.isEmpty
                  ? const Center(child: Text('No open packages'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: state.packages.length,
                      itemBuilder: (context, index) {
                        final pkg = state.packages[index];
                        return PackageCard(
                          package: pkg,
                          onTap: () =>
                              context.push('/scanner/${pkg.id}'),
                        );
                      },
                    ),
    );
  }
}
