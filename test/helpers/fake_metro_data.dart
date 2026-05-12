import 'package:metrogo/features/metro_data/domain/entities/station.dart';
import 'package:metrogo/features/metro_data/domain/entities/metro_graph.dart';

// Tiny test graph:
// Line A: S1 -- S2 -- S3 (transfer) -- S4
// Line B: S5 -- S3 (transfer) -- S6
// All edges = 2 min, transfer = 4 min

final fakeStations = [
  const Station(id: 's1', nameEn: 'Alpha', nameAr: 'ألفا', lat: 30.0, lng: 31.0, lineIds: ['A']),
  const Station(id: 's2', nameEn: 'Beta', nameAr: 'بيتا', lat: 30.01, lng: 31.01, lineIds: ['A']),
  const Station(id: 's3', nameEn: 'Gamma', nameAr: 'جاما', lat: 30.02, lng: 31.02, lineIds: ['A', 'B'], isTransfer: true),
  const Station(id: 's4', nameEn: 'Delta', nameAr: 'دلتا', lat: 30.03, lng: 31.03, lineIds: ['A']),
  const Station(id: 's5', nameEn: 'Epsilon', nameAr: 'إبسيلون', lat: 30.04, lng: 31.04, lineIds: ['B']),
  const Station(id: 's6', nameEn: 'Zeta', nameAr: 'زيتا', lat: 30.05, lng: 31.05, lineIds: ['B']),
];

final fakeEdges = <Map<String, dynamic>>[
  {'fromStationId': 's1', 'toStationId': 's2', 'lineId': 'A', 'minutes': 2},
  {'fromStationId': 's2', 'toStationId': 's3', 'lineId': 'A', 'minutes': 2},
  {'fromStationId': 's3', 'toStationId': 's4', 'lineId': 'A', 'minutes': 2},
  {'fromStationId': 's5', 'toStationId': 's3', 'lineId': 'B', 'minutes': 2},
  {'fromStationId': 's3', 'toStationId': 's6', 'lineId': 'B', 'minutes': 2},
];

MetroGraph buildFakeGraph({int transferMinutes = 4}) {
  return MetroGraph.build(
    stations: fakeStations,
    edges: fakeEdges,
    transferMinutes: transferMinutes,
  );
}
