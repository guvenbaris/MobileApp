import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/theme/app_theme.dart';
import 'package:quran_app/features/quran/domain/mushaf_page.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';
import 'package:quran_app/features/reader/application/reader_providers.dart';
import 'package:quran_app/features/reader/presentation/mushaf_page_view.dart';

import '../../helpers/fake_quran_repository.dart';
import '../../helpers/localized_app.dart';

PageGlyph _glyph(String text, List<int> positions) => PageGlyph(
  glyph: '',
  digitalKhattText: text,
  words: [for (final p in positions) WordRef(37, 130, p)],
);

final _page = MushafPage(
  layoutId: 'test',
  number: 451,
  firstAyah: const AyahRef(37, 130),
  juz: 23,
  hizb: 45,
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
      words: const [],
      glyphs: [
        _glyph('سَلَٰمٌ', [1]),
        _glyph('عَلَىٰٓ', [2]),
        // Tek glif iki kelimeyi kapsar (37:130 "إِلۡ يَاسِينَ").
        _glyph('إِلْيَاسِينَ', [3, 4]),
      ],
    ),
  ],
);

Widget _host() => ProviderScope(
  child: localizedApp(
    MushafPageView(
      page: _page,
      surahs: {for (final s in FakeQuranRepository.surahs) s.id: s},
      basmala: 'بِسْمِ ٱللَّهِ',
      colors: AppPalette.sepia.mushaf,
    ),
  ),
);

void main() {
  testWidgets('sure başlığı ve satırdaki glif birimleri çizilir', (
    tester,
  ) async {
    await tester.pumpWidget(_host());
    expect(find.text('سُورَةُ الفاتحة'), findsOneWidget);
    expect(find.text('عَلَىٰٓ'), findsOneWidget);
  });

  testWidgets(
    'dokunulan birimin ilk kelimesi seçilir, tekrar dokununca kalkar',
    (tester) async {
      await tester.pumpWidget(_host());
      final container = ProviderScope.containerOf(
        tester.element(find.byType(MushafPageView)),
      );

      await tester.tap(find.text('عَلَىٰٓ'));
      await tester.pump();
      expect(container.read(selectedWordProvider), const WordRef(37, 130, 2));

      await tester.tap(find.text('عَلَىٰٓ'));
      await tester.pump();
      expect(container.read(selectedWordProvider), isNull);

      // İki kelimelik glif: ilk kelime seçilir.
      await tester.tap(find.text('إِلْيَاسِينَ'));
      await tester.pump();
      expect(container.read(selectedWordProvider), const WordRef(37, 130, 3));
    },
  );
}
