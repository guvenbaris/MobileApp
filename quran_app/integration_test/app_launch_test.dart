import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:quran_app/app.dart';
import 'package:quran_app/core/config/flavor.dart';
import 'package:quran_app/core/config/flavor_provider.dart';
import 'package:quran_app/features/home/presentation/home_page.dart';
import 'package:quran_app/features/quran/application/quran_providers.dart';
import 'package:quran_app/features/quran/data/content_database_opener.dart';
import 'package:quran_app/features/reader/presentation/reader_page.dart';

/// Gerçek cihazda/emülatörde uygulamanın açıldığını ve paketteki içerik
/// veritabanının internetsiz okunduğunu doğrular (F0-03, M16-01).
/// Çalıştırma: `flutter test integration_test --flavor dev`
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('uygulama sure listesiyle açılır ve okuma ekranına gidilir', (
    tester,
  ) async {
    final contentDb = await openContentDatabase();
    addTearDown(contentDb.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          flavorProvider.overrideWithValue(Flavor.dev),
          contentDatabaseProvider.overrideWithValue(contentDb),
        ],
        child: const QuranApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Fâtiha'), findsOneWidget);

    await tester.tap(find.byKey(const Key('home.read')));
    await tester.pumpAndSettle();
    expect(find.byType(ReaderPage), findsOneWidget);
  });
}
