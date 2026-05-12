import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/favorite_item.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../domain/repositories/favorites_repository.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryImpl(Hive.box<FavoriteItem>('favorites'));
});

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<FavoriteItem>>((ref) {
  return FavoritesNotifier(ref.read(favoritesRepositoryProvider));
});

class FavoritesNotifier extends StateNotifier<List<FavoriteItem>> {
  final FavoritesRepository _repo;

  FavoritesNotifier(this._repo) : super(_repo.getAll());

  Future<void> addStation(String stationId, String label) async {
    final item = FavoriteItem(
      id: const Uuid().v4(),
      stationId: stationId,
      label: label,
      createdAt: DateTime.now(),
    );
    await _repo.add(item);
    state = _repo.getAll();
  }

  Future<void> addTrip(String fromId, String toId, String label) async {
    final item = FavoriteItem(
      id: const Uuid().v4(),
      fromStationId: fromId,
      toStationId: toId,
      label: label,
      createdAt: DateTime.now(),
    );
    await _repo.add(item);
    state = _repo.getAll();
  }

  Future<void> remove(String id) async {
    await _repo.remove(id);
    state = _repo.getAll();
  }

  bool isFavorite(String stationId) => _repo.isFavorite(stationId);
}
