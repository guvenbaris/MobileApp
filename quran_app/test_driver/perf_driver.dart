import 'dart:convert';
import 'dart:io';

import 'package:integration_test/integration_test_driver.dart';

/// `integration_test/perf_test.dart` sonuçlarını `build/perf_result.json`
/// dosyasına yazar ve hedeflerle (NF-PF01, NF-PF02) karşılaştırarak özetler.
Future<void> main() => integrationDriver(
  responseDataCallback: (data) async {
    if (data == null) return;
    final file = File('build/perf_result.json');
    await file.parent.create(recursive: true);
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));

    final scroll = data['sayfa_kaydirma'] as Map<String, dynamic>? ?? {};
    final loads = data['sayfa_yukleme_ms'] as Map<String, dynamic>? ?? {};
    String ms(Object? v) => v is num ? '${v.toStringAsFixed(1)} ms' : '-';
    stdout
      ..writeln('')
      ..writeln('=== Performans özeti (hedefler: Proje_Gereksinimleri 9.2) ===')
      ..writeln(
        'Uygulama içi açılış: ${data['uygulama_ici_acilis_ms']} ms '
        '(motor başlangıcı hariç; tam açılış için tool/perf/startup.dart)',
      )
      ..writeln(
        'Sayfa yükleme: p50 ${loads['p50']} ms, p90 ${loads['p90']} ms, '
        'en uzun ${loads['en_uzun']} ms',
      )
      ..writeln(
        'Sayfa kaydırma: build p90 '
        '${ms(scroll['90th_percentile_frame_build_time_millis'])}, '
        'raster p90 '
        '${ms(scroll['90th_percentile_frame_rasterizer_time_millis'])}, '
        'bütçeyi aşan kare: '
        '${scroll['missed_frame_build_budget_count']} (build) / '
        '${scroll['missed_frame_rasterizer_budget_count']} (raster), '
        'toplam kare ${scroll['frame_count']}',
      )
      ..writeln('Ayrıntı: ${file.path}');
  },
);
