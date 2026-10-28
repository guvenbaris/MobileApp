import 'package:quran_app/core/result/result.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';
import 'package:quran_app/features/quran/domain/quran_repository.dart';

/// Widget testleri için iki sureli küçük sahte içerik.
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

  @override
  Future<Result<List<Surah>>> getSurahs() async => const Ok(surahs);

  @override
  Future<Result<Ayah>> getAyah(AyahRef ref) async =>
      Err(NotFoundFailure('$ref'));

  @override
  Future<Result<List<Ayah>>> getAyahsOfSurah(int surah) async =>
      Err(NotFoundFailure('$surah'));

  @override
  Future<Result<int>> pageOf(String layoutId, AyahRef ref) async =>
      Err(NotFoundFailure('$ref'));

  @override
  Future<Result<AyahRef>> firstAyahOfPage(String layoutId, int page) async =>
      Err(NotFoundFailure('$page'));
}
