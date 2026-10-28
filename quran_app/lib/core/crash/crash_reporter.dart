import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logging/app_logger.dart';

/// Çökme ve hata raporlama arayüzü.
///
/// Gerçek sağlayıcı (Sentry / Crashlytics / kendi sunucu) Faz 3'te seçilir (TK-10).
/// Kullanıcı raporlamayı kapatabilir (NF-A02).
abstract interface class CrashReporter {
  bool get isEnabled;

  Future<void> setEnabled({required bool enabled});

  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    bool fatal = false,
  });
}

/// Hataları yalnızca loglayan ve bellekte tutan uygulama.
class FakeCrashReporter implements CrashReporter {
  FakeCrashReporter(this._logger);

  final AppLogger _logger;
  final List<Object> recordedErrors = [];
  bool _enabled = true;

  @override
  bool get isEnabled => _enabled;

  @override
  Future<void> setEnabled({required bool enabled}) async => _enabled = enabled;

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    bool fatal = false,
  }) async {
    if (!_enabled) return;
    recordedErrors.add(error);
    _logger.error(
      fatal ? 'Ölümcül hata' : 'Yakalanmamış hata',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// TK-10 kararına kadar iki ortamda da sahte uygulama kullanılır.
final crashReporterProvider = Provider<CrashReporter>(
  (ref) => FakeCrashReporter(ref.watch(appLoggerProvider)),
);
