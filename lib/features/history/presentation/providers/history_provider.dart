import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/trip_history_item.dart';

final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<TripHistoryItem>>((ref) {
  return HistoryNotifier();
});

class HistoryNotifier extends StateNotifier<List<TripHistoryItem>> {
  static const _maxItems = 10;
  final Box<TripHistoryItem> _box = Hive.box<TripHistoryItem>('trip_history');

  HistoryNotifier() : super([]) {
    state = _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> addTrip({
    required String fromStationId,
    required String toStationId,
    required int totalMinutes,
    required int totalStations,
    required int fareEGP,
  }) async {
    final item = TripHistoryItem(
      id: const Uuid().v4(),
      fromStationId: fromStationId,
      toStationId: toStationId,
      totalMinutes: totalMinutes,
      totalStations: totalStations,
      fareEGP: fareEGP,
      createdAt: DateTime.now(),
    );
    await _box.put(item.id, item);

    // Trim to max items
    final all = _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (all.length > _maxItems) {
      for (final old in all.sublist(_maxItems)) {
        await _box.delete(old.id);
      }
    }

    state = _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
