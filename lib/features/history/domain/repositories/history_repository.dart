import '../../data/models/history_item.dart';

abstract class HistoryRepository {
  List<HistoryItem> getAll();
  Future<void> add(HistoryItem item);
  Future<void> delete(String id);
  Future<void> clearAll();
}
