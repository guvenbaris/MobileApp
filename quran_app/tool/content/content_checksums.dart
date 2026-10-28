// İçerik veritabanının sağlama (SHA-256) değerleri (F0-04, T-01).
//
// Tanzil yalnızca `text_uthmani` için bağımsız referanstır. KFGQPC metni
// (`text_qpc_hafs`), kelimeler ve mushaf düzeni için bağımsız referans
// olmadığından, doğrulanmış halleri sure başına sağlama değeriyle
// `tool/content/reference/checksums.json` dosyasına sabitlenir. Veride tek
// karakter değişse test hangi surede değiştiğini söyler.
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:quran_app/features/quran/data/content_database.dart';

const checksumsPath = 'tool/content/reference/checksums.json';

/// `{"text": {"1": {...}}, "layouts": {"madani_1421": "..."}}`
Future<Map<String, dynamic>> computeChecksums(ContentDatabase db) async {
  final ayahs = await (db.select(
    db.ayahs,
  )..orderBy([(a) => OrderingTerm(expression: a.id)])).get();
  final words = await (db.select(
    db.words,
  )..orderBy([(w) => OrderingTerm(expression: w.id)])).get();

  String hash(Iterable<String> parts) =>
      sha256.convert(utf8.encode(parts.join('\n'))).toString();

  final text = <String, Map<String, String>>{};
  for (var surah = 1; surah <= 114; surah++) {
    final a = ayahs.where((r) => r.surah == surah).toList();
    final w = words.where((r) => r.surah == surah);
    text['$surah'] = {
      'textUthmani': hash(a.map((r) => r.textUthmani)),
      'textQpcHafs': hash(a.map((r) => r.textQpcHafs)),
      'meta': hash(
        a.map((r) => '${r.ayah}|${r.juz}|${r.hizb}|${r.rub}|${r.sajdah}'),
      ),
      'words': hash(
        w.map(
          (r) =>
              '${r.ayah}|${r.position}|${r.isAyahEnd}|${r.wordText}|'
              '${r.morphFirst}|${r.morphLast}',
        ),
      ),
    };
  }

  final layouts = <String, String>{};
  for (final layout in await db.select(db.mushafLayouts).get()) {
    final lines =
        await (db.select(db.layoutLines)
              ..where((l) => l.layoutId.equals(layout.id))
              ..orderBy([
                (l) => OrderingTerm(expression: l.page),
                (l) => OrderingTerm(expression: l.line),
              ]))
            .get();
    final glyphs =
        await (db.select(db.layoutGlyphs)
              ..where((g) => g.layoutId.equals(layout.id))
              ..orderBy([(g) => OrderingTerm(expression: g.id)]))
            .get();
    layouts[layout.id] = hash([
      ...lines.map(
        (l) =>
            '${l.page}|${l.line}|${l.type.name}|${l.isCentered}|${l.surah}|'
            '${l.firstGlyphId}|${l.lastGlyphId}',
      ),
      ...glyphs.map(
        (g) => '${g.id}|${g.firstWordId}|${g.lastWordId}|${g.glyph}',
      ),
    ]);
  }

  return {'text': text, 'layouts': layouts};
}
