import '../../../metro_data/domain/entities/metro_graph.dart';

class ComputeRouteUsecase {
  final MetroGraph graph;

  ComputeRouteUsecase(this.graph);

  RouteResult? call(String fromStationId, String toStationId) {
    return graph.shortestPath(fromStationId, toStationId);
  }
}
