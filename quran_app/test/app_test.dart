import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/app.dart';
import 'package:quran_app/core/config/flavor.dart';
import 'package:quran_app/core/config/flavor_provider.dart';
import 'package:quran_app/features/home/presentation/home_page.dart';
import 'package:quran_app/features/quran/application/quran_providers.dart';
import 'package:quran_app/features/reader/presentation/reader_page.dart';
import 'package:quran_app/features/settings/presentation/settings_page.dart';

import 'helpers/fake_quran_repository.dart';
import 'helpers/localized_app.dart';

Widget _app(Flavor flavor) => ProviderScope(
  overrides: [
    flavorProvider.overrideWithValue(flavor),
    quranRepositoryProvider.overrideWithValue(FakeQuranRepository()),
  ],
  child: const QuranApp(),
);

void main() {
  setUp(() {
    // Sure adları Türkçe görünsün diye cihaz dili Türkçe.
    TestWidgetsFlutterBinding.instance.platformDispatcher.localesTestValue =
        const [Locale('tr', 'TR')];
    addTearDown(
      TestWidgetsFlutterBinding
          .instance
          .platformDispatcher
          .clearLocalesTestValue,
    );
  });

  for (final flavor in Flavor.values) {
    testWidgets('uygulama ${flavor.name} ortamında ana sayfayla açılır', (
      tester,
    ) async {
      await tester.pumpWidget(_app(flavor));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text('Bakara'), findsOneWidget);
    });
  }

  testWidgets('ana sayfadan okuma ve ayarlar ekranına gidilir', (tester) async {
    await tester.pumpWidget(_app(Flavor.dev));

    await tester.tap(find.byKey(const Key('home.read')));
    await tester.pumpAndSettle();
    expect(find.byType(ReaderPage), findsOneWidget);

    await tapBack(tester);
    await tester.tap(find.byKey(const Key('home.settings')));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsOneWidget);
  });
}
