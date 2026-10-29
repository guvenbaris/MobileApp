/// Bir mushaf düzeni (M2-02, M2-14): sayfa ve satır yapısı ve çizildiği
/// font. Uygulamayla gelen düzen içerik veritabanındadır; diğerleri
/// indirilebilir paketle eklenir (TK-13).
class MushafLayout {
  const MushafLayout({
    required this.id,
    required this.name,
    required this.pageCount,
    required this.linesPerPage,
    required this.fontPack,
    required this.version,
    this.isBuiltIn = true,
  });

  final String id;

  /// Verideki ad (Türkçe). Bilinen düzenlerin arayüzdeki adı dil dosyasından
  /// gelir; bilinmeyen (yeni paket) düzende bu ad gösterilir.
  final String name;
  final int pageCount;
  final int linesPerPage;

  /// Sayfanın çizildiği font paketi (şimdilik yalnız `digital_khatt`).
  final String fontPack;
  final int version;

  /// Uygulamayla mı geliyor (silinemez), yoksa indirilen paket mi.
  final bool isBuiltIn;

  @override
  bool operator ==(Object other) =>
      other is MushafLayout && other.id == id && other.version == version;

  @override
  int get hashCode => Object.hash(id, version);

  @override
  String toString() => 'MushafLayout($id v$version)';
}

/// Uygulamayla gelen varsayılan düzen: Medine 1421H (Faz 0 S3, TK-06).
const kDefaultLayout = MushafLayout(
  id: 'madani_1421',
  name: 'Medine Mushafı (KFGQPC, 1421H baskısı)',
  pageCount: 604,
  linesPerPage: 15,
  fontPack: 'digital_khatt',
  version: 1,
);
