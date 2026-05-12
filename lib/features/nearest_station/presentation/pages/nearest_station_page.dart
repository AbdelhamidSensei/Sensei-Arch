import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metrogo/l10n/app_localizations.dart';
import '../providers/nearest_station_provider.dart';
import '../../../../core/widgets/line_chip.dart';
import '../../../../core/utils/format.dart';

class NearestStationPage extends ConsumerWidget {
  const NearestStationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final locale = Localizations.localeOf(context);
    final result = ref.watch(nearestStationResultProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.nearestStation)),
      body: result.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_off, size: 64),
                const SizedBox(height: 16),
                Text(l10n.locationPermissionDenied, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
        data: (result) {
          if (result == null) {
            return const Center(child: Text('No station found nearby'));
          }
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.train, size: 80, color: Colors.blue),
                const SizedBox(height: 24),
                Text(
                  result.station.localizedName(locale.languageCode),
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: result.station.lineIds
                      .map((id) => LineChip(lineId: id, label: id))
                      .toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  '${Format.walkingDistance(result.distanceMeters)} · ${l10n.estimatedTime(result.walkingMinutes)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
