import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:quran_app/features/quran/data/content_database.dart';
import 'package:quran_app/features/quran/domain/mushaf_layout.dart';
import 'package:quran_app/features/user_data/domain/user_data_repositories.dart';

/// Testler için gerçek içerikten türetilmiş bir düzen paketi (TK-13): Medine
/// 1421H'nin sayfaları ikişer birleştirilir (302 sayfa × 30 satır). Sayfa
/// numaraları gerçekten farklı olan ikinci bir düzen verir: 1421'deki
/// `n`. sayfa bu düzende `(n + 1) ~/ 2`. sayfadır.
///
/// [wordsHash], [kind], [layoutId] ve [fontPack] bozuk paket denemeleri
/// içindir.
Future<File> buildMergedLayoutPackage(
  ContentDatabase content,
  Directory dir, {
  String id = 'test_merged',
  int version = 1,
  String? wordsHash,
  String kind = PackageKind.layout,
  String? layoutId,
  String? fontPack,
}) async {
  final source = kDefaultLayout.id;
  final file = File(p.join(dir.path, '${id}_v$version.sqlite'));
  if (file.existsSync()) file.deleteSync();
  final pkg = ContentDatabase(NativeDatabase(file));
  try {
    final meta = {
      for (final row in await content.select(content.contentMeta).get())
        row.key: row.value,
    };
    final lines = await (content.select(
      content.layoutLines,
    )..where((l) => l.layoutId.equals(source))).get();
    final pages = await (content.select(
      content.layoutPages,
    )..where((l) => l.layoutId.equals(source))).get();
    final glyphs = await (content.select(
      content.layoutGlyphs,
    )..where((l) => l.layoutId.equals(source))).get();
    final merged = <int, (int, int)>{};
    for (final page in pages) {
      final target = (page.page + 1) ~/ 2;
      final prev = merged[target];
      merged[target] = prev == null
          ? (page.firstAyahId, page.lastAyahId)
          : (prev.$1, page.lastAyahId);
    }
    final rowId = layoutId ?? id;
    await pkg.batch((b) {
      b.insertAll(pkg.contentMeta, [
        for (final (key, value) in [
          (ContentMetaKeys.packageId, id),
          (ContentMetaKeys.packageKind, kind),
          (ContentMetaKeys.packageVersion, '$version'),
          (
            ContentMetaKeys.wordsHash,
            wordsHash ?? meta[ContentMetaKeys.wordsHash]!,
          ),
        ])
          ContentMetaCompanion.insert(key: key, value: value),
      ]);
      b.insert(
        pkg.mushafLayouts,
        MushafLayoutsCompanion.insert(
          id: rowId,
          name: 'Test: birleşik sayfalar',
          pageCount: merged.length,
          linesPerPage: 30,
          fontPack: fontPack ?? kDefaultLayout.fontPack,
          version: version,
        ),
      );
      b.insertAll(pkg.layoutLines, [
        for (final l in lines)
          LayoutLinesCompanion.insert(
            layoutId: rowId,
            page: (l.page + 1) ~/ 2,
            line: l.page.isOdd ? l.line : l.line + 15,
            type: l.type,
            isCentered: l.isCentered,
            surah: Value(l.surah),
            firstGlyphId: Value(l.firstGlyphId),
            lastGlyphId: Value(l.lastGlyphId),
          ),
      ]);
      b.insertAll(pkg.layoutPages, [
        for (final MapEntry(key: page, value: (first, last)) in merged.entries)
          LayoutPagesCompanion.insert(
            layoutId: rowId,
            page: page,
            firstAyahId: first,
            lastAyahId: last,
          ),
      ]);
      b.insertAll(pkg.layoutGlyphs, [
        for (final g in glyphs)
          LayoutGlyphsCompanion.insert(
            layoutId: rowId,
            id: g.id,
            firstWordId: g.firstWordId,
            lastWordId: g.lastWordId,
            glyph: g.glyph,
            digitalKhattText: Value(g.digitalKhattText),
          ),
      ]);
    });
  } finally {
    await pkg.close();
  }
  return file;
}

/// Bellekte kurulu paket kaydı (kullanıcı veritabanı olmadan).
class MemoryInstalledPackageRepository implements InstalledPackageRepository {
  final records = <String, InstalledPackage>{};

  @override
  Future<List<InstalledPackage>> list({String? kind}) async => [
    for (final r in records.values)
      if (kind == null || r.kind == kind) r,
  ];

  @override
  Future<void> remove(String packageId) async => records.remove(packageId);

  @override
  Future<void> save(InstalledPackage package) async =>
      records[package.packageId] = package;
}
