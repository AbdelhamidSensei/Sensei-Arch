import '../../../metro_data/domain/entities/station.dart';
import 'trip_segment.dart';

class TripPlan {
  final Station boardingStation;
  final Station alightingStation;
  final List<TripSegment> segments;
  final int totalStations;
  final int totalMinutes;
  final int fareEGP;
  final double? walkingDistanceToBoard;
  final int? walkingMinsToBoard;
  final double? walkingDistanceFromAlight;
  final int? walkingMinsFromAlight;

  const TripPlan({
    required this.boardingStation,
    required this.alightingStation,
    required this.segments,
    required this.totalStations,
    required this.totalMinutes,
    required this.fareEGP,
    this.walkingDistanceToBoard,
    this.walkingMinsToBoard,
    this.walkingDistanceFromAlight,
    this.walkingMinsFromAlight,
  });

  int get totalTimeWithWalking =>
      totalMinutes +
      (walkingMinsToBoard ?? 0) +
      (walkingMinsFromAlight ?? 0);
}
