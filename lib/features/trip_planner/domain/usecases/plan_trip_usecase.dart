import '../../../metro_data/domain/entities/metro_graph.dart';
import '../../../metro_data/domain/entities/station.dart';
import '../../../metro_data/domain/repositories/metro_repository.dart';
import '../../../../core/constants/metro_constants.dart';
import '../../../../core/utils/distance.dart';
import '../entities/trip_plan.dart';
import '../entities/trip_segment.dart';

class PlanTripUsecase {
  final MetroRepository repository;

  PlanTripUsecase(this.repository);

  Future<TripPlan?> call({
    String? fromStationId,
    String? toStationId,
    double? fromLat,
    double? fromLng,
    double? toLat,
    double? toLng,
  }) async {
    final graph = await repository.getGraph();

    Station? fromStation;
    Station? toStation;
    double? walkToBoard;
    double? walkFromAlight;

    if (fromStationId != null) {
      fromStation = graph.stations[fromStationId];
    } else if (fromLat != null && fromLng != null) {
      fromStation = await repository.findNearestStation(fromLat, fromLng);
      if (fromStation != null) {
        walkToBoard = haversineMeters(fromLat, fromLng, fromStation.lat, fromStation.lng);
      }
    }

    if (toStationId != null) {
      toStation = graph.stations[toStationId];
    } else if (toLat != null && toLng != null) {
      toStation = await repository.findNearestStation(toLat, toLng);
      if (toStation != null) {
        walkFromAlight = haversineMeters(toLat, toLng, toStation.lat, toStation.lng);
      }
    }

    if (fromStation == null || toStation == null) return null;

    final result = graph.shortestPath(fromStation.id, toStation.id);
    if (result == null) return null;

    final segments = _buildSegments(result);
    final fare = MetroFares.fareForStationCount(result.stationCount);

    return TripPlan(
      boardingStation: fromStation,
      alightingStation: toStation,
      segments: segments,
      totalStations: result.stationCount,
      totalMinutes: result.totalMinutes,
      fareEGP: fare,
      walkingDistanceToBoard: walkToBoard,
      walkingMinsToBoard: walkToBoard != null ? walkingMinutes(walkToBoard) : null,
      walkingDistanceFromAlight: walkFromAlight,
      walkingMinsFromAlight: walkFromAlight != null ? walkingMinutes(walkFromAlight) : null,
    );
  }

  List<TripSegment> _buildSegments(RouteResult result) {
    if (result.stations.length <= 1) return [];

    final segments = <TripSegment>[];
    int segStart = 0;

    for (int i = 1; i < result.stations.length; i++) {
      final currentLine = result.lineIds[i];
      final prevLine = result.lineIds[i - 1];

      if (currentLine != prevLine && currentLine != 'TRANSFER' && prevLine != 'TRANSFER') {
        // Line changed without explicit transfer node - shouldn't happen in our graph
        // but handle gracefully
      }

      // If we hit a TRANSFER node or line change, end the current segment
      if (currentLine == 'TRANSFER') continue;

      if (i == result.stations.length - 1 ||
          (i + 1 < result.lineIds.length && result.lineIds[i + 1] == 'TRANSFER') ||
          (i + 1 < result.lineIds.length &&
              result.lineIds[i + 1] != currentLine &&
              result.lineIds[i + 1] != 'TRANSFER')) {
        // Find actual start of this segment (skip TRANSFER nodes)
        int actualStart = segStart;
        while (actualStart < result.lineIds.length &&
            result.lineIds[actualStart] == 'TRANSFER') {
          actualStart++;
        }

        if (actualStart <= i) {
          final stationsInSeg = result.stations.sublist(actualStart, i + 1);
          if (stationsInSeg.length >= 2) {
            segments.add(TripSegment(
              lineId: currentLine,
              fromStation: stationsInSeg.first,
              toStation: stationsInSeg.last,
              intermediateStations:
                  stationsInSeg.length > 2 ? stationsInSeg.sublist(1, stationsInSeg.length - 1) : [],
              minutes: (stationsInSeg.length - 1) * 2,
            ));
          }
        }

        segStart = i + 1;
      }
    }

    // If no segments were created, build one from the whole route
    if (segments.isEmpty && result.stations.length >= 2) {
      final nonTransferStations = <Station>[];
      String? segLine;
      for (int i = 0; i < result.stations.length; i++) {
        if (result.lineIds[i] != 'TRANSFER') {
          nonTransferStations.add(result.stations[i]);
          segLine ??= result.lineIds[i];
        }
      }
      if (nonTransferStations.length >= 2) {
        segments.add(TripSegment(
          lineId: segLine ?? result.lineIds.first,
          fromStation: nonTransferStations.first,
          toStation: nonTransferStations.last,
          intermediateStations: nonTransferStations.length > 2
              ? nonTransferStations.sublist(1, nonTransferStations.length - 1)
              : [],
          minutes: result.totalMinutes,
        ));
      }
    }

    return segments;
  }
}
