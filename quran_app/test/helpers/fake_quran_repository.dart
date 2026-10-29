import 'package:quran_app/core/result/result.dart';
import 'package:quran_app/features/quran/domain/mushaf_page.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';
import 'package:quran_app/features/quran/domain/quran_navigation.dart';
import 'package:quran_app/features/quran/domain/quran_repository.dart';

/// Widget testleri için iki sureli küçük sahte içerik.
///
/// Sayfa eşlemesi gerçeğe benzer ama basittir: Fatiha 1. sayfa; Bakara
/// 2. sayfadan başlar ve her sayfada 10 ayet vardır (2:1–10 → 2, 2:11–20 → 3…).
/// Varsayılan olarak mushaf sayfası çizim verisi yoktur (getMushafPage hata
/// döner; okuma ekranı hata durumunu gösterir). [withPages] ile her ayet bir
/// satır olan basit sayfalar verilir. Cüz 2, Hizb 3 sahte veride 2:142'de
/// başlar ([quarterStarts] ile aynı).
class FakeQuranRepository implements QuranRepository {
  FakeQuranRepository({this.withPages = false, this.sajdahs = const {}});

  final bool withPages;

  /// Secde ayeti sayılacak ayetler (sahte veride yoktur; testler verir).
  final Set<AyahRef> sajdahs;
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

  static const _juz2 = AyahRef(2, 142);

  static List<AyahRef> _ayahsOfPage(int page) => page == 1
      ? [for (var a = 1; a <= 7; a++) AyahRef(1, a)]
      : [
          for (
            var a = (page - 2) * 10 + 1;
            a <= (page - 1) * 10 && a <= 286;
            a++
          )
            AyahRef(2, a),
        ];

  Ayah _ayah(AyahRef ref) => Ayah(
    ref: ref,
    juz: ref.compareTo(_juz2) >= 0 ? 2 : 1,
    hizb: ref.compareTo(_juz2) >= 0 ? 3 : 1,
    rub: 1,
    sajdah: sajdahs.contains(ref) ? 1 : null,
    textQpcHafs: 'آية $ref',
    textDigitalKhatt: 'آية $ref',
  );

  @override
  Future<Result<List<Surah>>> getSurahs() async => const Ok(surahs);

  @override
  Future<Result<Ayah>> getAyah(AyahRef ref) async =>
      _exists(ref) ? Ok(_ayah(ref)) : Err(NotFoundFailure('$ref'));

  @override
  Future<Result<List<Ayah>>> getAyahsOfSurah(int surah) async =>
      surah < 1 || surah > surahs.length
      ? Err(NotFoundFailure('$surah'))
      : Ok([
          for (var a = 1; a <= surahs[surah - 1].ayahCount; a++)
            _ayah(AyahRef(surah, a)),
        ]);

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
  Future<Result<MushafPage>> getMushafPage(String layoutId, int page) async {
    if (!withPages || page < 1 || page > pageCount) {
      return Err(NotFoundFailure('$page'));
    }
    final ayahs = _ayahsOfPage(page);
    final first = _ayah(ayahs.first);
    final quarters = (await quarterStarts(layoutId)).valueOrNull!;
    return Ok(
      MushafPage(
        layoutId: layoutId,
        number: page,
        firstAyah: first.ref,
        juz: first.juz,
        hizb: first.hizb,
        sajdahAyahs: [...ayahs.where(sajdahs.contains)],
        quarterStarts: [...quarters.where((q) => q.page == page)],
        lines: [
          for (final (i, ref) in ayahs.indexed)
            MushafLine(
              number: i + 1,
              type: LayoutLineType.ayah,
              isCentered: false,
              words: const [],
              glyphs: [
                PageGlyph(
                  glyph: '',
                  digitalKhattText: 'آية $ref',
                  words: [WordRef(ref.surah, ref.ayah, 1)],
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Future<Result<List<QuarterStart>>> quarterStarts(String layoutId) async =>
      const Ok([
        QuarterStart(juz: 1, hizb: 1, rub: 1, start: AyahRef(1, 1), page: 1),
        QuarterStart(juz: 1, hizb: 1, rub: 2, start: AyahRef(2, 26), page: 4),
        QuarterStart(juz: 2, hizb: 3, rub: 9, start: AyahRef(2, 142), page: 16),
      ]);
}
