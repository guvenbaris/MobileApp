import 'package:drift/drift.dart';

import '../../../core/result/result.dart';
import '../domain/quran_models.dart';
import '../domain/quran_repository.dart';
import 'content_database.dart';

class DriftQuranRepository implements QuranRepository {
  const DriftQuranRepository(this._db);

  final ContentDatabase _db;

  @override
  Future<Result<List<Surah>>> getSurahs() => _guard(() async {
    final rows = await (_db.select(
      _db.surahs,
    )..orderBy([(s) => OrderingTerm(expression: s.id)])).get();
    return Ok(rows.map(_toSurah).toList());
  });

  @override
  Future<Result<Ayah>> getAyah(AyahRef ref) => _guard(() async {
    final row =
        await (_db.select(_db.ayahs)..where(
              (a) => a.surah.equals(ref.surah) & a.ayah.equals(ref.ayah),
            ))
            .getSingleOrNull();
    return row == null
        ? Err(NotFoundFailure('Ayet yok: $ref'))
        : Ok(_toAyah(row));
  });

  @override
  Future<Result<List<Ayah>>> getAyahsOfSurah(int surah) => _guard(() async {
    final rows =
        await (_db.select(_db.ayahs)
              ..where((a) => a.surah.equals(surah))
              ..orderBy([(a) => OrderingTerm(expression: a.ayah)]))
            .get();
    return rows.isEmpty
        ? Err(NotFoundFailure('Sure yok: $surah'))
        : Ok(rows.map(_toAyah).toList());
  });

  @override
  Future<Result<int>> pageOf(String layoutId, AyahRef ref) => _guard(() async {
    final ayah =
        await (_db.select(_db.ayahs)..where(
              (a) => a.surah.equals(ref.surah) & a.ayah.equals(ref.ayah),
            ))
            .getSingleOrNull();
    if (ayah == null) return Err(NotFoundFailure('Ayet yok: $ref'));

    // Birden fazla sayfaya yayılan ayet, başladığı sayfaya aittir.
    final page =
        await (_db.select(_db.layoutPages)
              ..where(
                (p) =>
                    p.layoutId.equals(layoutId) &
                    p.firstAyahId.isSmallerOrEqualValue(ayah.id) &
                    p.lastAyahId.isBiggerOrEqualValue(ayah.id),
              )
              ..orderBy([(p) => OrderingTerm(expression: p.page)])
              ..limit(1))
            .getSingleOrNull();
    return page == null
        ? Err(NotFoundFailure('Düzen yok: $layoutId'))
        : Ok(page.page);
  });

  @override
  Future<Result<AyahRef>> firstAyahOfPage(String layoutId, int page) =>
      _guard(() async {
        final query =
            _db.select(_db.layoutPages).join([
              innerJoin(
                _db.ayahs,
                _db.ayahs.id.equalsExp(_db.layoutPages.firstAyahId),
              ),
            ])..where(
              _db.layoutPages.layoutId.equals(layoutId) &
                  _db.layoutPages.page.equals(page),
            );
        final row = await query.getSingleOrNull();
        if (row == null) return Err(NotFoundFailure('Sayfa yok: $page'));
        final ayah = row.readTable(_db.ayahs);
        return Ok(AyahRef(ayah.surah, ayah.ayah));
      });

  Future<Result<T>> _guard<T>(Future<Result<T>> Function() body) async {
    try {
      return await body();
    } on Exception catch (e, st) {
      return Err(
        UnexpectedFailure('İçerik okunamadı', error: e, stackTrace: st),
      );
    }
  }

  static Surah _toSurah(SurahRow r) => Surah(
    id: r.id,
    nameArabic: r.nameArabic,
    nameTr: r.nameTr,
    nameEn: r.nameEn,
    nameSimple: r.nameSimple,
    revelationPlace: r.revelationPlace,
    revelationOrder: r.revelationOrder,
    bismillahPre: r.bismillahPre,
    ayahCount: r.ayahCount,
  );

  static Ayah _toAyah(AyahRow r) => Ayah(
    ref: AyahRef(r.surah, r.ayah),
    juz: r.juz,
    hizb: r.hizb,
    rub: r.rub,
    sajdah: r.sajdah,
    textUthmani: r.textUthmani,
    textQpcHafs: r.textQpcHafs,
  );
}
