import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/history_item.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../domain/repositories/history_repository.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final box = Hive.box<HistoryItem>('history');
  return HistoryRepositoryImpl(box);
});

final historyListProvider =
    StateNotifierProvider<HistoryNotifier, List<HistoryItem>>((ref) {
  final repo = ref.watch(historyRepositoryProvider);
  return HistoryNotifier(repo);
});

class HistoryNotifier extends StateNotifier<List<HistoryItem>> {
  final HistoryRepository _repo;

  HistoryNotifier(this._repo) : super(_repo.getAll());

  void refresh() {
    state = _repo.getAll();
  }

  Future<void> add(HistoryItem item) async {
    await _repo.add(item);
    refresh();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    refresh();
  }

  Future<void> clearAll() async {
    await _repo.clearAll();
    refresh();
  }
}
