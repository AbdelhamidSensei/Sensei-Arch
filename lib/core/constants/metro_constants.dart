// Verify current fares with the National Authority for Tunnels (NAT) before release.
class MetroFares {
  static int fareForStationCount(int n) {
    if (n <= 9) return 8;
    if (n <= 16) return 10;
    if (n <= 23) return 15;
    return 20;
  }
}

class MetroConstants {
  static const double cairoLat = 30.0444;
  static const double cairoLng = 31.2357;
  static const int defaultZoom = 11;
  static const int transferMinutes = 4;
  static const double avgSpeedKmH = 4.8;
  static const int maxHistoryItems = 10;
}
