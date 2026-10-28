import '../../../core/result/result.dart';
import 'quran_models.dart';

/// Kur'an içeriğine erişim (MK-07: arayüz katmanı veritabanına doğrudan
/// erişmez). İçerik cihazdadır, internet gerektirmez (M16-01).
abstract interface class QuranRepository {
  Future<Result<List<Surah>>> getSurahs();

  Future<Result<Ayah>> getAyah(AyahRef ref);

  Future<Result<List<Ayah>>> getAyahsOfSurah(int surah);

  /// Ayetin verilen düzendeki sayfası (M2-15: konum → sayfa dönüşümü).
  Future<Result<int>> pageOf(String layoutId, AyahRef ref);

  /// Sayfanın ilk ayeti (sayfa → konum dönüşümü).
  Future<Result<AyahRef>> firstAyahOfPage(String layoutId, int page);
}
