import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metrogo/l10n/app_localizations.dart';
import '../providers/history_provider.dart';
import '../../../metro_data/presentation/providers/metro_provider.dart';
import '../../../trip_planner/presentation/providers/trip_planner_provider.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final history = ref.watch(historyProvider);
    final stationsAsync = ref.watch(stationsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.history)),
      body: history.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history,
                      size: 64, color: Theme.of(context).disabledColor),
                  const SizedBox(height: 16),
                  Text(l10n.noHistory),
                ],
              ),
            )
          : stationsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (stations) {
                final stationMap = {for (final s in stations) s.id: s};
                final locale = Localizations.localeOf(context);
                return ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    final from = stationMap[item.fromStationId];
                    final to = stationMap[item.toStationId];
                    return ListTile(
                      leading: const Icon(Icons.route),
                      title: Text(
                        '${from?.localizedName(locale.languageCode) ?? item.fromStationId} → ${to?.localizedName(locale.languageCode) ?? item.toStationId}',
                      ),
                      subtitle: Text(
                        '${item.totalStations} stations · ${item.totalMinutes} min · ${item.fareEGP} EGP',
                      ),
                      onTap: () {
                        final notifier = ref.read(tripPlannerProvider.notifier);
                        notifier.setFromStationById(item.fromStationId);
                        notifier.setToStationById(item.toStationId);
                        context.go('/plan');
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
