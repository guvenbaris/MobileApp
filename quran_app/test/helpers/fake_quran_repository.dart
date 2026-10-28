import 'package:quran_app/core/result/result.dart';
import 'package:quran_app/features/quran/domain/mushaf_page.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';
import 'package:quran_app/features/quran/domain/quran_navigation.dart';
import 'package:quran_app/features/quran/domain/quran_repository.dart';

/// Widget testleri için iki sureli küçük sahte içerik.
///
/// Sayfa eşlemesi gerçeğe benzer ama basittir: Fatiha 1. sayfa; Bakara
/// 2. sayfadan başlar ve her sayfada 10 ayet vardır (2:1–10 → 2, 2:11–20 → 3…).
/// Mushaf sayfası çizim verisi yoktur (getMushafPage hata döner; okuma
/// ekranı hata durumunu gösterir).
class FakeQuranRepository implements QuranRepository {
  static const surahs = [
    Surah(
      id: 1,
      nameArabic: 'الفاتحة',
      nameTr: 'Fâtiha',
      nameEn: 'The Opener',
      nameSimple: 'Al-Fatihah',
      revelationPlace: RevelationPlace.makkah,
      revelationOrder: 5,
      bismillahPre: false,
      ayahCount: 7,
    ),
    Surah(
      id: 2,
      nameArabic: 'البقرة',
      nameTr: 'Bakara',
      nameEn: 'The Cow',
      nameSimple: 'Al-Baqarah',
      revelationPlace: RevelationPlace.madinah,
      revelationOrder: 87,
      bismillahPre: true,
      ayahCount: 286,
    ),
  ];

  /// Sahte sayfa sayısı: Fatiha + Bakara (286 ayet / 10).
  static const pageCount = 30;

  static bool _exists(AyahRef ref) =>
      ref.surah >= 1 &&
      ref.surah <= surahs.length &&
      ref.ayah >= 1 &&
      ref.ayah <= surahs[ref.surah - 1].ayahCount;

  static int _page(AyahRef ref) =>
      ref.surah == 1 ? 1 : 2 + (ref.ayah - 1) ~/ 10;

  @override
  Future<Result<List<Surah>>> getSurahs() async => const Ok(surahs);

  @override
  Future<Result<Ayah>> getAyah(AyahRef ref) async => _exists(ref)
      ? Ok(
          Ayah(
            ref: ref,
            juz: 1,
            hizb: 1,
            rub: 1,
            textQpcHafs: 'آية $ref',
            textDigitalKhatt: 'آية $ref',
          ),
        )
      : Err(NotFoundFailure('$ref'));

  @override
  Future<Result<List<Ayah>>> getAyahsOfSurah(int surah) async =>
      Err(NotFoundFailure('$surah'));

  @override
  Future<Result<int>> pageOf(String layoutId, AyahRef ref) async =>
      _exists(ref) ? Ok(_page(ref)) : Err(NotFoundFailure('$ref'));

  @override
  Future<Result<AyahRef>> firstAyahOfPage(String layoutId, int page) async =>
      switch (page) {
        1 => const Ok(AyahRef(1, 1)),
        >= 2 && <= pageCount => Ok(AyahRef(2, (page - 2) * 10 + 1)),
        _ => Err(NotFoundFailure('$page')),
      };

  @override
  Future<Result<MushafPage>> getMushafPage(String layoutId, int page) async =>
      Err(NotFoundFailure('$page'));

  @override
  Future<Result<List<QuarterStart>>> quarterStarts(String layoutId) async =>
      const Ok([
        QuarterStart(juz: 1, hizb: 1, rub: 1, start: AyahRef(1, 1), page: 1),
        QuarterStart(juz: 1, hizb: 1, rub: 2, start: AyahRef(2, 26), page: 4),
        QuarterStart(juz: 2, hizb: 3, rub: 9, start: AyahRef(2, 142), page: 16),
      ]);
}
