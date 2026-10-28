// T-01 Kur'an metin bütünlüğü (İÇ-02, F0-04).
//
// İçerik veritabanındaki metin, bağımsız bir kaynakla (Tanzil) ve
// doğrulanmış sağlama değerleriyle karşılaştırılır. Bu testlerden biri
// kırılırsa uygulama yayınlanamaz (Y-06).
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/quran/data/content_database.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';

import '../../tool/content/content_checksums.dart';
import '../helpers/content_db.dart';
import '../helpers/tanzil_reference.dart';

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

  group('sayılar', () {
    test('114 sure, 6.236 ayet', () async {
      expect(await db.select(db.surahs).get(), hasLength(114));
      expect(ayahs, hasLength(6236));
      expect(tanzil.text, hasLength(6236));
    });

    test('her surenin ayet sayısı Tanzil ile aynı', () async {
      final surahs = await db.select(db.surahs).get();
      final reference = tanzil.ayahCounts;
      for (final s in surahs) {
        final actual = ayahs.where((a) => a.surah == s.id).length;
        expect(actual, reference[s.id], reason: 'Sure ${s.id}');
        expect(s.ayahCount, reference[s.id], reason: 'Sure ${s.id} meta');
      }
    });

    test('77.429 kelime ve her ayette bir ayet sonu işareti', () async {
      final words = await db.select(db.words).get();
      expect(words.where((w) => !w.isAyahEnd), hasLength(77429));
      expect(words.where((w) => w.isAyahEnd), hasLength(6236));
    });
  });

  test('her ayetin metni Tanzil ile karakteri karakterine aynı', () {
    final mismatches = <String>[];
    for (final a in ayahs) {
      final ref = AyahRef(a.surah, a.ayah);
      final expected = tanzil.textWithoutBasmala(ref);
      if (a.textUthmani != expected) {
        mismatches.add('$ref: ${_firstDifference(a.textUthmani, expected)}');
      }
    }
    expect(mismatches, isEmpty, reason: mismatches.take(10).join('\n'));
  });

  test(
    'metin, kelimeler ve düzen doğrulanmış sağlama değerleriyle aynı',
    () async {
      final expected = jsonDecode(
        File(checksumsPath).readAsStringSync(),
      ) as Map<String, dynamic>;
      final actual = await computeChecksums(db);

      final changed = <String>[];
      final expectedText = expected['text'] as Map<String, dynamic>;
      final actualText = actual['text'] as Map<String, dynamic>;
      for (final surah in expectedText.keys) {
        final e = expectedText[surah] as Map<String, dynamic>;
        final a = actualText[surah] as Map<String, String>;
        for (final field in e.keys) {
          if (e[field] != a[field]) changed.add('Sure $surah: $field');
        }
      }
      final expectedLayouts = expected['layouts'] as Map<String, dynamic>;
      final actualLayouts = actual['layouts'] as Map<String, String>;
      for (final id in {...expectedLayouts.keys, ...actualLayouts.keys}) {
        if (expectedLayouts[id] != actualLayouts[id]) changed.add('Düzen $id');
      }

      expect(
        changed,
        isEmpty,
        reason:
            'İçerik değişmiş: ${changed.join(', ')}. Değişiklik bilerek '
            'yapıldıysa incelendikten sonra '
            '`dart run tool/content/update_checksums.dart` çalıştırılmalı.',
      );
    },
  );
}

String _firstDifference(String actual, String expected) {
  final length = actual.length < expected.length
      ? actual.length
      : expected.length;
  var i = 0;
  while (i < length && actual.codeUnitAt(i) == expected.codeUnitAt(i)) {
    i++;
  }
  String hex(String s) => i < s.length
      ? 'U+${s.codeUnitAt(i).toRadixString(16).toUpperCase().padLeft(4, '0')}'
      : 'son';
  return '$i. karakterde fark (veritabanı ${hex(actual)}, '
      'Tanzil ${hex(expected)})';
}
