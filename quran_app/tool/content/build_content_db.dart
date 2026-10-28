// `tool/content/sources/` altındaki ham veriden salt okunur içerik
// veritabanını (`assets/db/content.sqlite`) üretir (F0-03, F0-04).
//
// Kaynaklar:
// - Quran.com: ayet metinleri, meta veri, Corpus kelime bölünmesi (eşleme için)
// - KFGQPC metni (`text_qpc_hafs`): esas kelime bölünmesi (77.430 kelime)
// - QUL: Medine 1421H düzeni (satırlar, ortalı satırlar) ve QCF V2 glifleri
//
// Üç kaynağın kelime/glif bölünmeleri harf iskeleti üzerinden otomatik
// hizalanır; hiçbir yer elle eşlenmez. Tekrar çalıştırılabilir; kaynakta
// beklenmeyen bir durum varsa hata vererek durur ve yarım veritabanı bırakmaz.
//
// Çalıştırma (quran_app klasöründe): dart run tool/content/build_content_db.dart
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:quran_app/features/quran/data/content_database.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

const _quranComDir = 'tool/content/sources/quran_com';
const _qulDir = 'tool/content/sources/qul';

const _surahCount = 114;
const _ayahCount = 6236;
const _wordCount = 77430;

const _layout = (
  id: 'madani_1421',
  name: 'Medine Mushafı (KFGQPC, 1421H baskısı)',
  pageCount: 604,
  linesPerPage: 15,
  fontPack: 'qcf_v2',
  version: 1,
  qulLayoutFile: 'qpc-v2-15-lines.db',
  qulGlyphFile: 'qpc-v2.db',
);

/// Kaynak düzendeki satır sonu hatalarının belgelenmiş düzeltmeleri.
/// Anahtar: (sayfa, satır) → o satırın ilk glifinin QUL konumu.
/// Her biri VERI_KAYNAKLARI.md'de gerekçesiyle açıklanır (Q-13).
const _lineStartCorrections = {
  // 13:37 "بَعۡدَ" 6. satırın sonunda, "مَا" 7. satırın başındadır: font
  // genişliği ölçümünde bu bölünme +%0,5 / −%0,9 sapma verir; QUL'ün
  // bölünmesi (ikisi de 6. satırda) +%4,1 / −%4,5 (sayfanın en büyük sapması).
  (254, 7): '13:37:9',
};

Future<void> main() async {
  final chapters = _readList('chapters.json').cast<Map<String, dynamic>>();
  final verses = _readList('verses.json').cast<Map<String, dynamic>>();
  final manifest = jsonDecode(
    File('$_quranComDir/manifest.json').readAsStringSync(),
  ) as Map<String, dynamic>;

  _check(chapters.length == _surahCount, 'Sure sayısı ${chapters.length}');
  _check(verses.length == _ayahCount, 'Ayet sayısı ${verses.length}');

  final temp = File('$kContentAssetPath.tmp');
  if (temp.existsSync()) temp.deleteSync();
  temp.parent.createSync(recursive: true);

  final qulGlyphs = sqlite.sqlite3.open(
    '$_qulDir/${_layout.qulGlyphFile}',
    mode: sqlite.OpenMode.readOnly,
  );
  final qulLayout = sqlite.sqlite3.open(
    '$_qulDir/${_layout.qulLayoutFile}',
    mode: sqlite.OpenMode.readOnly,
  );
  final db = ContentDatabase(NativeDatabase(temp));
  try {
    final text = await _insertText(db, chapters, verses);
    final glyphToWords = _alignGlyphs(verses, text, qulGlyphs);
    await _insertLayout(db, text, glyphToWords, qulGlyphs, qulLayout);
    await db.batch((b) {
      b.insertAll(db.contentMeta, [
        for (final (key, value) in [
          ('contentVersion', '$kContentVersion'),
          (
            'source',
            '${manifest['source']} (${manifest['fetchedAt']}); '
                'QUL ${_layout.qulLayoutFile}, ${_layout.qulGlyphFile}',
          ),
          ('builtAt', DateTime.now().toUtc().toIso8601String()),
        ])
          ContentMetaCompanion.insert(key: key, value: value),
      ]);
    });
    await db.customStatement('VACUUM');
  } finally {
    await db.close();
    qulGlyphs.close();
    qulLayout.close();
  }

  final target = File(kContentAssetPath);
  if (target.existsSync()) target.deleteSync();
  temp.renameSync(kContentAssetPath);
  final mb = (target.lengthSync() / 1024 / 1024).toStringAsFixed(1);
  stdout.writeln(
    'Üretildi: $kContentAssetPath ($mb MB, sürüm $kContentVersion)',
  );
}

// ---------------------------------------------------------------------------
// Metin ve kelimeler
// ---------------------------------------------------------------------------

/// Bir ayetin esas (KFGQPC) kelimeleri ve Corpus kelimeleriyle hizalama
/// grupları.
class _AyahWords {
  _AyahWords(this.surah, this.ayah, this.firstWordId);

  final int surah;
  final int ayah;

  /// Ayetin ilk kelimesinin `Words.id` değeri.
  final int firstWordId;

  /// Hizalama grupları: (KFGQPC kelime sıraları, Corpus kelime sıraları),
  /// sıralar 1'den başlar. Ayet sonu işareti grup dışıdır.
  final List<(List<int>, List<int>)> groups = [];
  late int wordCount;
}

final _rubMark = String.fromCharCode(0x06DE);
final _tokenSeparator = RegExp('[  ]');
final _arabicIndicNumber = RegExp('^[٠-٩]+\$');

/// Sure, ayet ve kelimeleri yazar.
Future<Map<String, _AyahWords>> _insertText(
  ContentDatabase db,
  List<Map<String, dynamic>> chapters,
  List<Map<String, dynamic>> verses,
) async {
  final result = <String, _AyahWords>{};
  var wordId = 0;
  var realWords = 0;
  final spellingDifferences = <String>[];

  await db.batch((b) {
    b.insertAll(db.surahs, [
      for (final c in chapters)
        SurahsCompanion.insert(
          id: Value(c['id'] as int),
          nameArabic: c['nameArabic'] as String,
          nameSimple: c['nameSimple'] as String,
          nameTr: c['nameTr'] as String,
          nameEn: c['nameEn'] as String,
          revelationPlace: RevelationPlace.values.byName(
            c['revelationPlace'] as String,
          ),
          revelationOrder: c['revelationOrder'] as int,
          bismillahPre: c['bismillahPre'] as bool,
          ayahCount: c['versesCount'] as int,
        ),
    ]);

    for (final (index, v) in verses.indexed) {
      final ayahId = index + 1;
      final surah = v['surah'] as int;
      final ayah = v['ayah'] as int;
      final qpc = v['textQpcHafs'] as String;
      b.insert(
        db.ayahs,
        AyahsCompanion.insert(
          id: Value(ayahId),
          surah: surah,
          ayah: ayah,
          juz: v['juz'] as int,
          hizb: v['hizb'] as int,
          rub: v['rub'] as int,
          sajdah: Value(v['sajdah'] as int?),
          // Q-9: Quran.com 110 surenin 1. ayetinde besmeleyi çıkarırken başta
          // bir boşluk bırakmış; yalnızca bu boşluk kırpılır.
          textUthmani: (v['textUthmani'] as String).trimLeft(),
          textQpcHafs: qpc,
        ),
      );

      // Esas kelimeler: KFGQPC metni boşluklardan bölünür; ۞ kelime değildir;
      // son parça ayet numarasıdır.
      final tokens = qpc
          .split(_tokenSeparator)
          .where((t) => t.isNotEmpty && t != _rubMark)
          .toList();
      _check(
        _arabicIndicNumber.hasMatch(tokens.last) &&
            _arabicIndicToInt(tokens.last) == ayah,
        '$surah:$ayah KFGQPC metni ayet numarasıyla bitmiyor',
      );
      final kfWords = tokens.sublist(0, tokens.length - 1);
      final corpusWords = [
        for (final w in (v['words'] as List).cast<List<dynamic>>())
          if (w[1] == 'word') w[2] as String,
      ];

      final entry = _AyahWords(surah, ayah, wordId + 1)
        ..wordCount = kfWords.length;
      _alignBySkeleton(kfWords, corpusWords, entry.groups, (kf, corpus) {
        spellingDifferences.add('$surah:$ayah ($kf / $corpus)');
      }, '$surah:$ayah');
      result['$surah:$ayah'] = entry;

      final morph = <int, (int, int)>{};
      for (final (kf, corpus) in entry.groups) {
        for (final k in kf) {
          morph[k] = (corpus.first, corpus.last);
        }
      }
      for (final (i, word) in kfWords.indexed) {
        realWords++;
        b.insert(
          db.words,
          WordsCompanion.insert(
            id: Value(++wordId),
            ayahId: ayahId,
            surah: surah,
            ayah: ayah,
            position: i + 1,
            isAyahEnd: false,
            wordText: word,
            morphFirst: morph[i + 1]!.$1,
            morphLast: morph[i + 1]!.$2,
          ),
        );
      }
      b.insert(
        db.words,
        WordsCompanion.insert(
          id: Value(++wordId),
          ayahId: ayahId,
          surah: surah,
          ayah: ayah,
          position: kfWords.length + 1,
          isAyahEnd: true,
          wordText: tokens.last,
          morphFirst: corpusWords.length + 1,
          morphLast: corpusWords.length + 1,
        ),
      );
    }
  });

  _check(realWords == _wordCount, 'Kelime sayısı $realWords');
  stdout.writeln(
    'Metin: $_surahCount sure, ${verses.length} ayet, $realWords kelime; '
    'imla farkı: ${spellingDifferences.join(', ')}',
  );
  return result;
}

/// İki kelime dizisini harf iskeletiyle hizalar. Toplam harf sayısı eşit
/// olan en küçük ardışık grupları bulur; grup içeriği farklıysa (imla farkı)
/// [onSpellingDifference] çağrılır.
void _alignBySkeleton(
  List<String> a,
  List<String> b,
  List<(List<int>, List<int>)> groups,
  void Function(String, String) onSpellingDifference,
  String where,
) {
  var i = 0;
  var j = 0;
  while (i < a.length && j < b.length) {
    final ga = [i + 1];
    final gb = [j + 1];
    var sa = _skeleton(a[i++]);
    var sb = _skeleton(b[j++]);
    while (sa.length != sb.length) {
      if (sa.length < sb.length) {
        _check(i < a.length, '$where hizalanamadı');
        sa += _skeleton(a[i++]);
        ga.add(i);
      } else {
        _check(j < b.length, '$where hizalanamadı');
        sb += _skeleton(b[j++]);
        gb.add(j);
      }
    }
    if (sa != sb) onSpellingDifference(sa, sb);
    groups.add((ga, gb));
  }
  _check(i == a.length && j == b.length, '$where hizalanamadı (artan kelime)');
}

/// Harf iskeleti: yalnızca temel Arap harfleri; hareke, işaret, tatvîl ve
/// tek başına hemze atılır; elif, ye ve vav aileleri tek harfe katlanır.
/// Yalnızca hizalama içindir, saklanan metni etkilemez.
String _skeleton(String word) {
  final out = StringBuffer();
  for (final rune in word.runes) {
    final c = switch (rune) {
      0x0671 || 0x0623 || 0x0625 || 0x0622 => 0x0627,
      0x0649 || 0x0626 => 0x064A,
      0x0624 => 0x0648,
      _ => rune,
    };
    if (c >= 0x0622 && c <= 0x064A && c != 0x0640) out.writeCharCode(c);
  }
  return out.toString();
}

int _arabicIndicToInt(String s) =>
    int.parse(String.fromCharCodes(s.runes.map((r) => r - 0x0660 + 0x30)));

// ---------------------------------------------------------------------------
// Glifler
// ---------------------------------------------------------------------------

/// QUL glif birimlerini esas kelimelere eşler: QUL glif id → (ilk, son
/// `Words.id`). Köprü: Quran.com kelimelerinin QCF V2 glif kodları.
Map<int, (int, int)> _alignGlyphs(
  List<Map<String, dynamic>> verses,
  Map<String, _AyahWords> text,
  sqlite.Database qul,
) {
  final unitsByAyah = <String, List<(int, String)>>{};
  for (final row in qul.select(
    'SELECT id, surah, ayah, text FROM words ORDER BY id',
  )) {
    unitsByAyah.putIfAbsent('${row['surah']}:${row['ayah']}', () => []).add((
      row['id'] as int,
      row['text'] as String,
    ));
  }

  final result = <int, (int, int)>{};
  for (final v in verses) {
    final key = '${v['surah']}:${v['ayah']}';
    final ayah = text[key]!;
    final units = unitsByAyah[key]!;
    final corpusWords = (v['words'] as List).cast<List<dynamic>>();

    // Her Corpus kelimesinin (ayet sonu dahil) kapsadığı QUL glifleri.
    var u = 0;
    final unitsOfCorpus = <List<int>>[];
    for (final w in corpusWords) {
      final glyph = (w[3] as String).replaceAll(' ', '');
      final ids = <int>[];
      var acc = '';
      while (acc != glyph) {
        _check(
          u < units.length && glyph.startsWith(acc + units[u].$2),
          '$key glifleri eşleşmiyor (Corpus kelimesi ${w[0]})',
        );
        acc += units[u].$2;
        ids.add(units[u++].$1);
      }
      unitsOfCorpus.add(ids);
    }
    _check(u == units.length, '$key artan QUL glifi');

    int wordId(int position) => ayah.firstWordId + position - 1;
    for (final (kf, corpus) in ayah.groups) {
      final glyphs = [for (final c in corpus) ...unitsOfCorpus[c - 1]];
      if (glyphs.length == kf.length) {
        for (final (i, g) in glyphs.indexed) {
          result[g] = (wordId(kf[i]), wordId(kf[i]));
        }
      } else if (kf.length == 1) {
        for (final g in glyphs) {
          result[g] = (wordId(kf.single), wordId(kf.single));
        }
      } else {
        _check(glyphs.length == 1, '$key glif grubu eşlenemedi');
        result[glyphs.single] = (wordId(kf.first), wordId(kf.last));
      }
    }
    // Ayet sonu işareti.
    final end = wordId(ayah.wordCount + 1);
    for (final g in unitsOfCorpus.last) {
      result[g] = (end, end);
    }
  }
  return result;
}

// ---------------------------------------------------------------------------
// Düzen
// ---------------------------------------------------------------------------

Future<void> _insertLayout(
  ContentDatabase db,
  Map<String, _AyahWords> text,
  Map<int, (int, int)> glyphToWords,
  sqlite.Database qulGlyphs,
  sqlite.Database qulLayout,
) async {
  final qulIdByLocation = {
    for (final row in qulGlyphs.select('SELECT id, location FROM words'))
      row['location'] as String: row['id'] as int,
  };
  final glyphText = {
    for (final row in qulGlyphs.select('SELECT id, text FROM words'))
      row['id'] as int: row['text'] as String,
  };

  // QUL satırları; düzeltmeler uygulanarak.
  final rows = [
    for (final r in qulLayout.select(
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
  for (final MapEntry(key: (page, line), value: location)
      in _lineStartCorrections.entries) {
    final i = rows.indexWhere((r) => r.page == page && r.line == line);
    final newFirst = qulIdByLocation[location]!;
    final prev = rows[i - 1];
    _check(
      prev.page == page && prev.last == newFirst,
      'Düzeltme ($page, $line) beklenen satır sonunu bulamadı',
    );
    rows[i - 1] = (
      page: prev.page,
      line: prev.line,
      type: prev.type,
      centered: prev.centered,
      first: prev.first,
      last: newFirst - 1,
      surah: prev.surah,
    );
    final cur = rows[i];
    rows[i] = (
      page: cur.page,
      line: cur.line,
      type: cur.type,
      centered: cur.centered,
      first: newFirst,
      last: cur.last,
      surah: cur.surah,
    );
  }

  // QUL besmele satırlarında sure numarası yok: önceki sure başlığından alınır
  // (başlık önceki sayfanın son satırında olabilir).
  int? lastHeaderSurah;
  for (final (i, r) in rows.indexed) {
    if (r.type == LayoutLineType.surahName) lastHeaderSurah = r.surah;
    if (r.type == LayoutLineType.basmala) {
      _check(r.surah == null || r.surah == lastHeaderSurah, 'Besmele suresi');
      rows[i] = (
        page: r.page,
        line: r.line,
        type: r.type,
        centered: r.centered,
        first: r.first,
        last: r.last,
        surah: lastHeaderSurah,
      );
    }
  }

  // Doğrulama: satır sayıları, glif kapsaması, kelimelerin satırlara bölünmesi.
  _check(rows.length == 9046, 'Satır sayısı ${rows.length}');
  var expectedGlyph = 1;
  final lineOfWord = <int, (int, int)>{};
  final pageAyahs = <int, List<int>>{};
  final ayahIdOfWord = <int, int>{};
  for (final r in rows.where((r) => r.type == LayoutLineType.ayah)) {
    _check(r.first == expectedGlyph, 's.${r.page} satır ${r.line} glif sırası');
    for (var g = r.first!; g <= r.last!; g++) {
      final (first, last) = glyphToWords[g]!;
      for (var w = first; w <= last; w++) {
        final prev = lineOfWord[w];
        _check(
          prev == null || prev == (r.page, r.line),
          'Kelime $w iki satıra bölünmüş (s.${r.page})',
        );
        lineOfWord[w] = (r.page, r.line);
      }
    }
    expectedGlyph = r.last! + 1;
  }
  _check(expectedGlyph - 1 == glyphText.length, 'Tüm glifler satırlarda değil');
  _check(
    lineOfWord.length == _wordCount + _ayahCount,
    'Satırlarda olmayan kelime var',
  );

  // Sayfa → ilk/son ayet.
  final words = await db.select(db.words).get();
  for (final w in words) {
    ayahIdOfWord[w.id] = w.ayahId;
  }
  for (final MapEntry(key: wordId, value: (page, _)) in lineOfWord.entries) {
    final ayahId = ayahIdOfWord[wordId]!;
    final range = pageAyahs.putIfAbsent(page, () => [ayahId, ayahId]);
    if (ayahId < range[0]) range[0] = ayahId;
    if (ayahId > range[1]) range[1] = ayahId;
  }
  _check(pageAyahs.length == _layout.pageCount, 'Sayfa sayısı');

  await db.batch((b) {
    b.insert(
      db.mushafLayouts,
      MushafLayoutsCompanion.insert(
        id: _layout.id,
        name: _layout.name,
        pageCount: _layout.pageCount,
        linesPerPage: _layout.linesPerPage,
        fontPack: _layout.fontPack,
        version: _layout.version,
      ),
    );
    b.insertAll(db.layoutGlyphs, [
      for (final MapEntry(key: id, value: glyph) in glyphText.entries)
        LayoutGlyphsCompanion.insert(
          layoutId: _layout.id,
          id: id,
          firstWordId: glyphToWords[id]!.$1,
          lastWordId: glyphToWords[id]!.$2,
          glyph: glyph,
        ),
    ]);
    b.insertAll(db.layoutLines, [
      for (final r in rows)
        LayoutLinesCompanion.insert(
          layoutId: _layout.id,
          page: r.page,
          line: r.line,
          type: r.type,
          isCentered: r.centered,
          surah: Value(r.type == LayoutLineType.ayah ? null : r.surah),
          firstGlyphId: Value(r.first),
          lastGlyphId: Value(r.last),
        ),
    ]);
    b.insertAll(db.layoutPages, [
      for (final MapEntry(key: page, value: r) in pageAyahs.entries)
        LayoutPagesCompanion.insert(
          layoutId: _layout.id,
          page: page,
          firstAyahId: r[0],
          lastAyahId: r[1],
        ),
    ]);
  });
  stdout.writeln(
    '${_layout.id}: ${_layout.pageCount} sayfa, ${rows.length} satır, '
    '${glyphText.length} glif',
  );
}

int? _intOrNull(Object? v) => v is int ? v : null;

List<dynamic> _readList(String name) =>
    jsonDecode(File('$_quranComDir/$name').readAsStringSync()) as List<dynamic>;

void _check(bool condition, String message) {
  if (!condition) throw StateError('Veri doğrulaması başarısız: $message');
}
