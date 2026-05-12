import '../../../metro_data/domain/entities/station.dart';
import '../../../metro_data/domain/repositories/metro_repository.dart';
import '../../../../core/utils/distance.dart';

class FindNearestStationResult {
  final Station station;
  final double distanceMeters;
  final int walkingMinutes;

  const FindNearestStationResult({
    required this.station,
    required this.distanceMeters,
    required this.walkingMinutes,
  });
}

class FindNearestStationUsecase {
  final MetroRepository repository;

  FindNearestStationUsecase(this.repository);

  Future<FindNearestStationResult?> call(double lat, double lng) async {
    final station = await repository.findNearestStation(lat, lng);
    if (station == null) return null;
    final dist = haversineMeters(lat, lng, station.lat, station.lng);
    return FindNearestStationResult(
      station: station,
      distanceMeters: dist,
      walkingMinutes: walkingMinutes(dist),
    );
  }
}
