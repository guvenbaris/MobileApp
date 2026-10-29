import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../logging/app_logger.dart';

/// Ekranın kendiliğinden kapanmasını engeller (M2-12, TK-15). Arayüzdür;
/// testlerde sahtesiyle değiştirilir.
abstract interface class WakeLock {
  Future<void> setEnabled(bool enabled);
}

/// `wakelock_plus` ile: Android'de pencereye FLAG_KEEP_SCREEN_ON, iOS'ta
/// `idleTimerDisabled`. İzin istemez; yalnızca uygulama ön plandayken
/// geçerlidir.
class PluginWakeLock implements WakeLock {
  const PluginWakeLock(this._logger);

  final AppLogger _logger;

  @override
  Future<void> setEnabled(bool enabled) async {
    try {
      await WakelockPlus.toggle(enable: enabled);
    } on Object catch (e) {
      // Ekranın açık kalmaması okumayı engellemez; yalnızca loglanır.
      _logger.warning('Ekran açık tutulamadı', error: e);
    }
  }
}

final wakeLockProvider = Provider<WakeLock>(
  (ref) => PluginWakeLock(ref.watch(appLoggerProvider)),
);
