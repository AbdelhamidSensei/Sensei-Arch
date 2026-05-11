import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get replicateToken => dotenv.env['REPLICATE_API_TOKEN'] ?? '';
  static String get replicateBaseUrl =>
      dotenv.env['REPLICATE_BASE_URL'] ?? 'https://api.replicate.com/v1';
  static String get enhanceModelVersion =>
      dotenv.env['ENHANCE_MODEL_VERSION'] ?? '';
  static String get restoreModelVersion =>
      dotenv.env['RESTORE_MODEL_VERSION'] ?? '';
  static String get lamaModelVersion =>
      dotenv.env['LAMA_MODEL_VERSION'] ?? '';
  static String get removeBgApiKey =>
      dotenv.env['REMOVEBG_API_KEY'] ?? '';
  static String get appEnv => dotenv.env['APP_ENV'] ?? 'development';
  static bool get hasApiToken => replicateToken.isNotEmpty;
  static bool get hasRemoveBgKey => removeBgApiKey.isNotEmpty;
}
