import '../entities/station.dart';
import '../entities/line.dart';
import '../entities/metro_graph.dart';

abstract class MetroRepository {
  Future<List<Station>> getStations();
  Future<List<MetroLine>> getLines();
  Future<MetroGraph> getGraph();
  Future<Station?> findNearestStation(double lat, double lng);
  Future<List<Station>> searchStations(String query);
}
