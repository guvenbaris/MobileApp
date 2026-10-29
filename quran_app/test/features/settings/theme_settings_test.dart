import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/app.dart';
import 'package:quran_app/core/config/flavor.dart';
import 'package:quran_app/core/config/flavor_provider.dart';
import 'package:quran_app/core/database/user_database.dart';
import 'package:quran_app/core/theme/app_theme.dart';
import 'package:quran_app/core/widgets/state_views.dart';
import 'package:quran_app/features/quran/application/quran_providers.dart';
import 'package:quran_app/features/reader/presentation/reader_page.dart';
import 'package:quran_app/features/settings/application/theme_settings.dart';
import 'package:quran_app/features/settings/presentation/settings_page.dart';
import 'package:quran_app/features/today/presentation/today_page.dart';
import 'package:quran_app/features/user_data/application/user_data_providers.dart';

import '../../helpers/fake_quran_repository.dart';
import '../../helpers/localized_app.dart';

Widget _app({Map<String, Object?> settings = const {}}) => ProviderScope(
  overrides: [
    flavorProvider.overrideWithValue(Flavor.dev),
    quranRepositoryProvider.overrideWithValue(FakeQuranRepository()),
    userDataSnapshotProvider.overrideWithValue(
      UserDataSnapshot(settings: settings),
    ),
  ],
  child: const QuranApp(),
);

AppThemeId _themeOf(WidgetTester tester, Type screen) =>
    Theme.of(tester.element(find.byType(screen))).extension<AppPalette>()!.id;

/// Okuma ekranının arka planı mushaf sayfasının rengidir.
Color? _readerBackground(WidgetTester tester) => tester
    .widget<Scaffold>(
      find.descendant(
        of: find.byType(ReaderPage),
        matching: find.byType(Scaffold),
      ),
    )
    .backgroundColor;

Color _scaffoldColor(WidgetTester tester, Type screen) =>
    Theme.of(tester.element(find.byType(screen))).scaffoldBackgroundColor;

void main() {
  setUp(() {
    final dispatcher = TestWidgetsFlutterBinding.instance.platformDispatcher;
    dispatcher.localesTestValue = const [Locale('tr', 'TR')];
    addTearDown(dispatcher.clearLocalesTestValue);
    addTearDown(dispatcher.clearPlatformBrightnessTestValue);
  });

  testWidgets('cihaz ayarı: cihaz açık moddaysa açık, koyudaysa koyu tema', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    expect(_themeOf(tester, TodayPage), AppThemeId.light);

    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    expect(_themeOf(tester, TodayPage), AppThemeId.dark);
    expect(_scaffoldColor(tester, TodayPage), AppPalette.dark.background);
  });

  for (final id in AppThemeId.values) {
    testWidgets('ayarlardan ${id.name} seçilince tüm ekranlar o temada', (
      tester,
    ) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('today.settings')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('settings.theme.${id.name}')));
      await tester.pumpAndSettle();
      expect(_themeOf(tester, SettingsPage), id);

      await tapBack(tester);
      expect(_scaffoldColor(tester, TodayPage), AppPalette.of(id).background);

      await tester.tap(find.byKey(const Key('today.continue')));
      await tester.pumpAndSettle();
      // Mushaf sayfası da aynı temada (koyuda metin alanı da koyu, M2-08).
      expect(_readerBackground(tester), AppPalette.of(id).mushaf.background);
      // Sahte depo sayfa vermediği için hata durumu bileşeni görünür.
      expect(find.byType(ErrorState), findsWidgets);
    });
  }

  testWidgets(
    'okuma ayarları panelinden tema seçilir, anında uygulanır (E-10)',
    (tester) async {
      await tester.pumpWidget(
        _app(settings: {ThemeSettingsNotifier.key: 'light'}),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('today.continue')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('reader.settings')));
      await tester.pumpAndSettle();

      final seen = <Color>[];
      for (final id in [AppThemeId.sepia, AppThemeId.dark, AppThemeId.light]) {
        await tester.tap(find.byKey(Key('readerSettings.theme.${id.name}')));
        await tester.pumpAndSettle();
        seen.add(_readerBackground(tester)!);
      }
      expect(seen, [
        AppPalette.sepia.mushaf.background,
        AppPalette.dark.mushaf.background,
        AppPalette.light.mushaf.background,
      ]);
    },
  );

  group('erişilebilirlik kuralları (NF-E01, NF-E03)', () {
    for (final id in AppThemeId.values) {
      testWidgets('${id.name}: dokunma alanı ≥ 48, metin kontrastı AA', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          _app(settings: {ThemeSettingsNotifier.key: id.name}),
        );
        await tester.pumpAndSettle();

        Future<void> check() async {
          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
          await expectLater(tester, meetsGuideline(textContrastGuideline));
        }

        await check(); // ana sayfa
        await tester.tap(find.byKey(const Key('today.settings')));
        await tester.pumpAndSettle();
        await check(); // ayarlar
        handle.dispose();
      });
    }
  });

  group('kalıcılık (M13-02)', () {
    test('tema seçimi yeniden açılışta korunur', () async {
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      final db = UserDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      Future<ProviderContainer> open() async => ProviderContainer(
        overrides: [
          userDatabaseProvider.overrideWithValue(db),
          userDataSnapshotProvider.overrideWithValue(
            await UserDataSnapshot.load(db),
          ),
        ],
      );

      final first = await open();
      expect(first.read(themeSettingsProvider), ThemePreference.system);
      first.read(themeSettingsProvider.notifier).set(ThemePreference.sepia);
      first.dispose();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final second = await open();
      addTearDown(second.dispose);
      expect(second.read(themeSettingsProvider), ThemePreference.sepia);
    });
  });
}
