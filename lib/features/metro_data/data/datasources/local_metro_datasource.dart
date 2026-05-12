import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/station.dart';
import '../../domain/entities/line.dart';

class LocalMetroDatasource {
  List<Station>? _stationsCache;
  List<MetroLine>? _linesCache;
  List<Map<String, dynamic>>? _edgesCache;

  Future<List<Station>> loadStations() async {
    if (_stationsCache != null) return _stationsCache!;
    final raw = await rootBundle.loadString('assets/data/stations.json');
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    _stationsCache = list.map((j) => Station.fromJson(j)).toList();
    return _stationsCache!;
  }

  Future<List<MetroLine>> loadLines() async {
    if (_linesCache != null) return _linesCache!;
    final raw = await rootBundle.loadString('assets/data/lines.json');
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    _linesCache = list.map((j) => MetroLine.fromJson(j)).toList();
    return _linesCache!;
  }

  Future<List<Map<String, dynamic>>> loadEdges() async {
    if (_edgesCache != null) return _edgesCache!;
    final raw = await rootBundle.loadString('assets/data/edges.json');
    _edgesCache = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return _edgesCache!;
  }
}
