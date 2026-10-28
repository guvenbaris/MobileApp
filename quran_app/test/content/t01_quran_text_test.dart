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
import '../../tool/content/text_rules.dart';
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

    test('77.430 kelime ve her ayette bir ayet sonu işareti', () async {
      final words = await db.select(db.words).get();
      expect(words.where((w) => !w.isAyahEnd), hasLength(77430));
      expect(words.where((w) => w.isAyahEnd), hasLength(6236));
    });
  });

  group('kelime bölünmesi (esas: KFGQPC metni)', () {
    late List<WordRow> words;

    setUp(() async {
      words = await (db.select(
        db.words,
      )..orderBy([(w) => OrderingTerm(expression: w.id)])).get();
    });

    test('kelimeler ayetin KFGQPC metnini birebir oluşturur', () {
      final byAyah = <int, List<WordRow>>{};
      for (final w in words) {
        byAyah.putIfAbsent(w.ayahId, () => []).add(w);
      }
      final mismatches = <String>[];
      for (final a in ayahs) {
        // ۞ işareti kelime sayılmaz. Parçalar normal veya bölünmez boşlukla
        // ayrılır (ayet numarası genelde bölünmez boşlukla; 2:72'de normal).
        final expected = a.textQpcHafs
            .split(RegExp('[  ]'))
            .where((t) => t.isNotEmpty && t != '۞')
            .toList();
        final ws = byAyah[a.id]!;
        final actual = ws.map((w) => w.wordText).toList();
        if (actual.join('|') != expected.join('|') || !ws.last.isAyahEnd) {
          mismatches.add('${a.surah}:${a.ayah}');
        }
        final positions = ws.map((w) => w.position).toList();
        if (positions.join(',') !=
            List.generate(ws.length, (i) => i + 1).join(',')) {
          mismatches.add('${a.surah}:${a.ayah} sıra');
        }
      }
      expect(mismatches, isEmpty, reason: mismatches.take(10).join('\n'));
    });

    test(
      'Corpus (Quran.com) bölünmesinden yalnızca bilinen 7 yerde ayrışır',
      () {
        // VERI_KAYNAKLARI.md Q-12. Eşleme veriden otomatik çıkarılır; burada
        // yalnızca sonucun beklenen yerlerle sınırlı olduğu denetlenir.
        final differing = <String>{
          for (final w in words.where((w) => !w.isAyahEnd))
            if (w.morphFirst != w.morphLast || w.morphFirst != w.position)
              '${w.surah}:${w.ayah}',
        };
        expect(differing, {
          '2:181', '8:6', '13:37', // بَعۡدَ مَا: KFGQPC 2, Corpus 1
          '15:7', '27:20', '36:22', // لَّوۡمَا, مَالِيَ: KFGQPC 1, Corpus 2
          '37:130', // إِلۡ يَاسِينَ: KFGQPC 2, Corpus 1
        });

        WordRow at(int s, int a, int p) => words.firstWhere(
          (w) => w.surah == s && w.ayah == a && w.position == p,
        );
        // "بَعۡدَ" ve "مَا" aynı Corpus kelimesine ("baʿdamā") bağlanır.
        expect((at(2, 181, 3).morphFirst, at(2, 181, 4).morphFirst), (3, 3));
        // "لَّوۡمَا" iki Corpus kelimesini ("law", "mā") kapsar.
        expect((at(15, 7, 1).morphFirst, at(15, 7, 1).morphLast), (1, 2));
      },
    );

    test(
      'mushaf glifleriyle yalnızca bilinen 4 yerde bire bir değil',
      () async {
        final glyphs = await db.select(db.layoutGlyphs).get();
        final glyphsPerWord = <int, int>{};
        for (final g in glyphs) {
          for (var w = g.firstWordId; w <= g.lastWordId; w++) {
            glyphsPerWord[w] = (glyphsPerWord[w] ?? 0) + 1;
          }
        }
        final byId = {for (final w in words) w.id: w};
        final differing = <String>{
          for (final g in glyphs)
            if (g.firstWordId != g.lastWordId)
              '${byId[g.firstWordId]!.surah}:${byId[g.firstWordId]!.ayah}',
          for (final MapEntry(:key, :value) in glyphsPerWord.entries)
            if (value != 1) '${byId[key]!.surah}:${byId[key]!.ayah}',
        };
        expect(differing, {'15:7', '27:20', '36:22', '37:130'});
        expect(glyphsPerWord.length, words.length, reason: 'glifsiz kelime');
      },
    );
  });

  test('her ayetin harfleri bağımsız kaynakla (Tanzil) aynı: KFGQPC ve DigitalKhatt', () {
    // Tanzil tek dış referanstır ve uygulamaya girmez (Faz 1 S9). Kodlamalar
    // farklı olduğu için harf iskeleti karşılaştırılır (VERI_KAYNAKLARI Q-15).
    final mismatches = <String>[];
    for (final a in ayahs) {
      final ref = AyahRef(a.surah, a.ayah);
      final expected = letterSkeleton(tanzil.textWithoutBasmala(ref));
      for (final (name, text) in [
        ('KFGQPC', a.textQpcHafs),
        ('DigitalKhatt', a.textDigitalKhatt),
      ]) {
        final actual = letterSkeleton(text);
        if (actual != expected) {
          mismatches.add('$ref $name: ${_firstDifference(actual, expected)}');
        }
      }
    }
    expect(mismatches, isEmpty, reason: mismatches.take(10).join('\n'));
  });

  group('ekranda gösterilen metin (DigitalKhatt)', () {
    test('durak işaretleri resmi 1421H metniyle (KFGQPC) aynı', () {
      // Tanzil'in durak işaretleri 1405H baskısını izler ve 323 ayette
      // farklıdır; bu yüzden burada referans değildir (VERI_KAYNAKLARI Q-15).
      final mismatches = [
        for (final a in ayahs)
          if (waqfMarks(a.textDigitalKhatt) != waqfMarks(a.textQpcHafs))
            '${a.surah}:${a.ayah}',
      ];
      expect(mismatches, isEmpty, reason: mismatches.join(', '));
    });

    test('her ayet kendi numarasıyla biter', () {
      String digits(int n) =>
          String.fromCharCodes('$n'.codeUnits.map((c) => c - 0x30 + 0x0660));
      for (final a in ayahs) {
        expect(
          a.textDigitalKhatt.endsWith(digits(a.ayah)),
          isTrue,
          reason: '${a.surah}:${a.ayah}',
        );
      }
    });
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
      for (final surah in {...expectedText.keys, ...actualText.keys}) {
        final e =
            (expectedText[surah] ?? const <String, dynamic>{})
                as Map<String, dynamic>;
        final a =
            (actualText[surah] ?? const <String, String>{})
                as Map<String, String>;
        // Yeni eklenen veya kaldırılan alanlar da değişiklik sayılır.
        for (final field in {...e.keys, ...a.keys}) {
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
