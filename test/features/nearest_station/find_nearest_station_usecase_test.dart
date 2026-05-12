import 'package:flutter_test/flutter_test.dart';
import 'package:metrogo/features/metro_data/domain/entities/station.dart';
import 'package:metrogo/core/utils/distance.dart';

void main() {
  group('findNearestStation logic', () {
    final stations = [
      const Station(id: 's1', nameEn: 'Sadat', nameAr: 'السادات', lat: 30.0444, lng: 31.2357, lineIds: ['L1', 'L2'], isTransfer: true),
      const Station(id: 's2', nameEn: 'Orabi', nameAr: 'عرابي', lat: 30.0547, lng: 31.2443, lineIds: ['L1']),
    ];

    test('returns closest station', () {
      double minDist = double.infinity;
      Station? nearest;
      for (final s in stations) {
        final d = haversineMeters(30.045, 31.236, s.lat, s.lng);
        if (d < minDist) {
          minDist = d;
          nearest = s;
        }
      }
      expect(nearest?.id, 's1');
    });

    test('returns null for empty list', () {
      final empty = <Station>[];
      Station? nearest;
      double minDist = double.infinity;
      for (final s in empty) {
        final d = haversineMeters(30.0, 31.0, s.lat, s.lng);
        if (d < minDist) {
          minDist = d;
          nearest = s;
        }
      }
      expect(nearest, isNull);
    });

    test('returns null when beyond 50km cap', () {
      // Position far away from all stations
      double minDist = double.infinity;
      Station? nearest;
      for (final s in stations) {
        final d = haversineMeters(25.0, 25.0, s.lat, s.lng);
        if (d < minDist) {
          minDist = d;
          nearest = s;
        }
      }
      if (minDist > 50000) nearest = null;
      expect(nearest, isNull);
    });
  });
}
