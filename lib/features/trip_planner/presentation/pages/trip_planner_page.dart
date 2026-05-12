import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metrogo/l10n/app_localizations.dart';
import '../providers/trip_planner_provider.dart';
import '../widgets/location_input.dart';

class TripPlannerPage extends ConsumerStatefulWidget {
  const TripPlannerPage({super.key});

  @override
  ConsumerState<TripPlannerPage> createState() => _TripPlannerPageState();
}

class _TripPlannerPageState extends ConsumerState<TripPlannerPage> {
  String? _lastAppliedFrom;
  String? _lastAppliedTo;

  void _applyQueryParams() {
    final uri = GoRouterState.of(context).uri;
    final fromId = uri.queryParameters['from'];
    final toId = uri.queryParameters['to'];
    final notifier = ref.read(tripPlannerProvider.notifier);

    if (fromId != null && fromId.isNotEmpty && fromId != _lastAppliedFrom) {
      _lastAppliedFrom = fromId;
      notifier.setFromStationById(fromId);
    }
    if (toId != null && toId.isNotEmpty && toId != _lastAppliedTo) {
      _lastAppliedTo = toId;
      notifier.setToStationById(toId);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Apply query params on every build so they're picked up on navigation
    _applyQueryParams();

    final l10n = AppL10n.of(context);
    final state = ref.watch(tripPlannerProvider);
    final notifier = ref.read(tripPlannerProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.planTrip)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Station inputs with swap
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A24) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.grey.shade200,
                ),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Column(
                children: [
                  LocationInput(
                    label: l10n.from,
                    selectedStationName: state.fromStation?.localizedName(lang),
                    onStationSelected: (station) =>
                        notifier.setFromStation(station),
                    onUseMyLocation: () => notifier.useMyLocationAsFrom(),
                  ),
                  const SizedBox(height: 4),
                  // Swap button
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Material(
                          color: isDark
                              ? const Color(0xFF252530)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: state.fromStation != null &&
                                    state.toStation != null
                                ? () {
                                    final from = state.fromStation!;
                                    final to = state.toStation!;
                                    notifier.setFromStation(to);
                                    notifier.setToStation(from);
                                  }
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.swap_vert_rounded,
                                size: 20,
                                color: state.fromStation != null &&
                                        state.toStation != null
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LocationInput(
                    label: l10n.to,
                    selectedStationName: state.toStation?.localizedName(lang),
                    onStationSelected: (station) =>
                        notifier.setToStation(station),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Plan button
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: state.fromStation != null &&
                        state.toStation != null &&
                        !state.isLoading
                    ? () async {
                        final plan = await notifier.planTrip();
                        if (plan != null && context.mounted) {
                          context.push('/trip/result', extra: plan);
                        } else if (context.mounted && !state.isLoading) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.noRoute),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        }
                      }
                    : null,
                icon: state.isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.route_rounded),
                label: Text(
                  l10n.planTrip,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            if (state.error != null) ...[
              const SizedBox(height: 14),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        size: 18, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.error!,
                        style: const TextStyle(
                            color: Colors.red, fontSize: 12.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
