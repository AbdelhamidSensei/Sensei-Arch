import 'package:flutter_test/flutter_test.dart';
import 'package:metrogo/features/trip_planner/domain/usecases/compute_route_usecase.dart';
import '../../helpers/fake_metro_data.dart';

void main() {
  final graph = buildFakeGraph();
  final usecase = ComputeRouteUsecase(graph);

  group('ComputeRouteUsecase', () {
    test('same line returns correct minutes', () {
      final result = usecase.call('s1', 's4');
      expect(result, isNotNull);
      expect(result!.totalMinutes, 6);
      expect(result.stationCount, 3);
    });

    test('cross-line includes transfer cost', () {
      final result = usecase.call('s1', 's6');
      expect(result, isNotNull);
      expect(result!.totalMinutes, 10); // 2+2+4+2
      expect(result.hasTransfer, true);
    });

    test('returns null for non-existent station', () {
      expect(usecase.call('s1', 'nonexistent'), isNull);
    });
  });
}
