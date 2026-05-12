import 'package:flutter/material.dart';
import 'package:metrogo/l10n/app_localizations.dart';

class TripSummaryBar extends StatelessWidget {
  final int stations;
  final int minutes;
  final int fare;

  const TripSummaryBar({
    super.key,
    required this.stations,
    required this.minutes,
    required this.fare,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Text(
        l10n.totalSummary(stations, minutes, fare),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
