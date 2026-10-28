import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:quran_app/app.dart';
import 'package:quran_app/core/config/flavor.dart';
import 'package:quran_app/core/config/flavor_provider.dart';
import 'package:quran_app/features/home/presentation/home_page.dart';
import 'package:quran_app/features/reader/presentation/reader_page.dart';

/// Gerçek cihazda/emülatörde uygulamanın açıldığını doğrular.
/// Çalıştırma: `flutter test integration_test --flavor dev`
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('uygulama açılır ve okuma ekranına gidilir', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [flavorProvider.overrideWithValue(Flavor.dev)],
        child: const QuranApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);

    await tester.tap(find.byKey(const Key('home.read')));
    await tester.pumpAndSettle();
    expect(find.byType(ReaderPage), findsOneWidget);
  });
}
