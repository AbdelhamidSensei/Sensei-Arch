import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/history_provider.dart';
import '../widgets/history_tile.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(historyListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.history)),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history, size: 64,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
                  const SizedBox(height: AppSpacing.md),
                  Text(AppStrings.noHistory,
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: items.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final item = items[index];
                return HistoryTile(
                  item: item,
                  onTap: () => context.push(Routes.result, extra: {
                    'originalPath': item.originalPath,
                    'resultPath': item.resultPath,
                  }),
                  onDelete: () =>
                      ref.read(historyListProvider.notifier).delete(item.id),
                );
              },
            ),
    );
  }
}
