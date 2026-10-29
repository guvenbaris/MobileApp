// F1-04 Renkli tecvid (M2-06): içerik veritabanındaki tecvid aralıkları.
// Kaynak cpfair/quran-tajweed (CC BY 4.0), DigitalKhatt metnine eşlenmiş
// halidir (tool/content/tajweed_alignment.dart).
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/theme/app_theme.dart';
import 'package:quran_app/features/quran/data/content_database.dart';
import 'package:quran_app/features/quran/data/drift_quran_repository.dart';
import 'package:quran_app/features/quran/domain/mushaf_layout.dart';
import 'package:quran_app/features/quran/domain/mushaf_page.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';
import 'package:quran_app/features/quran/domain/tajweed.dart';
import 'package:quran_app/features/reader/presentation/tajweed_text.dart';

import '../helpers/content_db.dart';

void main() {
  late ContentDatabase db;
  late DriftQuranRepository repo;

  setUp(() {
    db = openTestContentDatabase();
    repo = DriftQuranRepository(db);
  });

  Future<PageGlyph> glyphOf(WordRef word) async {
    final page = (await repo.pageOf(
      kDefaultLayout.id,
      word.ayahRef,
    )).valueOrNull!;
    final data = (await repo.getMushafPage(
      kDefaultLayout.id,
      page,
    )).valueOrNull!;
    return data.lines
        .expand((l) => l.glyphs)
        .firstWhere((g) => g.words.contains(word));
  }

  /// (kural, aralıktaki metin) listesi.
  List<(TajweedRule, String)> parts(String text, List<TajweedSpan> spans) => [
    for (final s in spans) (s.rule, text.substring(s.start, s.end)),
  ];

  test('aralıklar glif metninin içinde, sıralı ve örtüşmesiz', () async {
    final glyphs = {
      for (final g in await (db.select(
        db.layoutGlyphs,
      )..where((g) => g.layoutId.equals(kDefaultLayout.id))).get())
        g.id: g.digitalKhattText!,
    };
    final spans =
        await (db.select(db.tajweedSpans)
              ..where((t) => t.layoutId.equals(kDefaultLayout.id))
              ..orderBy([
                (t) => OrderingTerm(expression: t.glyphId),
                (t) => OrderingTerm(expression: t.start),
              ]))
            .get();
    expect(spans.length, greaterThan(70000));
    int? glyph;
    var lastEnd = 0;
    for (final t in spans) {
      final text = glyphs[t.glyphId];
      expect(text, isNotNull, reason: 'glif ${t.glyphId}');
      if (t.glyphId != glyph) {
        glyph = t.glyphId;
        lastEnd = 0;
      }
      expect(t.start, greaterThanOrEqualTo(lastEnd), reason: '${t.glyphId}');
      expect(t.end, greaterThan(t.start));
      expect(t.end, lessThanOrEqualTo(text!.length));
      lastEnd = t.end;
    }
    // 18 kuralın hepsi veride.
    expect(spans.map((t) => t.rule).toSet(), TajweedRule.values.toSet());
  });

  test('renklendirme metni değiştirmez: tüm gliflerde parçalar birleşince '
      'aynı metin', () async {
    final page = <int, List<TajweedSpan>>{};
    for (final t in await (db.select(
      db.tajweedSpans,
    )..where((t) => t.layoutId.equals(kDefaultLayout.id))).get()) {
      (page[t.glyphId] ??= []).add(TajweedSpan(t.start, t.end, t.rule));
    }
    final colors = AppPalette.light.mushaf.tajweed;
    for (final g in await (db.select(
      db.layoutGlyphs,
    )..where((g) => g.layoutId.equals(kDefaultLayout.id))).get()) {
      final spans = (page[g.id] ?? [])..sort((a, b) => a.start - b.start);
      final text = g.digitalKhattText!;
      expect(
        tajweedTextSpan(text, spans, colors).toPlainText(),
        text,
        reason: 'glif ${g.id}',
      );
    }
  });

  group('örnek kelimeler (elle doğrulandı)', () {
    test('2:3 ٱلصَّلَوٰةَ: hemze-i vasl, lâm-ı şemsiyye, okunmaz vav, '
        'tabii med', () async {
      final g = await glyphOf(const WordRef(2, 3, 5));
      expect(parts(g.digitalKhattText!, g.tajweed), [
        (TajweedRule.hamzatWasl, 'ٱ'),
        (TajweedRule.lamShamsiyyah, 'ل'),
        (TajweedRule.silent, 'و'),
        (TajweedRule.madd2, 'ٰ'),
      ]);
    });

    test('2:18 صُمٌّۢ: gunne (şeddeli mim), iklâb (tenvin)', () async {
      final g = await glyphOf(const WordRef(2, 18, 1));
      expect(parts(g.digitalKhattText!, g.tajweed), [
        (TajweedRule.ghunnah, 'مّ'),
        (TajweedRule.iqlab, 'ُۢ'),
      ]);
    });

    test('2:22 بِنَآءً: medd-i muttasıl, tenvinde gunneli idğam', () async {
      final g = await glyphOf(const WordRef(2, 22, 7));
      expect(parts(g.digitalKhattText!, g.tajweed), [
        (TajweedRule.maddMuttasil, 'آ'),
        (TajweedRule.idghaamGhunnah, 'ࣰ'),
      ]);
    });
  });

  test(
    'ayet görünümü: aralıklar ayet metninde aynı harfleri gösterir',
    () async {
      final ayahs = (await repo.getAyahsOfSurah(2)).valueOrNull!;
      final ayah3 = ayahs[2];
      final g = await glyphOf(const WordRef(2, 3, 5));
      // Ayetteki aralıklar arasında ٱلصَّلَوٰةَ kelimesininkiler de var.
      final inAyah = parts(ayah3.textDigitalKhatt, ayah3.tajweed);
      for (final part in parts(g.digitalKhattText!, g.tajweed)) {
        expect(inAyah, contains(part));
      }
      // Her ayette aralıklar ayet metninin içinde.
      for (final a in ayahs) {
        for (final s in a.tajweed) {
          expect(s.end, lessThanOrEqualTo(a.textDigitalKhatt.length));
        }
        expect(
          tajweedTextSpan(
            a.textDigitalKhatt,
            a.tajweed,
            AppPalette.dark.mushaf.tajweed,
          ).toPlainText(),
          a.textDigitalKhatt,
        );
      }
      expect(ayahs.where((a) => a.tajweed.isNotEmpty), isNotEmpty);
    },
  );

  test('tecvid kaynağı içerik kaydında', () async {
    final source = await (db.select(
      db.contentMeta,
    )..where((m) => m.key.equals(ContentMetaKeys.source))).getSingle();
    expect(source.value, contains('cpfair/quran-tajweed (CC BY 4.0)'));
  });

  test(
    'ayet metni, glif metinlerinin boşlukla birleşimi (konum varsayımı)',
    () async {
      // Ayet metni = glif metinlerinin boşlukla birleşimi; tecvid konumları
      // buna dayanır.
      final ayah = (await repo.getAyah(const AyahRef(2, 255))).valueOrNull!;
      final page = (await repo.getMushafPage(
        kDefaultLayout.id,
        42,
      )).valueOrNull!;
      final texts = [
        for (final l in page.lines)
          for (final g in l.glyphs)
            if (g.words.first.ayahRef == const AyahRef(2, 255))
              g.digitalKhattText!,
      ];
      expect(ayah.textDigitalKhatt.startsWith(texts.join(' ')), isTrue);
    },
  );
}
