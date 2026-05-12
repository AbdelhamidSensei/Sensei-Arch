import 'package:flutter_test/flutter_test.dart';
import 'package:metrogo/core/constants/metro_constants.dart';

void main() {
  group('MetroFares', () {
    test('fareForStationCount for 5 stations', () {
      expect(MetroFares.fareForStationCount(5), 8);
    });

    test('fareForStationCount for 10 stations', () {
      expect(MetroFares.fareForStationCount(10), 10);
    });

    test('fareForStationCount for 20 stations', () {
      expect(MetroFares.fareForStationCount(20), 15);
    });

    test('fareForStationCount for 25 stations', () {
      expect(MetroFares.fareForStationCount(25), 20);
    });
  });
}
