import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metrogo/l10n/app_localizations.dart';
import '../../../metro_data/presentation/providers/metro_provider.dart';
import '../../../trip_planner/presentation/providers/trip_planner_provider.dart';
import '../../../../core/widgets/line_chip.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';

class StationDetailsPage extends ConsumerWidget {
  final String stationId;

  const StationDetailsPage({super.key, required this.stationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode;
    final stationsAsync = ref.watch(stationsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.stationDetails)),
      body: stationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (stations) {
          final station = stations.firstWhere(
            (s) => s.id == stationId,
            orElse: () => stations.first,
          );
          final isFav = ref.watch(favoritesProvider.notifier).isFavorite(stationId);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  station.nameAr,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  station.nameEn,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                ),
                const SizedBox(height: 16),
                Text(l10n.linesServed,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: station.lineIds
                      .map((id) => LineChip(lineId: id, label: id))
                      .toList(),
                ),
                if (station.isTransfer) ...[
                  const SizedBox(height: 8),
                  Chip(
                    avatar: const Icon(Icons.swap_horiz, size: 18),
                    label: Text(l10n.transfer),
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          ref.read(tripPlannerProvider.notifier).setFromStation(station);
                          context.go('/plan');
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: Text(l10n.planFromHere),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ref.read(tripPlannerProvider.notifier).setToStation(station);
                          context.go('/plan');
                        },
                        icon: const Icon(Icons.flag),
                        label: Text(l10n.planToHere),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () {
                    if (isFav) {
                      // Find and remove
                      final items = ref.read(favoritesProvider);
                      final item = items.firstWhere(
                        (i) => i.stationId == stationId,
                        orElse: () => items.first,
                      );
                      ref.read(favoritesProvider.notifier).remove(item.id);
                    } else {
                      ref.read(favoritesProvider.notifier).addStation(
                            stationId,
                            station.localizedName(lang),
                          );
                    }
                  },
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                  label: Text(
                    isFav ? l10n.removeFromFavorites : l10n.addToFavorites,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
