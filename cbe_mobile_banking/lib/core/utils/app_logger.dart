import 'package:logger/logger.dart';

/// App-wide logger. Never log PIN, tokens, OTP, or full account numbers.
abstract final class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: false,
      printEmojis: false,
    ),
  );

  static void d(String message) => _logger.d(message);

  static void i(String message) => _logger.i(message);

  static void w(String message) => _logger.w(message);

  static void e(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
