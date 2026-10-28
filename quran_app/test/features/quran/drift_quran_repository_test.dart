import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/result/result.dart';
import 'package:quran_app/features/quran/application/quran_providers.dart';
import 'package:quran_app/features/quran/data/content_database.dart';
import 'package:quran_app/features/quran/data/drift_quran_repository.dart';
import 'package:quran_app/features/quran/domain/mushaf_page.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';

import '../../helpers/content_db.dart';

void main() {
  late ContentDatabase db;
  late DriftQuranRepository repo;

  setUp(() {
    db = openTestContentDatabase();
    repo = DriftQuranRepository(db);
  });

  test('veritabanı kodla aynı içerik sürümünde', () async {
    final row = await (db.select(
      db.contentMeta,
    )..where((m) => m.key.equals('contentVersion'))).getSingle();
    expect(row.value, '$kContentVersion');
  });

  test('114 sure, Türkçe ve Arapça adlarıyla', () async {
    final surahs = (await repo.getSurahs()).valueOrNull!;
    expect(surahs, hasLength(114));
    expect(surahs.first.nameTr, 'Fâtiha');
    expect(surahs[1].nameArabic, 'البقرة');
    expect(surahs.fold<int>(0, (sum, s) => sum + s.ayahCount), 6236);
  });

  test('ayet meta verisi: Ayetü\'l-Kürsi 3. cüzde', () async {
    final ayah = (await repo.getAyah(const AyahRef(2, 255))).valueOrNull!;
    expect(ayah.juz, 3);
    expect(ayah.sajdah, isNull);
    expect(ayah.textQpcHafs, isNotEmpty);
  });

  test('secde ayeti işaretli', () async {
    final ayah = (await repo.getAyah(const AyahRef(96, 19))).valueOrNull!;
    expect(ayah.sajdah, isNotNull);
  });

  test('surenin ayetleri sırayla gelir', () async {
    final ayahs = (await repo.getAyahsOfSurah(1)).valueOrNull!;
    expect(ayahs.map((a) => a.ref.ayah), [1, 2, 3, 4, 5, 6, 7]);
  });

  group('konum ↔ sayfa (M2-15)', () {
    test('ayetin sayfası', () async {
      Future<int?> page(int s, int a) async =>
          (await repo.pageOf(kDefaultLayoutId, AyahRef(s, a))).valueOrNull;
      expect(await page(1, 1), 1);
      expect(await page(2, 1), 2);
      expect(await page(114, 6), 604);
    });

    test('sayfanın ilk ayeti', () async {
      final ref = await repo.firstAyahOfPage(kDefaultLayoutId, 604);
      expect(ref.valueOrNull, const AyahRef(112, 1));
    });
  });

  group('mushaf sayfası', () {
    Future<MushafPage> page(int n) async =>
        (await repo.getMushafPage(kDefaultLayoutId, n)).valueOrNull!;

    test('1. sayfa: sure başlığı + 7 ayet satırı, hepsi ortalı', () async {
      final p = await page(1);
      expect(p.lines, hasLength(8));
      expect(p.lines.first.type, LayoutLineType.surahName);
      expect(p.lines.first.surah, 1);
      expect(p.lines.every((l) => l.isCentered), isTrue);
      expect(p.firstAyah, const AyahRef(1, 1));
      expect(p.juz, 1);
      final words = p.lines.expand((l) => l.words).toList();
      expect(words.first.ref, const WordRef(1, 1, 1));
      expect(words.last.ref, const WordRef(1, 7, 10));
      expect(words.last.isAyahEnd, isTrue);
    });

    test('2. sayfa: başlık ve besmele satırı, sonra ayetler', () async {
      final p = await page(2);
      expect(p.lines.map((l) => l.type).take(3), [
        LayoutLineType.surahName,
        LayoutLineType.basmala,
        LayoutLineType.ayah,
      ]);
      expect(p.lines[1].surah, 2);
    });

    test('15 satırlı sayfada glif ve kelimeler satırlara dağılır', () async {
      final p = await page(254);
      expect(p.lines, hasLength(15));
      // 254. sayfa düzeltmesi: 7. satır "مَا" ile başlar (Q-13).
      expect(p.lines[6].words.first.ref, const WordRef(13, 37, 9));
      expect(p.lines[5].words.last.ref, const WordRef(13, 37, 8));
      for (final l in p.lines.where((l) => l.type == LayoutLineType.ayah)) {
        expect(l.glyphs, isNotEmpty);
        expect(l.words, isNotEmpty);
      }
    });

    test('tek glif iki kelimeyi kapsayabilir (37:130)', () async {
      final p = await page(451);
      final glyph = p.lines
          .expand((l) => l.glyphs)
          .firstWhere((g) => g.words.length > 1);
      expect(glyph.words, const [WordRef(37, 130, 3), WordRef(37, 130, 4)]);
    });

    test('olmayan sayfa NotFoundFailure döndürür', () async {
      expect(
        await repo.getMushafPage(kDefaultLayoutId, 605),
        isA<Err<MushafPage>>(),
      );
    });
  });

  test('olmayan kayıtlar NotFoundFailure döndürür', () async {
    expect(await repo.getAyah(const AyahRef(1, 8)), isA<Err<Ayah>>());
    expect(await repo.getAyahsOfSurah(115), isA<Err<List<Ayah>>>());
    expect(
      await repo.firstAyahOfPage(kDefaultLayoutId, 605),
      isA<Err<AyahRef>>(),
    );
    expect(
      await repo.pageOf('olmayan_duzen', const AyahRef(1, 1)),
      isA<Err<int>>(),
    );
  });
}
