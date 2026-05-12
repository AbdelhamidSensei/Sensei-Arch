import 'package:logger/logger.dart' as log;

final logger = log.Logger(
  printer: log.PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 80,
    colors: true,
    printEmojis: false,
  ),
);
