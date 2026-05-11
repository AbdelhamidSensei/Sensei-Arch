import 'package:logger/logger.dart' as pkg;

final appLogger = pkg.Logger(
  printer: pkg.PrettyPrinter(methodCount: 0, errorMethodCount: 5),
);
