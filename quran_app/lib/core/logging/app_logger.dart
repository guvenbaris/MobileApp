import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LogLevel { debug, info, warning, error }

/// Uygulama genelinde loglama arayüzü. `print` kullanılmaz.
abstract interface class AppLogger {
  void log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  });
}

extension AppLoggerX on AppLogger {
  void debug(String message) => log(LogLevel.debug, message);
  void info(String message) => log(LogLevel.info, message);
  void warning(String message, {Object? error}) =>
      log(LogLevel.warning, message, error: error);
  void error(String message, {Object? error, StackTrace? stackTrace}) =>
      log(LogLevel.error, message, error: error, stackTrace: stackTrace);
}

/// Geliştirici konsoluna yazan logger.
class ConsoleAppLogger implements AppLogger {
  const ConsoleAppLogger({this.minLevel = LogLevel.debug});

  final LogLevel minLevel;

  @override
  void log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.index < minLevel.index) return;
    developer.log(
      message,
      name: 'quran_app',
      level: _severity(level),
      error: error,
      stackTrace: stackTrace,
    );
  }

  static int _severity(LogLevel level) => switch (level) {
    LogLevel.debug => 500,
    LogLevel.info => 800,
    LogLevel.warning => 900,
    LogLevel.error => 1000,
  };
}

final appLoggerProvider = Provider<AppLogger>(
  (ref) => const ConsoleAppLogger(),
);
