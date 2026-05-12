import 'package:flutter_test/flutter_test.dart';
import 'package:metrogo/features/metro_data/domain/entities/station.dart';
import 'package:metrogo/features/metro_data/domain/entities/metro_graph.dart';
import '../../helpers/fake_metro_data.dart';

void main() {
  late final graph = buildFakeGraph();

  group('MetroGraph.shortestPath', () {
    test('same station returns empty result', () {
      final result = graph.shortestPath('s1', 's1');
      expect(result, isNotNull);
      expect(result!.stationCount, 0);
      expect(result.totalMinutes, 0);
    });

    test('adjacent stations on same line', () {
      final result = graph.shortestPath('s1', 's2');
      expect(result, isNotNull);
      expect(result!.stationCount, 1);
      expect(result.totalMinutes, 2);
      expect(result.hasTransfer, false);
    });

    test('multiple stations on same line', () {
      final result = graph.shortestPath('s1', 's4');
      expect(result, isNotNull);
      expect(result!.stationCount, 3);
      expect(result.totalMinutes, 6);
      expect(result.hasTransfer, false);
    });

    test('cross-line route includes transfer', () {
      final result = graph.shortestPath('s1', 's6');
      expect(result, isNotNull);
      // s1 -> s2 (2) -> s3@A (2) -> s3@B (4 transfer) -> s6 (2) = 10 min
      expect(result!.totalMinutes, 10);
      expect(result.hasTransfer, true);
    });

    test('unknown station returns null', () {
      final result = graph.shortestPath('s1', 'unknown');
      expect(result, isNull);
    });

    test('disconnected stations return null', () {
      // Build a graph with an isolated station
      final isolatedStations = [
        ...fakeStations,
        const Station(id: 'isolated', nameEn: 'Iso', nameAr: 'عزل', lat: 29.0, lng: 30.0, lineIds: ['C']),
      ];
      final g = MetroGraph.build(stations: isolatedStations, edges: fakeEdges);
      expect(g.shortestPath('s1', 'isolated'), isNull);
    });
  });
}
