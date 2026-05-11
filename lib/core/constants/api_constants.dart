class ApiConstants {
  static const String predictions = '/predictions';
  static String prediction(String id) => '/predictions/$id';
  static String cancelPrediction(String id) => '/predictions/$id/cancel';
}
