// T-02 her düzen için (F1-03, M2-14): indirilebilir düzen paketlerinin yapı
// denetimi. `build/packages/*.sqlite` altındaki her paket (paket üretim
// aracının çıktısı) ve kendini sınamak için testlerin "birleşik sayfalar"
// düzeni burada denetlenir. Yerleşik Medine 1421H düzeninin ayrıntılı
// denetimi `t02_mushaf_layout_test.dart` içindedir.
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/quran/data/content_database.dart';
import 'package:quran_app/features/quran/data/layout_package_store.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';

import '../helpers/content_db.dart';
import '../helpers/layout_package.dart';
import '../helpers/tanzil_reference.dart';

const _packagesDir = 'build/packages';

void main() {
  final packageFiles = Directory(_packagesDir).existsSync()
      ? [
          for (final f in Directory(_packagesDir).listSync())
            if (f is File && f.path.endsWith('.sqlite')) f,
        ]
      : <File>[];

  test('üretilmiş düzen paketleri', () {
    if (packageFiles.isEmpty) {
      markTestSkipped(
        '$_packagesDir boş: paket üretilmediği için yalnız test düzeni '
        'denetlenir.',
      );
    }
  });

  group('test düzeni (birleşik sayfalar)', () {
    late ContentDatabase content;
    late Directory temp;

    setUp(() {
      content = openTestContentDatabase();
      temp = Directory.systemTemp.createTempSync('t02_pkg_');
      addTearDown(() => temp.deleteSync(recursive: true));
    });

    test('yapı denetimi geçer', () async {
      final file = await buildMergedLayoutPackage(content, temp);
      await _checkPackage(content, file, temp);
    });
  });

  for (final file in packageFiles) {
    test('paket: ${file.uri.pathSegments.last}', () async {
      final content = openTestContentDatabase();
      final temp = Directory.systemTemp.createTempSync('t02_pkg_');
      addTearDown(() => temp.deleteSync(recursive: true));
      await _checkPackage(content, file, temp);
    });
  }
}

/// Paket kurulabiliyor ve düzen tutarlı: sayfalar tüm ayetleri boşluksuz ve
/// örtüşmesiz kapsar, satırlar tüm glifleri sırayla bir kez kapsar, hiçbir
/// kelime iki satıra bölünmez, sayfa satır sayısını aşmaz, her sure
/// başlıklı ve besmele kuralı doğru. Medine 1405H paketinde sayfa başları
/// Tanzil'in (1405H) sayfa verisiyle birebir aynı olmalı.
Future<void> _checkPackage(
  ContentDatabase content,
  File file,
  Directory temp,
) async {
  final store = LayoutPackageStore(
    content,
    directory: Directory('${temp.path}/installed'),
  );
  final record = (await store.install(file)).valueOrNull;
  expect(record, isNotNull, reason: 'Paket doğrulamadan geçmedi');
  final db = ContentDatabase(
    NativeDatabase(
      File('${store.directory.path}/${record!.fileName}'),
      setup: (d) => d.execute('PRAGMA query_only = ON'),
    ),
  );
  addTearDown(db.close);
  final id = record.packageId;
  final layout = await db.select(db.mushafLayouts).getSingle();

  final ayahs = await (content.select(
    content.ayahs,
  )..orderBy([(a) => OrderingTerm(expression: a.id)])).get();
  final pages =
      await (db.select(db.layoutPages)
            ..where((p) => p.layoutId.equals(id))
            ..orderBy([(p) => OrderingTerm(expression: p.page)]))
          .get();
  expect(pages, hasLength(layout.pageCount));
  expect(pages.first.firstAyahId, 1);
  expect(pages.last.lastAyahId, ayahs.length);
  for (var i = 1; i < pages.length; i++) {
    expect(pages[i].page, pages[i - 1].page + 1);
    expect(
      pages[i].firstAyahId,
      inInclusiveRange(pages[i - 1].lastAyahId, pages[i - 1].lastAyahId + 1),
      reason: 's.${pages[i].page} bir önceki sayfanın devamı değil',
    );
  }

  final lines =
      await (db.select(db.layoutLines)
            ..where((l) => l.layoutId.equals(id))
            ..orderBy([
              (l) => OrderingTerm(expression: l.page),
              (l) => OrderingTerm(expression: l.line),
            ]))
          .get();
  for (final l in lines) {
    expect(
      l.line,
      inInclusiveRange(1, layout.linesPerPage),
      reason: 's.${l.page} satır ${l.line}',
    );
  }
  final glyphs = {
    for (final g in await (db.select(
      db.layoutGlyphs,
    )..where((g) => g.layoutId.equals(id))).get())
      g.id: g,
  };
  var expectedNext = glyphs.keys.reduce((a, b) => a < b ? a : b);
  final lineOfWord = <int, String>{};
  for (final l in lines.where((l) => l.type == LayoutLineType.ayah)) {
    expect(l.firstGlyphId, expectedNext, reason: 's.${l.page}/${l.line}');
    for (var g = l.firstGlyphId!; g <= l.lastGlyphId!; g++) {
      final glyph = glyphs[g]!;
      expect(glyph.digitalKhattText, isNotEmpty, reason: 'glif $g metni');
      for (var w = glyph.firstWordId; w <= glyph.lastWordId; w++) {
        final here = '${l.page}/${l.line}';
        expect(
          lineOfWord.putIfAbsent(w, () => here),
          here,
          reason: 'kelime $w',
        );
      }
    }
    expectedNext = l.lastGlyphId! + 1;
  }
  expect(lineOfWord.length, await content.words.count().getSingle());

  final headers = lines.where((l) => l.type == LayoutLineType.surahName);
  final basmalas = lines.where((l) => l.type == LayoutLineType.basmala);
  expect(headers.map((l) => l.surah).toSet(), hasLength(114));
  expect(basmalas.map((l) => l.surah).toSet(), {
    for (var s = 2; s <= 114; s++)
      if (s != 9) s,
  });

  // Medine 1405H: Tanzil'in sayfa verisi bu baskıya aittir (Q-10); fark
  // olmamalı.
  if (id == 'madani_1405') {
    final reference = TanzilReference.load().starts('page');
    for (final p in pages) {
      final a = ayahs[p.firstAyahId - 1];
      expect(
        AyahRef(a.surah, a.ayah),
        reference[p.page],
        reason: 's.${p.page}',
      );
    }
  }
}
