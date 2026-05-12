import 'dart:math';

const _earthRadiusMeters = 6371000.0;

double haversineMeters(double lat1, double lon1, double lat2, double lon2) {
  double rad(double d) => d * pi / 180.0;
  final dLat = rad(lat2 - lat1);
  final dLon = rad(lon2 - lon1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(rad(lat1)) * cos(rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  return 2 * _earthRadiusMeters * atan2(sqrt(a), sqrt(1 - a));
}

int walkingMinutes(double meters) => (meters / 80).ceil();
