import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:quran_app/app.dart';
import 'package:quran_app/core/config/flavor.dart';
import 'package:quran_app/core/config/flavor_provider.dart';
import 'package:quran_app/core/database/user_database_opener.dart';
import 'package:quran_app/features/quran/application/quran_providers.dart';
import 'package:quran_app/features/quran/data/content_database_opener.dart';
import 'package:quran_app/features/quran/data/drift_quran_repository.dart';
import 'package:quran_app/features/reader/presentation/mushaf_page_view.dart';
import 'package:quran_app/features/user_data/application/user_data_providers.dart';

/// Gerçek cihaz performans ölçümü (F1-00; NF-PF01, NF-PF02).
///
/// Ölçülenler:
/// - `uygulama_ici_acilis`: veritabanlarının açılmasından ana sayfanın ilk
///   karesine kadar (motor başlangıcı hariç; tamamı için `tool/perf/startup.dart`).
/// - `sayfa_yukleme`: bir mushaf sayfasının veritabanından okunması.
/// - `sayfa_kaydirma`: 20 sayfa çevrilirken kare süreleri.
///
/// **Profile derlemesinde** çalıştırılmalıdır (debug sayıları anlamsızdır):
///   flutter drive --profile --no-dds --flavor dev --driver=test_driver/perf_driver.dart --target=integration_test/perf_test.dart
/// Sonuç: `build/perf_result.json` ve konsoldaki özet.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('performans: açılış, sayfa yükleme, sayfa kaydırma', (
    tester,
  ) async {
    final startup = Stopwatch()..start();
    final contentDb = await openContentDatabase();
    final userDb = await openUserDatabase();
    final snapshot = await UserDataSnapshot.load(userDb);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          flavorProvider.overrideWithValue(Flavor.dev),
          contentDatabaseProvider.overrideWithValue(contentDb),
          userDatabaseProvider.overrideWithValue(userDb),
          // Ölçüm her cihazda aynı ekrandan başlasın: Türkçe, sayfa görünümü.
          userDataSnapshotProvider.overrideWithValue(
            UserDataSnapshot(
              localUserId: snapshot.localUserId,
              settings: {
                ...snapshot.settings,
                'app.language': 'tr',
                'reader.viewMode': 'page',
              },
            ),
          ),
        ],
        child: const QuranApp(),
      ),
    );
    await tester.pump();
    final startupMs = startup.elapsedMilliseconds;
    await tester.pumpAndSettle();

    // Sayfa yükleme: 50 farklı sayfa (önbellek yok, doğrudan depo).
    final repo = DriftQuranRepository(contentDb);
    final loads = <int>[];
    for (var page = 300; page < 350; page++) {
      final watch = Stopwatch()..start();
      await repo.getMushafPage(kDefaultLayoutId, page);
      loads.add(watch.elapsedMilliseconds);
    }
    loads.sort();

    // Okuma ekranı: Fatiha'dan (1. sayfa) başlayıp 20 sayfa ileri.
    await tester.tap(find.byKey(const Key('tab.quran')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('quran.surah.1')));
    await tester.pumpAndSettle();
    expect(find.byType(MushafPageView), findsWidgets);

    await binding.watchPerformance(() async {
      for (var i = 0; i < 20; i++) {
        // Mushaf sağdan sola: sonraki sayfa soldan gelir, parmak sağa çekilir.
        await tester.fling(find.byType(PageView), const Offset(300, 0), 1500);
        await tester.pumpAndSettle();
      }
    }, reportKey: 'sayfa_kaydirma');

    binding.reportData = {
      ...?binding.reportData,
      'uygulama_ici_acilis_ms': startupMs,
      'sayfa_yukleme_ms': {
        'p50': loads[loads.length ~/ 2],
        'p90': loads[(loads.length * 0.9).floor()],
        'en_uzun': loads.last,
      },
    };
  });
}
