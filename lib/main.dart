import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/favorites/data/models/favorite_item.dart';
import 'features/history/data/models/trip_history_item.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(FavoriteItemAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(TripHistoryItemAdapter());
  }

  await Hive.openBox<FavoriteItem>('favorites');
  await Hive.openBox<TripHistoryItem>('trip_history');
  await Hive.openBox('settings');

  runApp(const ProviderScope(child: MetroGoApp()));
}
