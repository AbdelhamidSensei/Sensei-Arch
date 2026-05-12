import 'package:flutter/material.dart';
import '../../features/metro_data/domain/entities/station.dart';
import 'line_chip.dart';

class StationTile extends StatelessWidget {
  final Station station;
  final VoidCallback? onTap;
  final Widget? trailing;

  const StationTile({
    super.key,
    required this.station,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isAr = locale.languageCode == 'ar';
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: const Icon(Icons.train, size: 20),
      ),
      title: Text(
        isAr ? station.nameAr : station.nameEn,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Row(
        children: station.lineIds
            .map((id) => Padding(
                  padding: const EdgeInsetsDirectional.only(end: 4),
                  child: LineChip(lineId: id, label: id, small: true),
                ))
            .toList(),
      ),
      trailing: trailing,
    );
  }
}
