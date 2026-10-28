import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/app.dart';
import 'package:quran_app/core/config/flavor.dart';
import 'package:quran_app/core/config/flavor_provider.dart';
import 'package:quran_app/core/routing/app_router.dart';
import 'package:quran_app/core/widgets/state_views.dart';
import 'package:quran_app/features/me/presentation/me_page.dart';
import 'package:quran_app/features/memorize/presentation/memorize_page.dart';
import 'package:quran_app/features/quran/application/quran_providers.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';
import 'package:quran_app/features/quran/presentation/quran_index_page.dart';
import 'package:quran_app/features/reader/application/reader_providers.dart';
import 'package:quran_app/features/reader/presentation/reader_page.dart';
import 'package:quran_app/features/today/application/today_providers.dart';
import 'package:quran_app/features/today/presentation/today_page.dart';
import 'package:quran_app/features/user_data/application/user_data_providers.dart';

import '../helpers/fake_quran_repository.dart';
import '../helpers/localized_app.dart';

/// F1-01: uygulama kabuğu ve gezinme (M4-01, M4-07, M6-05).
/// Sahte depoda Fatiha 1. sayfa; Bakara 2. sayfadan başlar, sayfada 10 ayet.
Widget _app({AyahRef? lastRead, DateTime? today}) => ProviderScope(
  overrides: [
    flavorProvider.overrideWithValue(Flavor.dev),
    quranRepositoryProvider.overrideWithValue(FakeQuranRepository()),
    userDataSnapshotProvider.overrideWithValue(
      UserDataSnapshot(
        lastRead: lastRead,
        settings: const {'app.language': 'tr', 'reader.viewMode': 'page'},
      ),
    ),
    if (today != null) clockProvider.overrideWithValue(() => today),
  ],
  child: const QuranApp(),
);

String _readerTitle(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const Key('reader.title'))).data!;

ProviderContainer _container(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(QuranApp)));

Future<void> _go(WidgetTester tester, String location) async {
  _container(tester).read(appRouterProvider).go(location);
  await tester.pumpAndSettle();
}

Future<void> _submitJump(WidgetTester tester, String text) async {
  await tester.enterText(find.byKey(const Key('quran.jump')), text);
  await tester.testTextInput.receiveAction(TextInputAction.go);
  await tester.pumpAndSettle();
}

void main() {
  group('sekmeler', () {
    testWidgets('dört sekme; her biri kendi ekranını açar', (tester) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      expect(find.byType(TodayPage), findsOneWidget);

      await openTab(tester, 'quran');
      expect(find.byType(QuranIndexPage), findsOneWidget);
      await openTab(tester, 'memorize');
      expect(find.byType(MemorizePage), findsOneWidget);
      expect(find.byType(EmptyState), findsOneWidget);
      await openTab(tester, 'me');
      expect(find.byType(MePage), findsOneWidget);
    });

    testWidgets('sekme değişince önceki sekmenin durumu korunur', (
      tester,
    ) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      await openTab(tester, 'quran');
      await tester.tap(find.byKey(const Key('quran.tab.juz')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('quran.juzList')), findsOneWidget);

      await openTab(tester, 'me');
      await openTab(tester, 'quran');
      expect(find.byKey(const Key('quran.juzList')), findsOneWidget);
    });

    testWidgets('okuma ekranı sekmelerin üstünde açılır, geri açtığı sekmeye '
        'döner', (tester) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      await openTab(tester, 'quran');
      await tester.tap(find.byKey(const Key('quran.surah.2')));
      await tester.pumpAndSettle();
      expect(find.byType(ReaderPage), findsOneWidget);
      expect(find.byKey(const Key('tab.today')), findsNothing);

      await tapBack(tester);
      expect(find.byType(QuranIndexPage), findsOneWidget);
    });
  });

  group('Bugün (E-02, M6-05)', () {
    testWidgets('hiç okunmadıysa "Okumaya başla" Fatiha\'yı açar', (
      tester,
    ) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      expect(find.text('Okumaya başla'), findsOneWidget);
      await tester.tap(find.byKey(const Key('today.continue')));
      await tester.pumpAndSettle();
      expect(_readerTitle(tester), 'Sayfa 1');
    });

    testWidgets('son okunan yere tek dokunuşla dönülür', (tester) async {
      await tester.pumpWidget(_app(lastRead: const AyahRef(2, 150)));
      await tester.pumpAndSettle();
      expect(find.text('Okumaya devam et'), findsOneWidget);
      expect(find.text('Bakara 150 · Sayfa 16 · Cüz 1'), findsOneWidget);
      await tester.tap(find.byKey(const Key('today.continue')));
      await tester.pumpAndSettle();
      expect(_readerTitle(tester), 'Sayfa 16');
      expect(
        _container(tester).read(readerAnchorProvider),
        const AyahRef(2, 150),
      );
    });

    testWidgets('günün ayeti tarihe göre seçilir ve okuma ekranında açılır', (
      tester,
    ) async {
      // 2026-01-01 → 0. gün → Kur'an'ın ilk ayeti (sahte depoda 2 sure).
      await tester.pumpWidget(_app(today: DateTime(2026)));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('today.dailyAyah')), findsOneWidget);
      expect(find.text('Fâtiha 1'), findsOneWidget);

      await tester.tap(find.byKey(const Key('today.dailyAyah.read')));
      await tester.pumpAndSettle();
      expect(_readerTitle(tester), 'Sayfa 1');
    });
  });

  group('Kur\'an dizini (E-03, M4-01)', () {
    testWidgets('sure satırı surenin başını açar', (tester) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      await openTab(tester, 'quran');
      await tester.tap(find.byKey(const Key('quran.surah.2')));
      await tester.pumpAndSettle();
      expect(_readerTitle(tester), 'Sayfa 2');
    });

    testWidgets('atlama kutusu: 2:25 ayete, 7 sayfaya gider; geçersizde '
        'uyarı', (tester) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      await openTab(tester, 'quran');

      await _submitJump(tester, '2:25');
      expect(_readerTitle(tester), 'Sayfa 4');
      await tapBack(tester);

      await _submitJump(tester, '7');
      expect(_readerTitle(tester), 'Sayfa 7');
      await tapBack(tester);

      await _submitJump(tester, '2:300');
      expect(find.byType(ReaderPage), findsNothing);
      expect(find.textContaining('Bulunamadı'), findsOneWidget);
    });

    testWidgets('cüz listesinde rubu\' başlangıcına gidilir', (tester) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      await openTab(tester, 'quran');
      await tester.tap(find.byKey(const Key('quran.tab.juz')));
      await tester.pumpAndSettle();
      expect(find.text('2. Cüz'), findsOneWidget);

      await tester.tap(find.byKey(const Key('quran.juz.2')));
      await tester.pumpAndSettle();
      expect(find.text('Hizb 3'), findsOneWidget);
      await tester.tap(find.byKey(const Key('quran.rub.9')));
      await tester.pumpAndSettle();
      expect(_readerTitle(tester), 'Sayfa 16');
    });

    testWidgets('sayfa ızgarasından sayfa açılır', (tester) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      await openTab(tester, 'quran');
      await tester.tap(find.byKey(const Key('quran.tab.page')));
      await tester.pumpAndSettle();
      // Sayfa numarası tek satırda (dar hücrede alt alta kırılmaz).
      final one = tester.getSize(find.text('1')).height;
      expect(tester.getSize(find.text('10')).height, one);
      await tester.tap(find.byKey(const Key('quran.page.3')));
      await tester.pumpAndSettle();
      expect(_readerTitle(tester), 'Sayfa 3');
    });

    testWidgets('okuma geçmişi yoksa son okunan şeridi yok', (tester) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      await openTab(tester, 'quran');
      expect(find.byKey(const Key('quran.lastRead')), findsNothing);
    });

    testWidgets('son okunan şeridi konumu gösterir ve oraya götürür', (
      tester,
    ) async {
      await tester.pumpWidget(_app(lastRead: const AyahRef(2, 150)));
      await tester.pumpAndSettle();
      await openTab(tester, 'quran');
      expect(find.text('Son okunan: Bakara 150 · Sayfa 16'), findsOneWidget);
      await tester.tap(find.byKey(const Key('quran.lastRead')));
      await tester.pumpAndSettle();
      expect(_readerTitle(tester), 'Sayfa 16');
    });
  });

  group('derin bağlantı', () {
    testWidgets('/read?ayah=2:255 o ayetin sayfasını açar', (tester) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      await _go(tester, '/read?ayah=2:255');
      expect(_readerTitle(tester), 'Sayfa 27');
      expect(
        _container(tester).read(readerAnchorProvider),
        const AyahRef(2, 255),
      );
    });

    testWidgets('geçersiz ayet veya sayfada hata durumu', (tester) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      for (final link in [
        '/read?ayah=2:300',
        '/read?ayah=abc',
        '/read?page=700',
      ]) {
        await _go(tester, link);
        expect(find.byType(ReaderPage), findsNothing, reason: link);
        expect(find.textContaining('geçerli bir ayete'), findsOneWidget);
      }
    });
  });

  group('Git paneli (M4-07)', () {
    Future<void> openGoTo(WidgetTester tester) async {
      await tester.tap(find.byKey(const Key('reader.goTo')));
      await tester.pumpAndSettle();
    }

    testWidgets('okuma ekranından çıkmadan sayfaya ve ayete gidilir', (
      tester,
    ) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      await _go(tester, '/read?page=1');
      expect(_readerTitle(tester), 'Sayfa 1');

      await openGoTo(tester);
      await tester.enterText(find.byKey(const Key('goTo.page')), '5');
      await tester.tap(find.byKey(const Key('goTo.pageGo')));
      await tester.pumpAndSettle();
      expect(_readerTitle(tester), 'Sayfa 5');
      // Sayfaya gidilince okunan konum sayfanın ilk ayetidir (2:31).
      expect(
        _container(tester).read(readerAnchorProvider),
        const AyahRef(2, 31),
      );

      // Sure seçimi okunan sureyle (Bakara) açılır; ayet 255.
      await openGoTo(tester);
      await tester.enterText(find.byKey(const Key('goTo.ayah')), '255');
      await tester.tap(find.byKey(const Key('goTo.ayahGo')));
      await tester.pumpAndSettle();
      expect(_readerTitle(tester), 'Sayfa 27');
      expect(
        _container(tester).read(readerAnchorProvider),
        const AyahRef(2, 255),
      );
    });

    testWidgets('ayet görünümünde de seçilen ayete gidilir', (tester) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      await _go(tester, '/read?page=1');
      await tester.tap(find.byKey(const Key('reader.viewMode')));
      await tester.pumpAndSettle();

      await openGoTo(tester);
      await tester.enterText(find.byKey(const Key('goTo.page')), '3');
      await tester.tap(find.byKey(const Key('goTo.pageGo')));
      await tester.pumpAndSettle();
      expect(_readerTitle(tester), 'Ayet 2:11');
    });

    testWidgets('geçersiz ayet numarasında panel kapanmaz', (tester) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      await _go(tester, '/read?page=1');
      await openGoTo(tester);
      await tester.enterText(find.byKey(const Key('goTo.ayah')), '99');
      await tester.tap(find.byKey(const Key('goTo.ayahGo')));
      await tester.pumpAndSettle();
      // Fatiha 7 ayet: panel açık kalır, sayfa değişmez.
      expect(find.byKey(const Key('goTo.ayah')), findsOneWidget);
    });
  });
}
