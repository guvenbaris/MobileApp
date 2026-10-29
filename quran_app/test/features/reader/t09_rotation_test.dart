import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/app.dart';
import 'package:quran_app/core/config/flavor.dart';
import 'package:quran_app/core/config/flavor_provider.dart';
import 'package:quran_app/core/platform/wake_lock.dart';
import 'package:quran_app/core/routing/app_router.dart';
import 'package:quran_app/features/quran/application/quran_providers.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';
import 'package:quran_app/features/reader/application/reader_providers.dart';
import 'package:quran_app/features/user_data/application/user_data_providers.dart';

import '../../helpers/fake_quran_repository.dart';
import '../../helpers/fake_wake_lock.dart';

/// T-09: döndürme ve çoklu pencere; konum kaybı yaşanmaz (M2-10).
/// KK M2-10: Bakara 150'de dikey → yatay → dikey dönüşte ekran aynı ayette
/// kalır. Sahte veride Bakara 150 → sayfa 16.
///
/// Android'de döndürme ve pencere boyutu değişikliği etkinliği yeniden
/// başlatmaz (`AndroidManifest.xml` `configChanges`); Flutter'a yalnızca
/// ekran boyutu değişimi olarak ulaşır. Testler bunu taklit eder.
const _bakara150 = AyahRef(2, 150);

Widget _app(String viewMode) => ProviderScope(
  overrides: [
    flavorProvider.overrideWithValue(Flavor.dev),
    quranRepositoryProvider.overrideWithValue(
      FakeQuranRepository(withPages: true),
    ),
    userDataSnapshotProvider.overrideWithValue(
      UserDataSnapshot(
        settings: {'app.language': 'tr', 'reader.viewMode': viewMode},
      ),
    ),
    wakeLockProvider.overrideWithValue(FakeWakeLock()),
  ],
  child: const QuranApp(),
);

Future<void> _resize(WidgetTester tester, Size logical) async {
  tester.view.devicePixelRatio = 2;
  tester.view.physicalSize = logical * 2;
  await tester.pumpAndSettle();
}

Future<void> _open(WidgetTester tester, String viewMode, Size start) async {
  addTearDown(tester.view.reset);
  await _resize(tester, start);
  await tester.pumpWidget(_app(viewMode));
  await tester.pumpAndSettle();
  ProviderScope.containerOf(tester.element(find.byType(QuranApp)))
      .read(appRouterProvider)
      .push('/read?ayah=2:150')
      .ignore();
  await tester.pumpAndSettle();
}

/// Okunan ayet ve (sayfa görünümünde) başlıktaki sayfa.
void _expectBakara150(WidgetTester tester, String viewMode, String step) {
  final container = ProviderScope.containerOf(
    tester.element(find.byType(QuranApp)),
  );
  expect(container.read(readerAnchorProvider), _bakara150, reason: step);
  final title = tester
      .widget<Text>(find.byKey(const Key('reader.title')))
      .data!;
  expect(
    title,
    viewMode == 'page' ? startsWith('Sayfa 16') : 'Ayet 2:150',
    reason: step,
  );
}

void main() {
  const phonePortrait = Size(411, 914);
  const phoneLandscape = Size(914, 411);
  const tabletPortrait = Size(800, 1280);
  const tabletLandscape = Size(1280, 800);

  for (final viewMode in ['page', 'ayah']) {
    group('$viewMode görünümü', () {
      testWidgets('telefon: dikey → yatay → dikey (KK M2-10)', (tester) async {
        await _open(tester, viewMode, phonePortrait);
        _expectBakara150(tester, viewMode, 'açılış');
        await _resize(tester, phoneLandscape);
        _expectBakara150(tester, viewMode, 'yatay');
        await _resize(tester, phonePortrait);
        _expectBakara150(tester, viewMode, 'yeniden dikey');
      });

      testWidgets('tablet: dikey → yatay (çift sayfa) → dikey', (tester) async {
        await _open(tester, viewMode, tabletPortrait);
        _expectBakara150(tester, viewMode, 'açılış');
        await _resize(tester, tabletLandscape);
        _expectBakara150(tester, viewMode, 'yatay');
        if (viewMode == 'page') {
          // 15–16. sayfalar 7. açılımdır.
          expect(find.byKey(const ValueKey('reader.spread.7')), findsOneWidget);
        }
        await _resize(tester, tabletPortrait);
        _expectBakara150(tester, viewMode, 'yeniden dikey');
      });

      testWidgets('çoklu pencere: bölünmüş ekran ve serbest pencere', (
        tester,
      ) async {
        await _open(tester, viewMode, phonePortrait);
        for (final (size, step) in [
          (const Size(411, 450), 'ekranın yarısı'),
          (const Size(411, 300), 'ekranın üçte biri'),
          (const Size(600, 700), 'serbest pencere'),
          (tabletLandscape, 'katlanabilir açık'),
          (phonePortrait, 'tam ekran'),
        ]) {
          await _resize(tester, size);
          _expectBakara150(tester, viewMode, step);
        }
      });
    });
  }

  testWidgets('çubuklar gizli ve ayar paneli açıkken döndürme', (tester) async {
    await _open(tester, 'page', phonePortrait);
    await tester.tap(find.byKey(const Key('reader.settings')));
    await tester.pumpAndSettle();
    await _resize(tester, phoneLandscape);
    await _resize(tester, phonePortrait);
    expect(
      find.byKey(const Key('readerSettings.keepScreenOn'), skipOffstage: false),
      findsOneWidget,
    );
    await tester.tapAt(const Offset(200, 40)); // paneli kapat
    await tester.pumpAndSettle();
    _expectBakara150(tester, 'page', 'panel kapandı');

    // Çubuklar gizliyken de döndürme konumu ve gizli durumu korur.
    await tester.tapAt(const Offset(80, 450));
    await tester.pumpAndSettle();
    await _resize(tester, phoneLandscape);
    await _resize(tester, phonePortrait);
    expect(find.byKey(const Key('reader.topBar')), findsNothing);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(QuranApp)),
    );
    expect(container.read(readerAnchorProvider), _bakara150);
  });
}
