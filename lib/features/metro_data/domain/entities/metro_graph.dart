import 'package:collection/collection.dart';
import 'station.dart';

class _Node {
  final String stationId;
  final String lineId;
  const _Node(this.stationId, this.lineId);

  String get key => '$stationId@$lineId';

  @override
  bool operator ==(Object o) => o is _Node && o.key == key;
  @override
  int get hashCode => key.hashCode;
}

class _Edge {
  final _Node to;
  final int minutes;
  final String lineId;
  const _Edge(this.to, this.minutes, this.lineId);
}

class MetroGraph {
  final Map<String, Station> stations;
  final Map<_Node, List<_Edge>> _adjacency;

  MetroGraph._(this.stations, this._adjacency);

  factory MetroGraph.build({
    required List<Station> stations,
    required List<Map<String, dynamic>> edges,
    int transferMinutes = 4,
  }) {
    final stationMap = {for (final s in stations) s.id: s};
    final adj = <_Node, List<_Edge>>{};

    void add(_Node a, _Node b, int min, String line) {
      (adj[a] ??= []).add(_Edge(b, min, line));
      (adj[b] ??= []).add(_Edge(a, min, line));
    }

    for (final e in edges) {
      final from = _Node(e['fromStationId'] as String, e['lineId'] as String);
      final to = _Node(e['toStationId'] as String, e['lineId'] as String);
      add(from, to, (e['minutes'] as num).toInt(), e['lineId'] as String);
    }

    for (final s in stations) {
      if (s.lineIds.length < 2) continue;
      final nodes = s.lineIds.map((l) => _Node(s.id, l)).toList();
      for (var i = 0; i < nodes.length; i++) {
        for (var j = i + 1; j < nodes.length; j++) {
          add(nodes[i], nodes[j], transferMinutes, 'TRANSFER');
        }
      }
    }

    return MetroGraph._(stationMap, adj);
  }

  RouteResult? shortestPath(String fromStationId, String toStationId) {
    if (fromStationId == toStationId) {
      final s = stations[fromStationId];
      if (s == null) return null;
      return RouteResult.empty(s);
    }

    final fromStation = stations[fromStationId];
    final toStation = stations[toStationId];
    if (fromStation == null || toStation == null) return null;

    final dist = <String, int>{};
    final prev = <String, _Edge?>{};
    final prevNode = <String, _Node?>{};
    final pq = HeapPriorityQueue<MapEntry<_Node, int>>(
      (a, b) => a.value.compareTo(b.value),
    );

    for (final line in fromStation.lineIds) {
      final n = _Node(fromStationId, line);
      dist[n.key] = 0;
      prev[n.key] = null;
      prevNode[n.key] = null;
      pq.add(MapEntry(n, 0));
    }

    _Node? target;

    while (pq.isNotEmpty) {
      final cur = pq.removeFirst();
      final u = cur.key;
      if (cur.value > (dist[u.key] ?? 1 << 30)) continue;

      if (u.stationId == toStationId) {
        target = u;
        break;
      }

      for (final edge in _adjacency[u] ?? const <_Edge>[]) {
        final nd = (dist[u.key] ?? 1 << 30) + edge.minutes;
        if (nd < (dist[edge.to.key] ?? 1 << 30)) {
          dist[edge.to.key] = nd;
          prev[edge.to.key] = edge;
          prevNode[edge.to.key] = u;
          pq.add(MapEntry(edge.to, nd));
        }
      }
    }

    if (target == null) return null;

    final pathNodes = <_Node>[];
    var cursor = target;
    pathNodes.add(cursor);
    while (prevNode[cursor.key] != null) {
      cursor = prevNode[cursor.key]!;
      pathNodes.add(cursor);
    }
    final orderedNodes = pathNodes.reversed.toList();

    return RouteResult(
      stations: orderedNodes.map((n) => stations[n.stationId]!).toList(),
      lineIds: orderedNodes.map((n) => n.lineId).toList(),
      totalMinutes: dist[target.key] ?? 0,
    );
  }
}

class RouteResult {
  final List<Station> stations;
  final List<String> lineIds;
  final int totalMinutes;

  const RouteResult({
    required this.stations,
    required this.lineIds,
    required this.totalMinutes,
  });

  factory RouteResult.empty(Station s) =>
      RouteResult(stations: [s], lineIds: [s.lineIds.first], totalMinutes: 0);

  int get stationCount => (stations.length - 1).clamp(0, 999);

  bool get hasTransfer =>
      lineIds.toSet().where((l) => l != 'TRANSFER').length > 1;
}
