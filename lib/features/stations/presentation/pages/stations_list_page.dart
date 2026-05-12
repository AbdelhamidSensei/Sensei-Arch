import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metrogo/l10n/app_localizations.dart';
import '../../../metro_data/presentation/providers/metro_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/station_tile.dart';
import '../providers/stations_provider.dart';

class StationsListPage extends ConsumerWidget {
  const StationsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final stationsAsync = ref.watch(stationsProvider);
    final searchQuery = ref.watch(stationSearchQueryProvider);
    final selectedLine = ref.watch(selectedLineFilterProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabStations)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.search,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (q) =>
                  ref.read(stationSearchQueryProvider.notifier).state = q,
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _FilterChip(
                  label: l10n.allLines,
                  selected: selectedLine == null,
                  onTap: () =>
                      ref.read(selectedLineFilterProvider.notifier).state = null,
                ),
                _FilterChip(
                  label: 'M1',
                  color: AppColors.line1Red,
                  selected: selectedLine == 'L1',
                  onTap: () =>
                      ref.read(selectedLineFilterProvider.notifier).state = 'L1',
                ),
                _FilterChip(
                  label: 'M2',
                  color: AppColors.line2Yellow,
                  selected: selectedLine == 'L2',
                  onTap: () =>
                      ref.read(selectedLineFilterProvider.notifier).state = 'L2',
                ),
                _FilterChip(
                  label: 'M3',
                  color: AppColors.line3Green,
                  selected: selectedLine == 'L3',
                  onTap: () =>
                      ref.read(selectedLineFilterProvider.notifier).state = 'L3',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: stationsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (stations) {
                var filtered = stations;
                if (selectedLine != null) {
                  filtered = filtered
                      .where((s) => s.lineIds.contains(selectedLine))
                      .toList();
                }
                if (searchQuery.isNotEmpty) {
                  final q = searchQuery.toLowerCase();
                  filtered = filtered
                      .where((s) =>
                          s.nameEn.toLowerCase().contains(q) ||
                          s.nameAr.contains(q))
                      .toList();
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final station = filtered[index];
                    return StationTile(
                      station: station,
                      onTap: () => context.push('/station/${station.id}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final Color? color;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? (color ?? Theme.of(context).colorScheme.primary) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color ?? Theme.of(context).colorScheme.primary,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : (color ?? Theme.of(context).colorScheme.primary),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
