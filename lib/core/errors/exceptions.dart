class LocationException implements Exception {
  final String message;
  const LocationException(this.message);
}

class DataException implements Exception {
  final String message;
  const DataException(this.message);
}
