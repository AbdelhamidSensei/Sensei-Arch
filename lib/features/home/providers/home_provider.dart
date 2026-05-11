import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../history/data/models/history_item.dart';
import '../../history/presentation/providers/history_provider.dart';

final recentEnhancementsProvider = Provider<List<HistoryItem>>((ref) {
  final all = ref.watch(historyListProvider);
  return all.take(5).toList();
});
