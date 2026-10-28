import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/quran/application/quran_providers.dart';
import 'package:quran_app/features/reader/presentation/reader_page.dart';

import '../../helpers/fake_quran_repository.dart';
import '../../helpers/localized_app.dart';

Widget _reader(int page) => ProviderScope(
  overrides: [quranRepositoryProvider.overrideWithValue(FakeQuranRepository())],
  child: localizedApp(ReaderPage(initialPage: page)),
);

Future<void> _setScreen(WidgetTester tester, Size logical) async {
  tester.view.devicePixelRatio = 2;
  tester.view.physicalSize = logical * 2;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('telefonda tek sayfa gösterilir', (tester) async {
    await _setScreen(tester, const Size(411, 914));
    await tester.pumpWidget(_reader(5));
    await tester.pump();
    expect(find.byKey(const ValueKey('reader.spread.2')), findsNothing);
    expect(find.text('Sayfa 5'), findsOneWidget);
  });

  testWidgets('yatay tablette çift sayfa: 5. sayfa 5–6 açılımında', (
    tester,
  ) async {
    await _setScreen(tester, const Size(1280, 800));
    await tester.pumpWidget(_reader(5));
    await tester.pump();
    // Açılımlar: (1,2), (3,4), (5,6) → 5. sayfa 2 numaralı açılımda.
    expect(find.byKey(const ValueKey('reader.spread.2')), findsOneWidget);
  });

  testWidgets('döndürünce okunan sayfa değişmez (M2-10)', (tester) async {
    await _setScreen(tester, const Size(800, 1280));
    await tester.pumpWidget(_reader(5));
    await tester.pump();
    expect(find.byKey(const ValueKey('reader.spread.2')), findsNothing);

    await _setScreen(tester, const Size(1280, 800));
    await tester.pump();
    await tester.pump();
    expect(find.byKey(const ValueKey('reader.spread.2')), findsOneWidget);

    await _setScreen(tester, const Size(800, 1280));
    await tester.pump();
    await tester.pump();
    expect(find.text('Sayfa 5'), findsOneWidget);
  });
}
