import '../../domain/entities/station.dart';
import '../../domain/entities/line.dart';
import '../../domain/entities/metro_graph.dart';
import '../../domain/repositories/metro_repository.dart';
import '../datasources/local_metro_datasource.dart';
import '../../../../core/utils/distance.dart';
import '../../../../core/utils/extensions.dart';

class MetroRepositoryImpl implements MetroRepository {
  final LocalMetroDatasource _datasource;
  MetroGraph? _graphCache;

  MetroRepositoryImpl(this._datasource);

  @override
  Future<List<Station>> getStations() => _datasource.loadStations();

  @override
  Future<List<MetroLine>> getLines() => _datasource.loadLines();

  @override
  Future<MetroGraph> getGraph() async {
    if (_graphCache != null) return _graphCache!;
    final stations = await _datasource.loadStations();
    final edges = await _datasource.loadEdges();
    _graphCache = MetroGraph.build(stations: stations, edges: edges);
    return _graphCache!;
  }

  @override
  Future<Station?> findNearestStation(double lat, double lng) async {
    final stations = await _datasource.loadStations();
    Station? nearest;
    double minDist = double.infinity;
    for (final s in stations) {
      final d = haversineMeters(lat, lng, s.lat, s.lng);
      if (d < minDist) {
        minDist = d;
        nearest = s;
      }
    }
    if (minDist > 50000) return null; // > 50km cap
    return nearest;
  }

  @override
  Future<List<Station>> searchStations(String query) async {
    if (query.isEmpty) return [];
    final stations = await _datasource.loadStations();
    return stations
        .where((s) =>
            s.nameEn.matchesArabicOrEnglish(query) ||
            s.nameAr.matchesArabicOrEnglish(query))
        .toList();
  }
}
