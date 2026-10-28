/// Rota yolları. Ayet paylaşımı için derin bağlantılar Faz 1'de eklenir.
abstract final class AppRoutes {
  static const home = '/';
  static const reader = '/read';
  static const settings = '/settings';

  /// Okuma ekranı, verilen mushaf sayfasında.
  static String readerAt(int page) => '$reader?page=$page';
}
