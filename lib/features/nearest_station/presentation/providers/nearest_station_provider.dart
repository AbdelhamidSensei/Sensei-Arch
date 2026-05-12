import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/usecases/find_nearest_station_usecase.dart';
import '../../../metro_data/presentation/providers/metro_provider.dart';

final nearestStationResultProvider =
    FutureProvider<FindNearestStationResult?>((ref) async {
  final enabled = await Geolocator.isLocationServiceEnabled();
  if (!enabled) throw Exception('Location services disabled');

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permission permanently denied');
  }

  final position = await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      timeLimit: Duration(seconds: 10),
    ),
  );

  final repo = ref.read(metroRepositoryProvider);
  final usecase = FindNearestStationUsecase(repo);
  return usecase.call(position.latitude, position.longitude);
});
