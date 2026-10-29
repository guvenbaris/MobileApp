import '../../../core/result/result.dart';
import 'mushaf_layout.dart';
import 'mushaf_page.dart';
import 'quran_models.dart';
import 'quran_navigation.dart';

/// Kur'an içeriğine erişim (MK-07: arayüz katmanı veritabanına doğrudan
/// erişmez). İçerik cihazdadır, internet gerektirmez (M16-01).
abstract interface class QuranRepository {
  Future<Result<List<Surah>>> getSurahs();

  /// Cihazdaki düzenler: uygulamayla gelen ve kurulu paketlerdeki (M2-14).
  Future<Result<List<MushafLayout>>> getLayouts();

  Future<Result<Ayah>> getAyah(AyahRef ref);

  Future<Result<List<Ayah>>> getAyahsOfSurah(int surah);

  /// Ayetin verilen düzendeki sayfası (M2-15: konum → sayfa dönüşümü).
  Future<Result<int>> pageOf(String layoutId, AyahRef ref);

  /// Sayfanın ilk ayeti (sayfa → konum dönüşümü).
  Future<Result<AyahRef>> firstAyahOfPage(String layoutId, int page);

  /// Bir mushaf sayfasının çizim için gereken tüm bilgisi (M2-01, M2-02).
  Future<Result<MushafPage>> getMushafPage(String layoutId, int page);

  /// 240 rubu'un başlangıç ayeti ve sayfası, sırayla (cüz ve hizb dizini,
  /// M4-01).
  Future<Result<List<QuarterStart>>> quarterStarts(String layoutId);
}
