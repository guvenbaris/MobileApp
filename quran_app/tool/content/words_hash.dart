// Kelime tablosunun parmak izi (TK-13). Düzen paketleri glifleri esas
// kelimelere `words.id` ile bağlar; paket ancak aynı parmak izini taşıyan
// içerik veritabanıyla kullanılabilir. İçerik ve paket üreticileri aynı
// hesabı kullanır.
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:quran_app/features/quran/data/content_database.dart';

Future<String> computeWordsHash(ContentDatabase db) async {
  final words = await (db.select(
    db.words,
  )..orderBy([(w) => OrderingTerm(expression: w.id)])).get();
  final text = words
      .map(
        (w) =>
            '${w.id}|${w.ayahId}|${w.surah}|${w.ayah}|${w.position}|'
            '${w.isAyahEnd}',
      )
      .join('\n');
  return sha256.convert(utf8.encode(text)).toString();
}
