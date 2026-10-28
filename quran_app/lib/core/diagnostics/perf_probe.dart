import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

/// Yalnızca dev ortamında açılan performans ölçümü (F0-05, NF-PF02).
///
/// Kare sürelerini ve sayfa yükleme sürelerini toplar; her [_batch] karede
/// bir özetini `PERF` önekiyle sistem günlüğüne yazar (`adb logcat`).
/// prod ortamında [PerfProbe.instance] null'dır ve hiçbir şey ölçülmez.
class PerfProbe {
  PerfProbe._();

  static PerfProbe? instance;

  static void enable() {
    if (instance != null) return;
    final probe = instance = PerfProbe._();
    SchedulerBinding.instance.addTimingsCallback(probe._onTimings);
  }

  static const _batch = 120;
  static const _frameBudgetMs = 16.7;

  final List<double> _frameMs = [];
  final List<double> _buildMs = [];
  final List<double> _rasterMs = [];
  final List<int> _pageLoadMs = [];

  void recordPageLoad(int page, Duration elapsed) {
    _pageLoadMs.add(elapsed.inMilliseconds);
    debugPrint('PERF sayfa $page yüklendi: ${elapsed.inMilliseconds} ms');
  }

  void _onTimings(List<FrameTiming> timings) {
    for (final t in timings) {
      // Kare süresi: çizim hazırlığı (build) + boyama (raster), hangisi uzunsa.
      final build = t.buildDuration.inMicroseconds / 1000;
      final raster = t.rasterDuration.inMicroseconds / 1000;
      _frameMs.add(build > raster ? build : raster);
      _buildMs.add(build);
      _rasterMs.add(raster);
    }
    if (_frameMs.length >= _batch) _report();
  }

  void _report() {
    final frames = [..._frameMs]..sort();
    final over = frames.where((f) => f > _frameBudgetMs).length;
    String p(double q) =>
        frames[((frames.length - 1) * q).round()].toStringAsFixed(1);
    String p90(List<double> values) {
      final sorted = [...values]..sort();
      return sorted[((sorted.length - 1) * .9).round()].toStringAsFixed(1);
    }

    final loads = [..._pageLoadMs]..sort();
    debugPrint(
      'PERF kareler=${frames.length} p50=${p(.5)}ms p90=${p(.9)}ms '
      'p99=${p(.99)}ms en_uzun=${frames.last.toStringAsFixed(1)}ms '
      '16.7ms_üstü=$over build_p90=${p90(_buildMs)}ms '
      'raster_p90=${p90(_rasterMs)}ms'
      '${loads.isEmpty ? '' : ' | sayfa_yükleme p50=${loads[loads.length ~/ 2]}ms en_uzun=${loads.last}ms'}',
    );
    _frameMs.clear();
    _buildMs.clear();
    _rasterMs.clear();
    _pageLoadMs.clear();
  }
}
