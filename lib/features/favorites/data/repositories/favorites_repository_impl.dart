import 'package:hive/hive.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../models/favorite_item.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final Box<FavoriteItem> _box;

  FavoritesRepositoryImpl(this._box);

  @override
  List<FavoriteItem> getAll() => _box.values.toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  @override
  Future<void> add(FavoriteItem item) => _box.put(item.id, item);

  @override
  Future<void> remove(String id) => _box.delete(id);

  @override
  bool isFavorite(String stationId) =>
      _box.values.any((item) => item.stationId == stationId);
}
