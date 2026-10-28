import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/result/result.dart';
import 'package:quran_app/features/quran/application/quran_providers.dart';
import 'package:quran_app/features/quran/data/content_database.dart';
import 'package:quran_app/features/quran/data/drift_quran_repository.dart';
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
    expect(ayah.textUthmani, isNotEmpty);
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
