import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metrogo/l10n/app_localizations.dart';
import '../providers/favorites_provider.dart';
import '../../../trip_planner/presentation/providers/trip_planner_provider.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.favorites)),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border,
                      size: 64, color: Theme.of(context).disabledColor),
                  const SizedBox(height: 16),
                  Text(l10n.noFavorites),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                return Dismissible(
                  key: ValueKey(item.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    color: Colors.red,
                    padding: const EdgeInsetsDirectional.only(end: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    ref.read(favoritesProvider.notifier).remove(item.id);
                  },
                  child: ListTile(
                    leading: Icon(
                      item.stationId != null ? Icons.train : Icons.route,
                    ),
                    title: Text(item.label),
                    onTap: () {
                      if (item.stationId != null) {
                        context.push('/station/${item.stationId}');
                      } else if (item.fromStationId != null &&
                          item.toStationId != null) {
                        final notifier = ref.read(tripPlannerProvider.notifier);
                        notifier.setFromStationById(item.fromStationId!);
                        notifier.setToStationById(item.toStationId!);
                        context.go('/plan');
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
