import '../../data/models/favorite_item.dart';

abstract class FavoritesRepository {
  List<FavoriteItem> getAll();
  Future<void> add(FavoriteItem item);
  Future<void> remove(String id);
  bool isFavorite(String stationId);
}
