// `tool/content/sources/` altındaki ham veriden salt okunur içerik
// veritabanını (`assets/db/content.sqlite`) üretir (F0-03).
//
// Tekrar çalıştırılabilir: her seferinde veritabanını sıfırdan kurar.
// Kaynak veride beklenmeyen bir durum varsa hata vererek durur; yarım
// veritabanı bırakmaz.
//
// Çalıştırma (quran_app klasöründe): dart run tool/content/build_content_db.dart
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:quran_app/features/quran/data/content_database.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';

const _sourceDir = 'tool/content/sources/quran_com';

const _surahCount = 114;
const _ayahCount = 6236;
const _wordCount = 77429;

/// İçerikteki mushaf düzenleri.
const _layouts = [
  (
    id: 'madani_1421',
    name: 'Medine Mushafı (KFGQPC, 1421H baskısı)',
    pageCount: 604,
    linesPerPage: 15,
    fontPack: 'qcf_v2',
    version: 1,
  ),
];

/// Kaynaktaki düzen hatalarının belgelenmiş düzeltmeleri (yalnızca satır
/// numarası; metne dokunulmaz). Her biri VERI_KAYNAKLARI.md'de açıklanır.
/// Anahtar: `düzen/sure:ayet:sıra` → doğru satır.
const _lineCorrections = {
  // 84:21 ayet sonu işareti kaynakta 13. satırda; ayetin 3–6. kelimeleri ve
  // 84:22 14. satırda olduğundan sıralamaya uyan tek değer 14'tür.
  'madani_1421/84:21:7': 14,
};

Future<void> main() async {
  final chapters = _readList('chapters.json').cast<Map<String, dynamic>>();
  final verses = _readList('verses.json').cast<Map<String, dynamic>>();
  final manifest = jsonDecode(
    File('$_sourceDir/manifest.json').readAsStringSync(),
  ) as Map<String, dynamic>;

  _check(chapters.length == _surahCount, 'Sure sayısı ${chapters.length}');
  _check(verses.length == _ayahCount, 'Ayet sayısı ${verses.length}');

  final temp = File('$kContentAssetPath.tmp');
  if (temp.existsSync()) temp.deleteSync();
  temp.parent.createSync(recursive: true);

  final db = ContentDatabase(NativeDatabase(temp));
  try {
    final wordIds = await _insertText(db, chapters, verses);
    for (final layout in _layouts) {
      await _insertLayout(db, layout, chapters, verses, wordIds);
    }
    await db.batch((b) {
      b.insertAll(db.contentMeta, [
        for (final (key, value) in [
          ('contentVersion', '$kContentVersion'),
          ('source', '${manifest['source']} (${manifest['fetchedAt']})'),
          ('builtAt', DateTime.now().toUtc().toIso8601String()),
        ])
          ContentMetaCompanion.insert(key: key, value: value),
      ]);
    });
    await db.customStatement('VACUUM');
  } finally {
    await db.close();
  }

  final target = File(kContentAssetPath);
  if (target.existsSync()) target.deleteSync();
  temp.renameSync(kContentAssetPath);
  final mb = (target.lengthSync() / 1024 / 1024).toStringAsFixed(1);
  stdout.writeln(
    'Üretildi: $kContentAssetPath ($mb MB, sürüm $kContentVersion)',
  );
}

/// Sure, ayet ve kelimeleri yazar. Dönüş: `sure:ayet:sıra` → kelime id.
Future<Map<String, int>> _insertText(
  ContentDatabase db,
  List<Map<String, dynamic>> chapters,
  List<Map<String, dynamic>> verses,
) async {
  final wordIds = <String, int>{};
  var wordId = 0;
  var realWords = 0;

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
          textQpcHafs: v['textQpcHafs'] as String,
        ),
      );

      final words = (v['words'] as List).cast<List<dynamic>>();
      _check(
        words.last[1] == 'end' && words.where((w) => w[1] == 'end').length == 1,
        '$surah:$ayah ayet sonu işareti son kelime değil',
      );
      for (final (i, w) in words.indexed) {
        final position = w[0] as int;
        _check(position == i + 1, '$surah:$ayah kelime sırası bozuk');
        final isEnd = w[1] == 'end';
        if (!isEnd) realWords++;
        wordIds['$surah:$ayah:$position'] = ++wordId;
        b.insert(
          db.words,
          WordsCompanion.insert(
            id: Value(wordId),
            ayahId: ayahId,
            surah: surah,
            ayah: ayah,
            position: position,
            isAyahEnd: isEnd,
            textUthmani: w[2] as String,
          ),
        );
      }
    }
  });

  _check(realWords == _wordCount, 'Kelime sayısı $realWords');
  stdout.writeln(
    'Metin: $_surahCount sure, ${verses.length} ayet, $realWords kelime',
  );
  return wordIds;
}

/// Bir düzenin satırlarını, sayfa sınırlarını ve gliflerini yazar.
///
/// Kaynakta yalnızca kelimelerin sayfa/satırı var. Kelimesi olmayan satırlar
/// sure başlığı veya besmeledir: her surenin ilk satırının hemen üstündeki
/// 2 satır (Fatiha ve Tevbe'de besmele ayrı satır olmadığından 1 satır).
/// Başlık sayfanın ilk satırından önceye taşarsa önceki sayfanın sonuna düşer.
/// Bu kurala uymayan boş satır varsa betik durur.
Future<void> _insertLayout(
  ContentDatabase db,
  ({
    String id,
    String name,
    int pageCount,
    int linesPerPage,
    String fontPack,
    int version,
  })
  layout,
  List<Map<String, dynamic>> chapters,
  List<Map<String, dynamic>> verses,
  Map<String, int> wordIds,
) async {
  final rows = _readList('layout_${layout.id}.json').cast<List<dynamic>>();
  _check(rows.length == wordIds.length, '${layout.id}: kelime sayısı farklı');

  final ayahIds = {
    for (final (i, v) in verses.indexed) '${v['surah']}:${v['ayah']}': i + 1,
  };
  final bismillah = {
    for (final c in chapters) c['id'] as int: c['bismillahPre'] as bool,
  };

  // (sayfa, satır) → [ilk kelime, son kelime]
  final wordLines = <(int, int), List<int>>{};
  final pageAyahs = <int, List<int>>{};
  final surahStart = <int, (int, int)>{};
  final glyphs = <LayoutWordGlyphsCompanion>[];

  for (final r in rows) {
    final [
      surah as int,
      ayah as int,
      position as int,
      page as int,
      sourceLine as int,
      glyph as String,
    ] = r;
    final line =
        _lineCorrections['${layout.id}/$surah:$ayah:$position'] ?? sourceLine;
    final wordId = wordIds['$surah:$ayah:$position']!;
    final range = wordLines.putIfAbsent((page, line), () => [wordId, wordId]);
    _check(
      wordId == range[1] || wordId == range[1] + 1 || wordId == range[0],
      '${layout.id}: s.$page satır $line kelimeleri ardışık değil',
    );
    range[1] = wordId;
    final ayahId = ayahIds['$surah:$ayah']!;
    final pr = pageAyahs.putIfAbsent(page, () => [ayahId, ayahId]);
    if (ayahId < pr[0]) pr[0] = ayahId;
    if (ayahId > pr[1]) pr[1] = ayahId;
    if (ayah == 1 && position == 1) surahStart[surah] = (page, line);
    glyphs.add(
      LayoutWordGlyphsCompanion.insert(
        layoutId: layout.id,
        wordId: wordId,
        glyph: glyph,
      ),
    );
  }
  _check(pageAyahs.length == layout.pageCount, '${layout.id}: sayfa sayısı');

  // Başlık ve besmele satırları.
  final headerLines = <(int, int), (LayoutLineType, int)>{};
  for (final MapEntry(key: surah, value: (page, line)) in surahStart.entries) {
    final types = bismillah[surah]! && surah != 1
        ? [LayoutLineType.surahName, LayoutLineType.basmala]
        : [LayoutLineType.surahName];
    for (final (k, type) in types.indexed) {
      var p = page;
      var l = line - types.length + k;
      if (l < 1) {
        p--;
        l += layout.linesPerPage;
      }
      headerLines[(p, l)] = (type, surah);
    }
  }

  final lines = <LayoutLinesCompanion>[];
  for (var page = 1; page <= layout.pageCount; page++) {
    final used = [
      for (final (p, l) in [...wordLines.keys, ...headerLines.keys])
        if (p == page) l,
    ];
    final lineCount = used.reduce((a, b) => a > b ? a : b);
    // İlk iki sayfa kısa ve ortalıdır; diğerleri tam 15 satır.
    _check(
      page <= 2 || lineCount == layout.linesPerPage,
      '${layout.id}: s.$page $lineCount satır',
    );
    for (var line = 1; line <= lineCount; line++) {
      final words = wordLines[(page, line)];
      final header = headerLines[(page, line)];
      _check(
        (words == null) != (header == null),
        '${layout.id}: s.$page satır $line türü belirlenemedi',
      );
      lines.add(
        LayoutLinesCompanion.insert(
          layoutId: layout.id,
          page: page,
          line: line,
          type: header?.$1 ?? LayoutLineType.ayah,
          surah: Value(header?.$2),
          firstWordId: Value(words?[0]),
          lastWordId: Value(words?[1]),
        ),
      );
    }
  }

  await db.batch((b) {
    b.insert(
      db.mushafLayouts,
      MushafLayoutsCompanion.insert(
        id: layout.id,
        name: layout.name,
        pageCount: layout.pageCount,
        linesPerPage: layout.linesPerPage,
        fontPack: layout.fontPack,
        version: layout.version,
      ),
    );
    b.insertAll(db.layoutLines, lines);
    b.insertAll(db.layoutPages, [
      for (final MapEntry(key: page, value: r) in pageAyahs.entries)
        LayoutPagesCompanion.insert(
          layoutId: layout.id,
          page: page,
          firstAyahId: r[0],
          lastAyahId: r[1],
        ),
    ]);
    b.insertAll(db.layoutWordGlyphs, glyphs);
  });
  stdout.writeln(
    '${layout.id}: ${layout.pageCount} sayfa, ${lines.length} satır',
  );
}

List<dynamic> _readList(String name) =>
    jsonDecode(File('$_sourceDir/$name').readAsStringSync()) as List<dynamic>;

void _check(bool condition, String message) {
  if (!condition) throw StateError('Veri doğrulaması başarısız: $message');
}
