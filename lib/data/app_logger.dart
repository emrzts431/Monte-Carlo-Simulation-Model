import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 1, // number of method calls to display
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: true, // color for different levels
        printEmojis: true, // print emojis for each log level
        dateTimeFormat:
            DateTimeFormat.onlyTimeAndSinceStart, // display time for each log
      ),
    );
  }

  // Singleton instance
  static final AppLogger instance = AppLogger._internal();

  late final Logger _logger;

  // Info Level Log
  void info(String message) {
    _logger.i(message);
  }

  // Debug Level Log
  void debug(dynamic message) {
    _logger.d(message);
  }

  // Warning Level Log
  void warning(String message) {
    _logger.w(message);
  }

  // Error Level Log
  void error(Exception? error, StackTrace? stackTrace) {
    _logger.e(error, stackTrace: stackTrace);
  }

  // Log with a custom level
  void log(Level level, String message) {
    _logger.log(level, message);
  }
}
