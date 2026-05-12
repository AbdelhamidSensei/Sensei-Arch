import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local_metro_datasource.dart';
import '../../data/repositories/metro_repository_impl.dart';
import '../../domain/repositories/metro_repository.dart';
import '../../domain/entities/station.dart';
import '../../domain/entities/line.dart';
import '../../domain/entities/metro_graph.dart';

final localMetroDatasourceProvider = Provider<LocalMetroDatasource>((ref) {
  return LocalMetroDatasource();
});

final metroRepositoryProvider = Provider<MetroRepository>((ref) {
  return MetroRepositoryImpl(ref.read(localMetroDatasourceProvider));
});

final stationsProvider = FutureProvider<List<Station>>((ref) {
  return ref.read(metroRepositoryProvider).getStations();
});

final linesProvider = FutureProvider<List<MetroLine>>((ref) {
  return ref.read(metroRepositoryProvider).getLines();
});

final metroGraphProvider = FutureProvider<MetroGraph>((ref) {
  return ref.read(metroRepositoryProvider).getGraph();
});
