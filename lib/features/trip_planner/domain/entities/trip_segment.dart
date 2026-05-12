import '../../../metro_data/domain/entities/station.dart';

class TripSegment {
  final String lineId;
  final Station fromStation;
  final Station toStation;
  final List<Station> intermediateStations;
  final int minutes;

  const TripSegment({
    required this.lineId,
    required this.fromStation,
    required this.toStation,
    required this.intermediateStations,
    required this.minutes,
  });

  int get stationCount => intermediateStations.length + 1;
}
