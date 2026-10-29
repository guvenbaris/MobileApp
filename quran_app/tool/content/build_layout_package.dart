// İndirilebilir mushaf düzeni paketi üretir (F1-03, TK-13, M2-14).
//
// Paket, içerik veritabanıyla aynı şemada bir SQLite dosyasıdır; yalnızca
// tek düzenin `mushaf_layouts`, `layout_lines`, `layout_pages` ve
// `layout_glyphs` satırlarını ve `content_meta` içinde kimliğini taşır.
// Metin ve kelimeler içerik veritabanında kalır; paket onlara `words.id`
// ile bağlanır ve içerikle aynı kelime parmak izini (`wordsHash`) taşır.
//
// Medine 1405H (KFGQPC V1, QUL kaynak 15 ve 57): V1 glif birimlerinin
// numaraları ve konumları V2 ile birebir aynıdır (betik doğrular). Bu
// yüzden gliflerin kelime eşlemesi ve DigitalKhatt metni yerleşik 1421H
// düzeninden alınır; yalnızca satır ve sayfa bölünmesi V1'den gelir.
// Hiçbir yer elle düzeltilmez.
//
// Lisans: QUL "telif bilgisi yok"; asıl hak sahibi KFGQPC (AK-11). Paket
// yalnızca geliştirmede kullanılır, uygulamaya gömülmez (İÇ-10).
//
// Önce içerik veritabanı üretilmiş olmalı. Çalıştırma (quran_app içinde):
//   dart run tool/content/build_layout_package.dart
// Çıktı: build/packages/madani_1405_v1.sqlite
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:quran_app/features/quran/data/content_database.dart';
import 'package:quran_app/features/quran/domain/mushaf_layout.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';
import 'package:quran_app/features/user_data/domain/user_data_repositories.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import 'qul_layout.dart';

const _qulDir = 'tool/content/sources/qul';
const _outDir = 'build/packages';

const _layout = (
  id: 'madani_1405',
  name: 'Medine Mushafı (KFGQPC, 1405H baskısı)',
  pageCount: 604,
  linesPerPage: 15,
  version: 1,
  qulLayoutFile: 'qpc-v1-15-lines.db',
  qulGlyphFile: 'qpc-v1-glyph-codes-wbw.db',
  // Glif numaralarının karşılaştırıldığı yerleşik düzenin QUL dosyası.
  baseGlyphFile: 'qpc-v2.db',
);

Future<void> main() async {
  final contentFile = File(kContentAssetPath);
  checkData(contentFile.existsSync(), '$kContentAssetPath yok; önce üretin');
  final content = ContentDatabase(
    NativeDatabase(
      contentFile,
      setup: (db) => db.execute('PRAGMA query_only = ON'),
    ),
  );
  final qulLayout = sqlite.sqlite3.open(
    '$_qulDir/${_layout.qulLayoutFile}',
    mode: sqlite.OpenMode.readOnly,
  );
  final v1 = sqlite.sqlite3.open(
    '$_qulDir/${_layout.qulGlyphFile}',
    mode: sqlite.OpenMode.readOnly,
  );
  final v2 = sqlite.sqlite3.open(
    '$_qulDir/${_layout.baseGlyphFile}',
    mode: sqlite.OpenMode.readOnly,
  );

  Directory(_outDir).createSync(recursive: true);
  final target = File('$_outDir/${_layout.id}_v${_layout.version}.sqlite');
  final temp = File('${target.path}.tmp');
  if (temp.existsSync()) temp.deleteSync();

  try {
    final meta = {
      for (final row in await content.select(content.contentMeta).get())
        row.key: row.value,
    };
    final wordsHash = meta[ContentMetaKeys.wordsHash];
    checkData(wordsHash != null, 'İçerikte wordsHash yok');

    // V1 ve V2 glif birimleri aynı numara ve konumda olmalı.
    Map<int, String> locations(sqlite.Database db) => {
      for (final r in db.select('SELECT id, location FROM words'))
        r['id'] as int: r['location'] as String,
    };
    final v1Locations = locations(v1);
    // Bu baskının QCF V1 glif kodları (saklanır, uygulamada kullanılmaz).
    final v1Codes = {
      for (final r in v1.select('SELECT id, text FROM words'))
        r['id'] as int: r['text'] as String,
    };
    final v2Locations = locations(v2);
    checkData(v1Locations.length == v2Locations.length, 'Glif sayısı farklı');
    for (final MapEntry(:key, :value) in v1Locations.entries) {
      checkData(v2Locations[key] == value, 'Glif $key konumu V1/V2 farklı');
    }

    // Glif → kelime eşlemesi ve metin: yerleşik düzenden.
    final baseGlyphs = await (content.select(
      content.layoutGlyphs,
    )..where((g) => g.layoutId.equals(kDefaultLayout.id))).get();
    checkData(baseGlyphs.length == v1Locations.length, 'Glif sayısı');
    final glyphToWords = {
      for (final g in baseGlyphs) g.id: (g.firstWordId, g.lastWordId),
    };

    final rows = readQulLines(qulLayout);
    checkData(rows.length == 9046, 'Satır sayısı ${rows.length}');
    final lineOfWord = checkQulLines(
      rows,
      glyphToWords,
      glyphCount: baseGlyphs.length,
    );
    final words = await content.select(content.words).get();
    checkData(lineOfWord.length == words.length, 'Satırlarda olmayan kelime');
    final pageAyahs = pageAyahRanges(lineOfWord, {
      for (final w in words) w.id: w.ayahId,
    });
    checkData(pageAyahs.length == _layout.pageCount, 'Sayfa sayısı');

    final pkg = ContentDatabase(NativeDatabase(temp));
    try {
      await pkg.batch((b) {
        b.insertAll(pkg.contentMeta, [
          for (final (key, value) in [
            (ContentMetaKeys.packageId, _layout.id),
            (ContentMetaKeys.packageKind, PackageKind.layout),
            (ContentMetaKeys.packageVersion, '${_layout.version}'),
            (ContentMetaKeys.wordsHash, wordsHash!),
            (
              ContentMetaKeys.source,
              'QUL ${_layout.qulLayoutFile}, ${_layout.qulGlyphFile}; '
                  'glif eşlemesi ve DigitalKhatt metni içerik sürümü '
                  '${meta[ContentMetaKeys.contentVersion]}',
            ),
            (ContentMetaKeys.builtAt, DateTime.now().toUtc().toIso8601String()),
          ])
            ContentMetaCompanion.insert(key: key, value: value),
        ]);
        b.insert(
          pkg.mushafLayouts,
          MushafLayoutsCompanion.insert(
            id: _layout.id,
            name: _layout.name,
            pageCount: _layout.pageCount,
            linesPerPage: _layout.linesPerPage,
            fontPack: kDefaultLayout.fontPack,
            version: _layout.version,
          ),
        );
        b.insertAll(pkg.layoutGlyphs, [
          for (final g in baseGlyphs)
            LayoutGlyphsCompanion.insert(
              layoutId: _layout.id,
              id: g.id,
              firstWordId: g.firstWordId,
              lastWordId: g.lastWordId,
              glyph: v1Codes[g.id]!,
              digitalKhattText: Value(g.digitalKhattText),
            ),
        ]);
        b.insertAll(pkg.layoutLines, [
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
        b.insertAll(pkg.layoutPages, [
          for (final MapEntry(key: page, value: r) in pageAyahs.entries)
            LayoutPagesCompanion.insert(
              layoutId: _layout.id,
              page: page,
              firstAyahId: r[0],
              lastAyahId: r[1],
            ),
        ]);
      });
      await pkg.customStatement('VACUUM');
    } finally {
      await pkg.close();
    }
  } finally {
    await content.close();
    qulLayout.close();
    v1.close();
    v2.close();
  }

  if (target.existsSync()) target.deleteSync();
  temp.renameSync(target.path);
  final mb = (target.lengthSync() / 1024 / 1024).toStringAsFixed(1);
  stdout.writeln('Üretildi: ${target.path} ($mb MB)');
}
