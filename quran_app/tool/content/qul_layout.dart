// QUL mushaf düzeni dosyalarını (`pages` tablosu) okuma ve denetleme.
// İçerik veritabanı (yerleşik düzen) ve düzen paketi üreticileri ortak
// kullanır (F0-04, F1-03).
import 'package:quran_app/features/quran/domain/quran_models.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

/// QUL düzeninin bir satırı. `first`/`last`: QUL glif birimi numaraları
/// (ayet satırlarında); `surah`: sure başlığı ve besmele satırlarında.
typedef QulLine = ({
  int page,
  int line,
  LayoutLineType type,
  bool centered,
  int? first,
  int? last,
  int? surah,
});

/// Satırları sayfa ve satır sırasıyla okur. QUL besmele satırlarında sure
/// numarası yoktur: önceki sure başlığından alınır (başlık önceki sayfanın
/// son satırında olabilir).
List<QulLine> readQulLines(sqlite.Database layout) {
  final rows = <QulLine>[
    for (final r in layout.select(
      'SELECT page_number, line_number, line_type, is_centered, '
      'first_word_id, last_word_id, surah_number FROM pages '
      'ORDER BY page_number, line_number',
    ))
      (
        page: r['page_number'] as int,
        line: r['line_number'] as int,
        type: switch (r['line_type'] as String) {
          'ayah' => LayoutLineType.ayah,
          'surah_name' => LayoutLineType.surahName,
          'basmallah' => LayoutLineType.basmala,
          final t => throw StateError('Bilinmeyen satır türü: $t'),
        },
        centered: r['is_centered'] == 1,
        first: _intOrNull(r['first_word_id']),
        last: _intOrNull(r['last_word_id']),
        surah: _intOrNull(r['surah_number']),
      ),
  ];
  int? lastHeaderSurah;
  for (final (i, r) in rows.indexed) {
    if (r.type == LayoutLineType.surahName) lastHeaderSurah = r.surah;
    if (r.type == LayoutLineType.basmala) {
      checkData(
        r.surah == null || r.surah == lastHeaderSurah,
        'Besmele suresi',
      );
      rows[i] = withRange(r, surah: lastHeaderSurah);
    }
  }
  return rows;
}

/// Satırın kopyası; verilen alanlar değişir.
QulLine withRange(QulLine r, {int? first, int? last, int? surah}) => (
  page: r.page,
  line: r.line,
  type: r.type,
  centered: r.centered,
  first: first ?? r.first,
  last: last ?? r.last,
  surah: surah ?? r.surah,
);

/// Ayet satırları tüm glifleri sırayla ve bir kez kapsar; hiçbir kelime iki
/// satıra bölünmez. [glyphToWords]: glif → (ilk, son `words.id`).
/// Dönüş: kelime → (sayfa, satır).
Map<int, (int, int)> checkQulLines(
  List<QulLine> rows,
  Map<int, (int, int)> glyphToWords, {
  required int glyphCount,
}) {
  var expectedGlyph = 1;
  final lineOfWord = <int, (int, int)>{};
  for (final r in rows.where((r) => r.type == LayoutLineType.ayah)) {
    checkData(
      r.first == expectedGlyph,
      's.${r.page} satır ${r.line} glif sırası',
    );
    for (var g = r.first!; g <= r.last!; g++) {
      final (first, last) = glyphToWords[g]!;
      for (var w = first; w <= last; w++) {
        final prev = lineOfWord[w];
        checkData(
          prev == null || prev == (r.page, r.line),
          'Kelime $w iki satıra bölünmüş (s.${r.page})',
        );
        lineOfWord[w] = (r.page, r.line);
      }
    }
    expectedGlyph = r.last! + 1;
  }
  checkData(expectedGlyph - 1 == glyphCount, 'Tüm glifler satırlarda değil');
  return lineOfWord;
}

/// Sayfa → [ilk, son] ayet kimliği; kelimelerin bulunduğu satırlardan.
Map<int, List<int>> pageAyahRanges(
  Map<int, (int, int)> lineOfWord,
  Map<int, int> ayahIdOfWord,
) {
  final pageAyahs = <int, List<int>>{};
  for (final MapEntry(key: wordId, value: (page, _)) in lineOfWord.entries) {
    final ayahId = ayahIdOfWord[wordId]!;
    final range = pageAyahs.putIfAbsent(page, () => [ayahId, ayahId]);
    if (ayahId < range[0]) range[0] = ayahId;
    if (ayahId > range[1]) range[1] = ayahId;
  }
  return pageAyahs;
}

int? _intOrNull(Object? v) => v is int ? v : null;

void checkData(bool condition, String message) {
  if (!condition) throw StateError('Veri doğrulaması başarısız: $message');
}
