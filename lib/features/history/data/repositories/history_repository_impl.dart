import 'package:hive/hive.dart';
import '../../domain/repositories/history_repository.dart';
import '../models/history_item.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final Box<HistoryItem> _box;

  HistoryRepositoryImpl(this._box);

  @override
  List<HistoryItem> getAll() {
    final items = _box.values.toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  @override
  Future<void> add(HistoryItem item) async {
    await _box.put(item.id, item);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> clearAll() async {
    await _box.clear();
  }
}
