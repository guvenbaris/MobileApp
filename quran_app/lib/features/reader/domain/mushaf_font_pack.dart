/// İsteğe bağlı "birebir görünüm" font paketi: QCF V2 sayfa fontları
/// (604 dosya, ~208 MB). Uygulamayla gelmez; kullanıcı onay verirse
/// indirilir ve tamamı inince devreye girer (TK-06).
abstract interface class MushafFontPack {
  /// 604 sayfanın fontu da cihazda mı.
  Future<bool> isInstalled();

  /// Sayfanın fontunu yükler ve Flutter'daki aile adını döndürür.
  Future<String> loadPageFont(int page);
}
