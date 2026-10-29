import 'package:quran_app/core/platform/wake_lock.dart';

/// Ekranın açık tutulup tutulmadığını kaydeden sahte (M2-12).
class FakeWakeLock implements WakeLock {
  bool enabled = false;

  @override
  Future<void> setEnabled(bool enabled) async => this.enabled = enabled;
}
