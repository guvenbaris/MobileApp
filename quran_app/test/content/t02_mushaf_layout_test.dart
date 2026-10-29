// T-02 Sayfa düzeni ve bölüm sınırları (F0-04).
//
// Referans: Tanzil meta verisi ve Tanzil metnindeki işaretler. Tanzil'in
// sayfa verisi 1405H baskısına aittir; bizim düzenimiz 1421H baskısıdır.
// İki baskı arasındaki bilinen farklar aşağıda tek tek listelenir
// (VERI_KAYNAKLARI.md Q-10). Liste dışındaki her fark testi kırar. Düzenin
// kendisi (satırlar, glifler) QUL'den gelir ve yerelde font genişliği
// ölçümüyle doğrulanır (tool/content/check_line_widths.dart).
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/quran/data/content_database.dart';
import 'package:quran_app/features/quran/domain/mushaf_layout.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';

import '../helpers/content_db.dart';
import '../helpers/tanzil_reference.dart';

/// 1421H düzeninde ilk ayeti Tanzil'den (1405H) farklı olan sayfalar:
/// sayfa → (Tanzil, 1421H). QUL'ün 1421H düzeniyle doğrulandı (Q-10).
const _known1421PageDifferences = {
  121: (AyahRef(5, 77), AyahRef(5, 78)),
  122: (AyahRef(5, 83), AyahRef(5, 84)),
  123: (AyahRef(5, 90), AyahRef(5, 91)),
  145: (AyahRef(6, 132), AyahRef(6, 131)),
  532: (AyahRef(55, 17), AyahRef(55, 19)),
  533: (AyahRef(55, 41), AyahRef(55, 42)),
  534: (AyahRef(55, 68), AyahRef(55, 70)),
  565: (AyahRef(68, 16), AyahRef(68, 17)),
  568: (AyahRef(69, 35), AyahRef(69, 36)),
  570: (AyahRef(70, 40), AyahRef(70, 41)),
  576: (AyahRef(74, 18), AyahRef(74, 19)),
  584: (AyahRef(79, 16), AyahRef(79, 17)),
  586: (AyahRef(81, 1), AyahRef(80, 41)),
  588: (AyahRef(83, 7), AyahRef(83, 5)),
  589: (AyahRef(83, 35), AyahRef(83, 34)),
  590: (AyahRef(85, 1), AyahRef(84, 25)),
  592: (AyahRef(87, 16), AyahRef(87, 11)),
  593: (AyahRef(89, 1), AyahRef(88, 23)),
  594: (AyahRef(89, 24), AyahRef(89, 23)),
  595: (AyahRef(91, 1), AyahRef(90, 19)),
  596: (AyahRef(92, 15), AyahRef(92, 10)),
  597: (AyahRef(95, 1), AyahRef(94, 3)),
  598: (AyahRef(97, 1), AyahRef(96, 13)),
  599: (AyahRef(98, 8), AyahRef(98, 6)),
  600: (AyahRef(100, 10), AyahRef(100, 6)),
};

void main() {
  late ContentDatabase db;
  late List<AyahRow> ayahs;
  final tanzil = TanzilReference.load();

  setUp(() async {
    db = openTestContentDatabase();
    ayahs = await (db.select(
      db.ayahs,
    )..orderBy([(a) => OrderingTerm(expression: a.id)])).get();
  });

  AyahRef refOf(int ayahId) {
    final a = ayahs[ayahId - 1];
    return AyahRef(a.surah, a.ayah);
  }

  /// Bir alanın ilk göründüğü ayet: değer → ayet.
  Map<int, AyahRef> startsOf(int Function(AyahRow) field) {
    final starts = <int, AyahRef>{};
    for (final a in ayahs) {
      starts.putIfAbsent(field(a), () => AyahRef(a.surah, a.ayah));
    }
    return starts;
  }

  group('sayfa düzeni (${kDefaultLayout.id})', () {
    late List<LayoutPageRow> pages;

    setUp(() async {
      pages =
          await (db.select(db.layoutPages)
                ..where((p) => p.layoutId.equals(kDefaultLayout.id))
                ..orderBy([(p) => OrderingTerm(expression: p.page)]))
              .get();
    });

    test('604 sayfa, boşluksuz ve örtüşmesiz tüm ayetleri kapsar', () {
      expect(pages, hasLength(604));
      expect(pages.first.firstAyahId, 1);
      expect(pages.last.lastAyahId, 6236);
      for (var i = 1; i < pages.length; i++) {
        expect(
          pages[i].firstAyahId,
          pages[i - 1].lastAyahId + 1,
          reason: 'Sayfa ${pages[i].page} bir önceki sayfanın devamı değil',
        );
      }
    });

    test(
      'her sayfanın ilk ayeti referansla aynı (bilinen 1421H farkları hariç)',
      () {
        final reference = tanzil.starts('page');
        final unexpected = <String>[];
        for (final page in pages) {
          final actual = refOf(page.firstAyahId);
          final known = _known1421PageDifferences[page.page];
          final expected = known?.$2 ?? reference[page.page];
          if (known != null) {
            expect(
              reference[page.page],
              known.$1,
              reason: 'Tanzil s.${page.page}',
            );
          }
          if (actual != expected) {
            unexpected.add('s.${page.page}: $actual (beklenen $expected)');
          }
        }
        expect(unexpected, isEmpty, reason: unexpected.join('\n'));
      },
    );

    test('her sayfanın son ayeti, sonraki sayfanın ilk ayetinden hemen önce', () {
      final reference = tanzil.starts('page');
      // Bilinen farkların dışındaki sayfalarda son ayet de referansla aynıdır.
      for (final page in pages.where((p) => p.page < 604)) {
        final next = page.page + 1;
        if (_known1421PageDifferences.containsKey(next)) continue;
        final nextStart = ayahs.indexWhere(
          (a) => AyahRef(a.surah, a.ayah) == reference[next],
        );
        expect(page.lastAyahId, nextStart, reason: 's.${page.page} son ayeti');
      }
      expect(refOf(pages.last.lastAyahId), const AyahRef(114, 6));
    });

    test('satırlar tüm glifleri sırayla ve bir kez kapsar', () async {
      final lines =
          await (db.select(db.layoutLines)
                ..where(
                  (l) =>
                      l.layoutId.equals(kDefaultLayout.id) &
                      l.type.equalsValue(LayoutLineType.ayah),
                )
                ..orderBy([
                  (l) => OrderingTerm(expression: l.page),
                  (l) => OrderingTerm(expression: l.line),
                ]))
              .get();
      expect(lines, hasLength(8820));
      var expectedNext = 1;
      for (final l in lines) {
        expect(
          l.firstGlyphId,
          expectedNext,
          reason: 's.${l.page} satır ${l.line}',
        );
        expectedNext = l.lastGlyphId! + 1;
      }
      expect(expectedNext - 1, await db.layoutGlyphs.count().getSingle());
    });

    test('hiçbir kelime iki satıra bölünmez', () async {
      final lines = await (db.select(
        db.layoutLines,
      )..where((l) => l.type.equalsValue(LayoutLineType.ayah))).get();
      final glyphs = {
        for (final g in await db.select(db.layoutGlyphs).get()) g.id: g,
      };
      final lineOfWord = <int, String>{};
      for (final l in lines) {
        for (var id = l.firstGlyphId!; id <= l.lastGlyphId!; id++) {
          final g = glyphs[id]!;
          for (var w = g.firstWordId; w <= g.lastWordId; w++) {
            final here = '${l.page}/${l.line}';
            expect(lineOfWord.putIfAbsent(w, () => here), here, reason: '$w');
          }
        }
      }
      expect(lineOfWord.length, await db.words.count().getSingle());
    });

    test('256 ortalı satır; ilk iki sayfanın tamamı ortalı', () async {
      final lines = await db.select(db.layoutLines).get();
      expect(lines.where((l) => l.isCentered), hasLength(256));
      expect(
        lines.where((l) => l.page <= 2).every((l) => l.isCentered),
        isTrue,
      );
    });

    test(
      '254. sayfa düzeltmesi: "بَعۡدَ" 6. satırda, "مَا" 7. satırda',
      () async {
        // VERI_KAYNAKLARI.md Q-13.
        final line7 = await (db.select(
          db.layoutLines,
        )..where((l) => l.page.equals(254) & l.line.equals(7))).getSingle();
        final first = await (db.select(
          db.layoutGlyphs,
        )..where((g) => g.id.equals(line7.firstGlyphId!))).getSingle();
        final word = await (db.select(
          db.words,
        )..where((w) => w.id.equals(first.firstWordId))).getSingle();
        expect((word.surah, word.ayah, word.position), (13, 37, 9));
        expect(word.wordText, 'مَا');
      },
    );

    test('her sure başlığıyla, besmeleli sureler besmeleyle başlar', () async {
      final lines = await (db.select(
        db.layoutLines,
      )..where((l) => l.layoutId.equals(kDefaultLayout.id))).get();
      final headers = lines.where((l) => l.type == LayoutLineType.surahName);
      final basmalas = lines.where((l) => l.type == LayoutLineType.basmala);
      expect(headers.map((l) => l.surah).toSet(), hasLength(114));
      expect(basmalas.map((l) => l.surah).toSet(), {
        for (var s = 2; s <= 114; s++)
          if (s != 9) s,
      });
    });
  });

  group('bölüm sınırları', () {
    test('30 cüzün başlangıcı Tanzil ile aynı', () {
      expect(startsOf((a) => a.juz), tanzil.starts('juz'));
    });

    test('240 rubu\'un başlangıcı Tanzil ile aynı (15:49 hariç)', () {
      final reference = tanzil.starts('quarter');
      final actual = startsOf((a) => a.rub);
      expect(actual, hasLength(240));
      // Tanzil meta verisi 106. rubu'u 15:50'de başlatır, ama Tanzil'in kendi
      // metnindeki ۞ işareti 15:49'dadır; bizim veri işaretle uyumludur.
      expect(reference[106], const AyahRef(15, 50));
      expect(actual[106], const AyahRef(15, 49));
      for (final i in reference.keys.where((i) => i != 106)) {
        expect(actual[i], reference[i], reason: 'Rubu\' $i');
      }
    });

    test('60 hizb, her biri 4 rubu\'dan oluşur', () {
      expect(startsOf((a) => a.hizb), hasLength(60));
      for (final a in ayahs) {
        expect(a.hizb, (a.rub + 3) ~/ 4, reason: '${a.surah}:${a.ayah}');
      }
    });

    test('metindeki her ۞ işareti bir rubu\' başlangıcında', () {
      final starts = startsOf((a) => a.rub).values.toSet();
      final marks = tanzil.ayahsWithMark('۞');
      expect(marks.difference(starts), isEmpty);
      // İşaretsiz rubu' başlangıçları yalnızca sure başlarındadır.
      expect(starts.difference(marks).every((r) => r.ayah == 1), isTrue);
    });

    test('secdeler: uygulamada 14 secde (Hanefi, Q-8 kararı), metindeki ۩ ile uyumlu', () {
      final sajdahs = {
        for (final a in ayahs)
          if (a.sajdah != null) AyahRef(a.surah, a.ayah),
      };
      final marks = tanzil.ayahsWithMark('۩');
      expect(sajdahs, hasLength(14));
      expect(marks, hasLength(15));
      // Karar (28.10.2026): 14 secde. 22:77 metinde ۩ ile işaretli (basılı
      // metnin parçası) ama uygulamada secde ayeti sayılmaz (Q-8).
      expect(marks.difference(sajdahs), {const AyahRef(22, 77)});
      expect(sajdahs.difference(marks), isEmpty);
    });
  });
}
