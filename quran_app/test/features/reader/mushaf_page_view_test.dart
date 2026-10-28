import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/quran/domain/mushaf_page.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';
import 'package:quran_app/features/reader/application/reader_providers.dart';
import 'package:quran_app/features/reader/application/reader_settings.dart';
import 'package:quran_app/features/reader/presentation/mushaf_colors.dart';
import 'package:quran_app/features/reader/presentation/mushaf_page_view.dart';

import '../../helpers/fake_quran_repository.dart';

PageWord _word(int position, String text, {bool end = false}) =>
    PageWord(ref: WordRef(1, 1, position), text: text, isAyahEnd: end);

final _page = MushafPage(
  layoutId: 'test',
  number: 1,
  firstAyah: const AyahRef(1, 1),
  juz: 1,
  hizb: 1,
  lines: [
    const MushafLine(
      number: 1,
      type: LayoutLineType.surahName,
      isCentered: true,
      surah: 1,
      words: [],
      glyphs: [],
    ),
    MushafLine(
      number: 2,
      type: LayoutLineType.ayah,
      isCentered: true,
      words: [
        _word(1, 'بِسۡمِ'),
        _word(2, 'ٱللَّهِ'),
        _word(3, '١', end: true),
      ],
      glyphs: const [],
    ),
  ],
);

Widget _host() => ProviderScope(
  child: MaterialApp(
    home: Consumer(
      builder: (context, ref, _) => MushafPageView(
        page: _page,
        surahs: {for (final s in FakeQuranRepository.surahs) s.id: s},
        basmala: 'بِسۡمِ ٱللَّهِ',
        renderMode: MushafRenderMode.unicodeFont,
        colors: MushafColors.of(MushafTheme.sepia),
      ),
    ),
  ),
);

void main() {
  testWidgets('sure başlığı ve satırdaki kelimeler çizilir', (tester) async {
    await tester.pumpWidget(_host());
    expect(find.text('سُورَةُ الفاتحة'), findsOneWidget);
    expect(find.text('ٱللَّهِ'), findsOneWidget);
  });

  testWidgets('kelimeye dokununca konumu seçilir, tekrar dokununca kalkar', (
    tester,
  ) async {
    await tester.pumpWidget(_host());
    final container = ProviderScope.containerOf(
      tester.element(find.byType(MushafPageView)),
    );

    await tester.tap(find.text('ٱللَّهِ'));
    await tester.pump();
    expect(container.read(selectedWordProvider), const WordRef(1, 1, 2));

    await tester.tap(find.text('ٱللَّهِ'));
    await tester.pump();
    expect(container.read(selectedWordProvider), isNull);
  });
}
