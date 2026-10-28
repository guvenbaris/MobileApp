import '../../features/quran/domain/quran_models.dart';

/// Rota yolları (`Ekran_Tasarimi.md` §3). Sekmeler: Bugün, Kur'an, Hafızlık,
/// Ben. Okuma ve ayarlar sekmelerin üstünde tam ekran açılır.
abstract final class AppRoutes {
  static const today = '/';
  static const quran = '/quran';
  static const memorize = '/memorize';
  static const me = '/me';
  static const settings = '/settings';
  static const reader = '/read';

  /// Okuma ekranı, verilen mushaf sayfasında.
  static String readerAtPage(int page) => '$reader?page=$page';

  /// Okuma ekranı, verilen ayette (derin bağlantı: `/read?ayah=2:255`).
  static String readerAtAyah(AyahRef ayah) => '$reader?ayah=$ayah';
}
