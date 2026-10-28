import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/app.dart';
import 'package:quran_app/core/config/flavor.dart';
import 'package:quran_app/core/config/flavor_provider.dart';
import 'package:quran_app/core/database/user_database.dart';
import 'package:quran_app/core/l10n/app_language.dart';
import 'package:quran_app/features/quran/application/quran_providers.dart';
import 'package:quran_app/features/reader/presentation/reader_page.dart';
import 'package:quran_app/features/settings/application/locale_settings.dart';
import 'package:quran_app/features/settings/presentation/settings_page.dart';
import 'package:quran_app/features/today/presentation/today_page.dart';
import 'package:quran_app/features/user_data/application/user_data_providers.dart';

import '../../helpers/fake_quran_repository.dart';
import '../../helpers/localized_app.dart';

Widget _app({UserDataSnapshot snapshot = const UserDataSnapshot()}) =>
    ProviderScope(
      overrides: [
        flavorProvider.overrideWithValue(Flavor.dev),
        quranRepositoryProvider.overrideWithValue(FakeQuranRepository()),
        userDataSnapshotProvider.overrideWithValue(snapshot),
      ],
      child: const QuranApp(),
    );

TextDirection _directionOf(WidgetTester tester, Type screen) =>
    Directionality.of(tester.element(find.byType(screen)));

Future<void> _openSettings(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('today.settings')));
  await tester.pumpAndSettle();
}

Future<void> _choose(WidgetTester tester, String key) async {
  // Seçenek ekranın altında kalabilir; önce görünene kadar kaydırılır.
  await tester.scrollUntilVisible(
    find.byKey(Key(key)),
    100,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.ensureVisible(find.byKey(Key(key)));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    // Test ortamının cihaz dili Türkçe olsun.
    TestWidgetsFlutterBinding.instance.platformDispatcher.localesTestValue =
        const [Locale('tr', 'TR')];
    addTearDown(
      TestWidgetsFlutterBinding
          .instance
          .platformDispatcher
          .clearLocalesTestValue,
    );
  });

  testWidgets('cihaz dili izlenir: Türkçe cihazda arayüz Türkçe', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    expect(find.text('Bugün'), findsWidgets);
    expect(_directionOf(tester, TodayPage), TextDirection.ltr);
    await openTab(tester, 'quran');
    expect(find.text('Bakara'), findsOneWidget);
    expect(find.text('Medenî · 286 ayet'), findsOneWidget);
  });

  testWidgets('desteklenmeyen cihaz dilinde İngilizce açılır', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('de', 'DE')];
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    expect(find.text('Today'), findsWidgets);
    await openTab(tester, 'quran');
    expect(find.text('Al-Baqarah'), findsOneWidget);
    expect(find.text('Medinan · 286 verses'), findsOneWidget);
  });

  testWidgets(
    'Arapça seçilince tüm iskelet ekranları Arapça ve sağdan sola (M13-01)',
    (tester) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      await _openSettings(tester);
      await _choose(tester, 'settings.language.ar');

      // Ayarlar ekranı hemen Arapçaya ve RTL'ye geçer.
      expect(find.text('الإعدادات'), findsOneWidget);
      expect(_directionOf(tester, SettingsPage), TextDirection.rtl);

      await tapBack(tester);
      expect(find.text('اليوم'), findsWidgets);
      expect(find.text('ابدأ القراءة'), findsOneWidget);
      expect(_directionOf(tester, TodayPage), TextDirection.rtl);
      // RTL'de sekme sırası aynalanır: Bugün en sağda, Ben en solda.
      final todayTab = tester.getCenter(find.byKey(const Key('tab.today')));
      final meTab = tester.getCenter(find.byKey(const Key('tab.me')));
      expect(todayTab.dx, greaterThan(meTab.dx));

      await openTab(tester, 'quran');
      // Sure adı Arapça, sayılar Doğu Arap rakamıyla (NF-Y03).
      expect(find.text('البقرة'), findsOneWidget);
      expect(find.text('مدنية · ٢٨٦ آية'), findsOneWidget);
      expect(find.text('مكية · ٧ آيات'), findsOneWidget);
      // RTL'de ListTile'ın başı (sure numarası) sağda olur.
      final number = tester.getCenter(find.text('٢'));
      final name = tester.getCenter(find.text('البقرة'));
      expect(number.dx, greaterThan(name.dx));

      await openTab(tester, 'today');

      await tester.tap(find.byKey(const Key('today.continue')));
      await tester.pumpAndSettle();
      expect(_directionOf(tester, ReaderPage), TextDirection.rtl);
      expect(find.textContaining('الصفحة ١'), findsOneWidget);
    },
  );

  testWidgets('rakam seçimi dilden bağımsız uygulanır (NF-Y03)', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    await _openSettings(tester);
    await _choose(tester, 'settings.numerals.arabic');
    await tapBack(tester);
    await openTab(tester, 'quran');
    expect(find.text('Bakara'), findsOneWidget);
    expect(find.text('Medenî · ٢٨٦ ayet'), findsOneWidget);
  });

  testWidgets('İngilizceye geçiş ve geri cihaz diline dönüş', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    await _openSettings(tester);
    await _choose(tester, 'settings.language.en');
    expect(find.text('Settings'), findsOneWidget);
    await _choose(tester, 'settings.language.system');
    expect(find.text('Ayarlar'), findsOneWidget);
  });

  group('kalıcılık (M13-02)', () {
    late UserDatabase db;

    setUp(() {
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      db = UserDatabase(NativeDatabase.memory());
      addTearDown(db.close);
    });

    Future<ProviderContainer> openSession() async {
      final snapshot = await UserDataSnapshot.load(db);
      return ProviderContainer(
        overrides: [
          userDatabaseProvider.overrideWithValue(db),
          userDataSnapshotProvider.overrideWithValue(snapshot),
        ],
      );
    }

    test('dil ve rakam seçimi yeniden açılışta korunur', () async {
      final first = await openSession();
      expect(first.read(localeSettingsProvider).language, AppLanguage.system);
      first.read(localeSettingsProvider.notifier)
        ..setLanguage(AppLanguage.ar)
        ..setNumerals(NumeralSystem.western);
      first.dispose();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final second = await openSession();
      addTearDown(second.dispose);
      final settings = second.read(localeSettingsProvider);
      expect(settings.language, AppLanguage.ar);
      expect(settings.numerals, NumeralSystem.western);
    });

    testWidgets('kayıtlı dil ilk karede uygulanır', (tester) async {
      await tester.pumpWidget(
        _app(
          snapshot: const UserDataSnapshot(
            settings: {LocaleSettingsNotifier.languageKey: 'en'},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Today'), findsWidgets);
    });
  });
}
