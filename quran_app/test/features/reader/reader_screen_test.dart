import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/app.dart';
import 'package:quran_app/core/config/flavor.dart';
import 'package:quran_app/core/config/flavor_provider.dart';
import 'package:quran_app/core/platform/wake_lock.dart';
import 'package:quran_app/core/routing/app_router.dart';
import 'package:quran_app/core/theme/app_theme.dart';
import 'package:quran_app/features/quran/application/quran_providers.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';
import 'package:quran_app/features/quran/domain/tajweed.dart';
import 'package:quran_app/features/reader/application/reader_providers.dart';
import 'package:quran_app/features/reader/application/reader_settings.dart';
import 'package:quran_app/features/reader/presentation/mushaf_mark.dart';
import 'package:quran_app/features/user_data/application/user_data_providers.dart';

import '../../helpers/fake_quran_repository.dart';
import '../../helpers/fake_wake_lock.dart';
import '../../helpers/localized_app.dart';

/// F1-02: okuma ekranı (E-04, E-05, E-10). Sahte depoda her ayet bir satır;
/// Bakara 2. sayfadan başlar, sayfada 10 ayet (2:31–40 → sayfa 5).
Widget _app({
  Map<String, Object?> settings = const {},
  WakeLock? wakeLock,
  Set<AyahRef> sajdahs = const {},
}) => ProviderScope(
  overrides: [
    flavorProvider.overrideWithValue(Flavor.dev),
    quranRepositoryProvider.overrideWithValue(
      FakeQuranRepository(withPages: true, sajdahs: sajdahs),
    ),
    userDataSnapshotProvider.overrideWithValue(
      UserDataSnapshot(settings: {'app.language': 'tr', ...settings}),
    ),
    wakeLockProvider.overrideWithValue(wakeLock ?? FakeWakeLock()),
  ],
  child: const QuranApp(),
);

ProviderContainer _container(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(QuranApp)));

/// Telefon (dikey) ekranı: tek sayfa.
void _phone(WidgetTester tester) {
  tester.view.devicePixelRatio = 2;
  tester.view.physicalSize = const Size(411, 914) * 2;
  addTearDown(tester.view.reset);
}

/// Uygulamayı açar ve okuma ekranını Bugün sekmesinin üstünde açar.
Future<void> _openReader(
  WidgetTester tester,
  String location, {
  Map<String, Object?> settings = const {},
  WakeLock? wakeLock,
  Set<AyahRef> sajdahs = const {},
}) async {
  _phone(tester);
  await tester.pumpWidget(
    _app(settings: settings, wakeLock: wakeLock, sajdahs: sajdahs),
  );
  await tester.pumpAndSettle();
  _container(tester).read(appRouterProvider).push(location).ignore();
  await tester.pumpAndSettle();
}

AyahRef _anchor(WidgetTester tester) =>
    _container(tester).read(readerAnchorProvider);

ReaderSettings _settings(WidgetTester tester) =>
    _container(tester).read(readerSettingsProvider);

final _topBar = find.byKey(const Key('reader.topBar'));
final _bottomBar = find.byKey(const Key('reader.bottomBar'));

/// Mushaf satırının boş (kelimesiz) bölümüne dokunur: satırdaki tek kelime
/// sağdadır.
Future<void> _tapEmpty(WidgetTester tester) async {
  await tester.tapAt(const Offset(80, 450));
  await tester.pumpAndSettle();
}

Future<void> _openSettings(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('reader.settings')));
  await tester.pumpAndSettle();
}

Future<void> _tapInSheet(WidgetTester tester, String key) async {
  final target = find.byKey(Key(key));
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

void main() {
  group('çubuklar (M2-13)', () {
    testWidgets('dokununca gizlenir ve görünür; kendiliğinden kapanmaz', (
      tester,
    ) async {
      await _openReader(tester, '/read?page=5');
      expect(_topBar, findsOneWidget);
      expect(_bottomBar, findsOneWidget);

      // Beş dakika dokunulmasa da çubuklar açık kalır.
      await tester.pump(const Duration(minutes: 5));
      expect(_topBar, findsOneWidget);

      await _tapEmpty(tester);
      expect(_topBar, findsNothing);
      expect(_bottomBar, findsNothing);

      await _tapEmpty(tester);
      expect(_topBar, findsOneWidget);
      expect(_bottomBar, findsOneWidget);
    });

    testWidgets('çubuklar açıkken kelimeye dokunuş yalnızca çubukları kapatır; '
        'kapalıyken kelimeyi seçer', (tester) async {
      await _openReader(tester, '/read?page=5');
      final word = find.text('آية 2:33');
      final selected = find.byKey(const Key('reader.selectedWord'));
      await tester.tap(word);
      await tester.pumpAndSettle();
      expect(_topBar, findsNothing);
      expect(selected, findsNothing);

      await tester.tap(word);
      await tester.pumpAndSettle();
      expect(selected, findsOneWidget);
      expect(_topBar, findsNothing);

      // Sayfanın üst bilgi şeridi boş alandır: çubukları açar.
      await tester.tap(find.byKey(const Key('reader.pageHeader.5')));
      await tester.pumpAndSettle();
      expect(_topBar, findsOneWidget);
    });
  });

  group('göstergeler (M2-04, M2-05)', () {
    testWidgets('çubuklar gizliyken cüz, hizb, sayfa ve sağ/sol görünür', (
      tester,
    ) async {
      await _openReader(tester, '/read?page=5');
      await _tapEmpty(tester);
      expect(_topBar, findsNothing);
      expect(
        tester.widget<Text>(find.byKey(const Key('reader.pageHeader.5'))).data,
        'Cüz 1 · Hizb 1',
      );
      final footer = find.byKey(const Key('reader.pageFooter.5'));
      expect(
        find.descendant(of: footer, matching: find.text('5')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: footer, matching: find.text('Sağ sayfa')),
        findsOneWidget,
      );
      // Komşu sayfa da hazır çizilir; çift sayfa soldadır.
      expect(
        find.descendant(
          of: find.byKey(const Key('reader.pageFooter.6'), skipOffstage: false),
          matching: find.text('Sol sayfa', skipOffstage: false),
        ),
        findsOneWidget,
      );
    });

    testWidgets('rubu\' başı ve secde ayeti sayfa altında işaretlenir', (
      tester,
    ) async {
      // Sahte veride 2:26 rubu' başıdır (sayfa 4); 2:35 secde sayılır.
      await _openReader(
        tester,
        '/read?page=4',
        sajdahs: {const AyahRef(2, 35)},
      );
      String marks(int page) => switch (tester.widget(
        find.byKey(Key('reader.pageMarks.$page'), skipOffstage: false),
      )) {
        final MushafMarkText t => [
          for (final (mark, label) in t.marks) '${mark.symbol} $label',
        ].join(' | '),
        _ => '',
      };
      expect(marks(4), '۞ Hizb 1 · ¼');
      expect(marks(5), '۩ Secde');
      expect(marks(3), isEmpty);
    });

    testWidgets('ayet görünümü: bilgi satırı, rubu\' ve secde işareti', (
      tester,
    ) async {
      await _openReader(
        tester,
        '/read?ayah=2:25',
        settings: {'reader.viewMode': 'ayah'},
        sajdahs: {const AyahRef(2, 26)},
      );
      expect(
        tester.widget<Text>(find.byKey(const Key('reader.ayahInfo'))).data,
        'Cüz 1 · Hizb 1 · Sayfa 4',
      );
      expect(find.byKey(const Key('reader.quarter.2:26')), findsOneWidget);
      expect(find.byKey(const Key('reader.quarter.2:25')), findsNothing);
      expect(find.byKey(const Key('reader.sajdah.2:26')), findsOneWidget);
      expect(find.byKey(const Key('reader.sajdah.2:25')), findsNothing);
    });
  });

  group('ekran açık (M2-12)', () {
    testWidgets(
      'varsayılan açık; ayardan kapanır; ekrandan çıkınca bırakılır',
      (tester) async {
        final wakeLock = FakeWakeLock();
        await _openReader(tester, '/read?page=5', wakeLock: wakeLock);
        expect(wakeLock.enabled, isTrue);

        await _openSettings(tester);
        await _tapInSheet(tester, 'readerSettings.keepScreenOn');
        expect(wakeLock.enabled, isFalse);
        await _tapInSheet(tester, 'readerSettings.keepScreenOn');
        expect(wakeLock.enabled, isTrue);

        await tester.tapAt(const Offset(200, 40)); // paneli kapat
        await tester.pumpAndSettle();
        await tapBack(tester);
        expect(wakeLock.enabled, isFalse);
      },
    );

    testWidgets('ayar kapalıyken otomatik kaydırma sürerken açık kalır', (
      tester,
    ) async {
      final wakeLock = FakeWakeLock();
      await _openReader(
        tester,
        '/read?page=5',
        wakeLock: wakeLock,
        settings: {'reader.keepScreenOn': false},
      );
      expect(wakeLock.enabled, isFalse);
      await tester.tap(find.byKey(const Key('reader.autoScroll')));
      await tester.pump();
      expect(wakeLock.enabled, isTrue);
      await _tapEmpty(tester);
      expect(wakeLock.enabled, isFalse);
    });
  });

  group('sayfa çevirme (M2-09)', () {
    testWidgets('kenar şeridinden başlayan kaydırma sayfa çevirmez', (
      tester,
    ) async {
      await _openReader(tester, '/read?page=5');
      // Mushaf sağdan sola: parmak soldan sağa kayınca sonraki sayfa gelir.
      await tester.dragFrom(const Offset(5, 450), const Offset(300, 0));
      await tester.pumpAndSettle();
      expect(_anchor(tester), const AyahRef(2, 31));

      await tester.dragFrom(const Offset(60, 450), const Offset(300, 0));
      await tester.pumpAndSettle();
      expect(_anchor(tester), const AyahRef(2, 41));

      // Sağ kenar da şerittir.
      await tester.dragFrom(const Offset(406, 450), const Offset(-300, 0));
      await tester.pumpAndSettle();
      expect(_anchor(tester), const AyahRef(2, 41));
    });

    testWidgets('oklar varsayılan kapalı; açılınca sol sonraki, sağ önceki', (
      tester,
    ) async {
      await _openReader(tester, '/read?page=5');
      expect(find.byKey(const Key('reader.nextPage')), findsNothing);

      await _openSettings(tester);
      await _tapInSheet(tester, 'readerSettings.pageArrows');
      await tester.tapAt(const Offset(200, 40));
      await tester.pumpAndSettle();

      // Çubuklar açıkken oklar alt çubuğun iki ucundadır.
      final next = find.byKey(const Key('reader.nextPage'));
      expect(next, findsOneWidget);
      expect(tester.getCenter(next).dx, lessThan(100));
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(_anchor(tester), const AyahRef(2, 41));

      // Çubuklar gizliyken oklar ekranın alt köşelerinde kalır.
      await _tapEmpty(tester);
      expect(_bottomBar, findsNothing);
      await tester.tap(find.byKey(const Key('reader.previousPage')));
      await tester.pumpAndSettle();
      expect(_anchor(tester), const AyahRef(2, 31));
    });
  });

  group('yazı boyutu ve yakınlaştırma (M2-07)', () {
    InteractiveViewer viewer(WidgetTester tester) =>
        tester.widget(find.byKey(const Key('reader.zoom')));

    testWidgets('iki parmakla yakınlaşır; yakınken sayfa çevrilmez', (
      tester,
    ) async {
      await _openReader(tester, '/read?page=5');
      final a = await tester.startGesture(const Offset(150, 450));
      final b = await tester.startGesture(const Offset(260, 450));
      for (var i = 0; i < 10; i++) {
        await a.moveBy(const Offset(-8, -8));
        await b.moveBy(const Offset(8, 8));
        await tester.pump();
      }
      await a.up();
      await b.up();
      await tester.pumpAndSettle();
      final scale = viewer(tester).transformationController!.value
          .getMaxScaleOnAxis();
      expect(scale, greaterThan(1.2));

      await tester.dragFrom(const Offset(100, 450), const Offset(300, 0));
      await tester.pumpAndSettle();
      expect(_anchor(tester), const AyahRef(2, 31));
    });

    testWidgets('kilit: yazı boyutu düğmeleri ve yakınlaştırma kapanır', (
      tester,
    ) async {
      await _openReader(tester, '/read?page=5');
      expect(viewer(tester).scaleEnabled, isTrue);
      await _openSettings(tester);

      await _tapInSheet(tester, 'readerSettings.textLarger');
      expect(_settings(tester).textScale, 1.25);

      await _tapInSheet(tester, 'readerSettings.textLock');
      expect(_settings(tester).textScaleLocked, isTrue);
      await _tapInSheet(tester, 'readerSettings.textLarger');
      expect(_settings(tester).textScale, 1.25);
      expect(viewer(tester).scaleEnabled, isFalse);
    });
  });

  group('otomatik kaydırma (M2-11)', () {
    testWidgets('sayfa görünümünde ayarlanan sürede sonraki sayfaya geçer; '
        'dokununca durur', (tester) async {
      // Hız 10: sayfa başına 40 sn.
      await _openReader(
        tester,
        '/read?page=5',
        settings: {'reader.autoScrollSpeed': 10},
      );
      await tester.tap(find.byKey(const Key('reader.autoScroll')));
      await tester.pumpAndSettle();
      // Başlayınca çubuklar kapanır.
      expect(_topBar, findsNothing);

      await tester.pump(const Duration(seconds: 38));
      expect(_anchor(tester), const AyahRef(2, 31));
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(_anchor(tester), const AyahRef(2, 41));

      // Dokunuş kaydırmayı durdurur ve çubukları geri getirir.
      await _tapEmpty(tester);
      expect(_topBar, findsOneWidget);
      await tester.pump(const Duration(seconds: 100));
      await tester.pumpAndSettle();
      expect(_anchor(tester), const AyahRef(2, 41));
    });

    testWidgets('ayet görünümünde liste kendiliğinden ilerler', (tester) async {
      await _openReader(
        tester,
        '/read?ayah=2:10',
        settings: {'reader.viewMode': 'ayah', 'reader.autoScrollSpeed': 10},
      );
      expect(_anchor(tester), const AyahRef(2, 10));
      await tester.tap(find.byKey(const Key('reader.autoScroll')));
      for (var i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      final moved = _anchor(tester);
      expect(moved.compareTo(const AyahRef(2, 10)), greaterThan(0));

      await tester.tapAt(const Offset(200, 450));
      await tester.pumpAndSettle();
      final stopped = _anchor(tester);
      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(_anchor(tester), stopped);
      expect(_topBar, findsOneWidget);
    });
  });

  group('renkli tecvid (M2-06)', () {
    // Sahte depoda her glifin ilk harfi gunne.
    final ghunnah = AppPalette.light.mushaf.tajweed.ghunnah;

    /// Kelimenin çizildiği metindeki renkler.
    Set<Color?> colorsOf(WidgetTester tester, String word) {
      final rich = tester.widget<RichText>(
        find.text(word, findRichText: true).first,
      );
      final colors = <Color?>{};
      rich.text.visitChildren((span) {
        if (span is TextSpan && span.text != null) {
          colors.add(span.style?.color);
        }
        return true;
      });
      return colors;
    }

    testWidgets('varsayılan kapalı; panelden açılınca harf renklenir, '
        'kapanınca renksiz', (tester) async {
      await _openReader(tester, '/read?page=5');
      expect(_settings(tester).tajweed, isFalse);
      expect(colorsOf(tester, 'آية 2:33'), isNot(contains(ghunnah)));

      await _openSettings(tester);
      await _tapInSheet(tester, 'readerSettings.tajweed');
      expect(_settings(tester).tajweed, isTrue);
      expect(colorsOf(tester, 'آية 2:33'), contains(ghunnah));

      await _tapInSheet(tester, 'readerSettings.tajweed');
      expect(colorsOf(tester, 'آية 2:33'), isNot(contains(ghunnah)));
    });

    testWidgets('kelimeye dokununca kural adı; dokununca açıklama, oradan '
        'tüm renkler', (tester) async {
      await _openReader(
        tester,
        '/read?page=5',
        settings: {'reader.tajweed': true},
      );
      await _tapEmpty(tester); // çubukları kapat
      await tester.tap(find.text('آية 2:33', findRichText: true).first);
      await tester.pumpAndSettle();
      final chip = find.byKey(const Key('reader.tajweedRule.ghunnah'));
      expect(chip, findsOneWidget);
      expect(find.text('Gunne'), findsOneWidget);

      await tester.tap(chip);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('tajweed.rule.ghunnah')), findsOneWidget);
      expect(find.textContaining('genizden okunur'), findsOneWidget);

      await tester.tap(find.byKey(const Key('tajweed.allColors')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('tajweed.legend')), findsOneWidget);
      expect(find.text('Okunmayan harfler'), findsOneWidget);
    });

    testWidgets('tecvid kapalıyken kelime seçiminde kural gösterilmez', (
      tester,
    ) async {
      await _openReader(tester, '/read?page=5');
      await _tapEmpty(tester);
      await tester.tap(find.text('آية 2:33', findRichText: true).first);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('reader.selectedWord')), findsOneWidget);
      expect(find.byKey(const Key('reader.tajweedRule.ghunnah')), findsNothing);
    });

    testWidgets('ayet görünümünde de renkli', (tester) async {
      await _openReader(
        tester,
        '/read?ayah=2:10',
        settings: {'reader.viewMode': 'ayah', 'reader.tajweed': true},
      );
      expect(colorsOf(tester, 'آية 2:10'), contains(ghunnah));
    });

    testWidgets('renk açıklamaları: 18 kural ve kaynak; erişilebilirlik', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await _openReader(tester, '/read?page=5');
      await _openSettings(tester);
      await _tapInSheet(tester, 'readerSettings.tajweedLegend');
      final legend = find.byKey(const Key('tajweed.legend'));
      expect(legend, findsOneWidget);
      for (final rule in TajweedRule.values) {
        final item = find.byKey(Key('tajweed.rule.${rule.name}'));
        await tester.scrollUntilVisible(
          item,
          120,
          scrollable: find
              .descendant(of: legend, matching: find.byType(Scrollable))
              .first,
        );
        expect(item, findsOneWidget, reason: rule.name);
      }
      expect(find.textContaining('CC BY 4.0'), findsOneWidget);
      for (final guideline in [
        labeledTapTargetGuideline,
        androidTapTargetGuideline,
        textContrastGuideline,
      ]) {
        await expectLater(tester, meetsGuideline(guideline));
      }
      handle.dispose();
    });
  });

  group('okuma ayarları paneli (E-10)', () {
    testWidgets('görünüm panelden değişir; okunan ayet korunur (M2-01)', (
      tester,
    ) async {
      await _openReader(tester, '/read?ayah=2:35');
      await _openSettings(tester);
      await _tapInSheet(tester, 'readerSettings.view.ayah');
      expect(_settings(tester).viewMode, ReaderViewMode.ayah);
      expect(_anchor(tester), const AyahRef(2, 35));

      await _tapInSheet(tester, 'readerSettings.view.page');
      expect(_settings(tester).viewMode, ReaderViewMode.page);
      expect(_anchor(tester), const AyahRef(2, 35));
    });

    testWidgets('hız ve yazı boyutu kaydırıcıları ayarı değiştirir', (
      tester,
    ) async {
      await _openReader(tester, '/read?page=5');
      await _openSettings(tester);
      final speed = find.byKey(const Key('readerSettings.autoScrollSpeed'));
      await tester.ensureVisible(speed);
      await tester.pumpAndSettle();
      // Kaydırıcının sol ucu en yavaş (1) kademedir.
      await tester.tapAt(tester.getTopLeft(speed) + const Offset(30, 24));
      await tester.pumpAndSettle();
      expect(_settings(tester).autoScrollSpeed, 1);
    });

    testWidgets('erişilebilirlik: etiket, dokunma alanı, kontrast', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await _openReader(tester, '/read?page=5');
      Future<void> check(String where) async {
        for (final guideline in [
          labeledTapTargetGuideline,
          androidTapTargetGuideline,
          iOSTapTargetGuideline,
          textContrastGuideline,
        ]) {
          await expectLater(tester, meetsGuideline(guideline), reason: where);
        }
      }

      await check('okuma, çubuklar açık');
      await _tapEmpty(tester);
      await check('okuma, çubuklar gizli');
      await _tapEmpty(tester);
      await _openSettings(tester);
      await check('okuma ayarları');
      handle.dispose();
    });
  });
}
