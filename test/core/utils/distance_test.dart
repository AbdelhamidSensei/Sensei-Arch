import 'package:flutter_test/flutter_test.dart';
import 'package:metrogo/core/utils/distance.dart';

void main() {
  group('haversineMeters', () {
    test('same point returns 0', () {
      expect(haversineMeters(0, 0, 0, 0), 0.0);
    });

    test('same point (Cairo) returns 0', () {
      expect(haversineMeters(30.0444, 31.2357, 30.0444, 31.2357), 0.0);
    });

    test('short distance is reasonable', () {
      // Sadat station to Tahrir Square — roughly 200-400m
      final d = haversineMeters(30.0444, 31.2357, 30.0459, 31.2382);
      expect(d, greaterThan(100));
      expect(d, lessThan(500));
    });

    test('longer distance is reasonable', () {
      // Cairo to Alexandria — roughly 180-220 km
      final d = haversineMeters(30.0444, 31.2357, 31.2001, 29.9187);
      expect(d, greaterThan(150000));
      expect(d, lessThan(250000));
    });
  });

  group('walkingMinutes', () {
    test('0 meters = 0 minutes', () {
      expect(walkingMinutes(0), 0);
    });

    test('80m = 1 min', () {
      expect(walkingMinutes(80), 1);
    });

    test('160m = 2 min', () {
      expect(walkingMinutes(160), 2);
    });

    test('rounds up', () {
      expect(walkingMinutes(81), 2);
    });
  });
}
