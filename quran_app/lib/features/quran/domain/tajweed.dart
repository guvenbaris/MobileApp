/// Renkli tecvid (M2-06). Kurallar cpfair/quran-tajweed veri setinin
/// sınıflarıdır (CC BY 4.0, VERI_KAYNAKLARI §8); adları o veri setindeki
/// kimliklerin camelCase karşılığıdır.
///
/// **Sıra veritabanında saklanır** (`tajweed_spans.rule`): yeni kural sona
/// eklenir; sıra değişirse içerik sürümü artırılıp veritabanı yeniden üretilir.
enum TajweedRule {
  hamzatWasl('hamzat_wasl', TajweedGroup.silent),
  lamShamsiyyah('lam_shamsiyyah', TajweedGroup.silent),
  silent('silent', TajweedGroup.silent),
  madd2('madd_2', TajweedGroup.maddNatural),
  madd246('madd_246', TajweedGroup.maddPermissible),
  maddMunfasil('madd_munfasil', TajweedGroup.maddPermissible),
  maddMuttasil('madd_muttasil', TajweedGroup.maddObligatory),
  madd6('madd_6', TajweedGroup.maddObligatory),
  ghunnah('ghunnah', TajweedGroup.ghunnah),
  ikhfa('ikhfa', TajweedGroup.ghunnah),
  ikhfaShafawi('ikhfa_shafawi', TajweedGroup.ghunnah),
  idghaamGhunnah('idghaam_ghunnah', TajweedGroup.ghunnah),
  idghaamShafawi('idghaam_shafawi', TajweedGroup.ghunnah),
  iqlab('iqlab', TajweedGroup.ghunnah),
  idghaamNoGhunnah('idghaam_no_ghunnah', TajweedGroup.idghaam),
  idghaamMutajanisayn('idghaam_mutajanisayn', TajweedGroup.idghaam),
  idghaamMutaqaribayn('idghaam_mutaqaribayn', TajweedGroup.idghaam),
  qalqalah('qalqalah', TajweedGroup.qalqalah);

  const TajweedRule(this.sourceId, this.group);

  /// Kaynak veri setindeki kimlik.
  final String sourceId;
  final TajweedGroup group;

  static TajweedRule? fromSourceId(String id) =>
      values.where((r) => r.sourceId == id).firstOrNull;

  /// Aynı harfe iki kural düştüğünde öncelik (büyük olan kazanır): okunuşu
  /// en çok etkileyen kural görünür. Med uzunluğu, genizden okuma ve
  /// kalkaleden önce gelir; "okunmaz" en son.
  int get priority => switch (this) {
    madd6 => 18,
    maddMuttasil => 17,
    maddMunfasil => 16,
    madd246 => 15,
    madd2 => 14,
    iqlab => 13,
    ikhfaShafawi => 12,
    ikhfa => 11,
    idghaamShafawi => 10,
    idghaamMutajanisayn => 9,
    idghaamMutaqaribayn => 8,
    idghaamGhunnah => 7,
    idghaamNoGhunnah => 6,
    ghunnah => 5,
    qalqalah => 4,
    lamShamsiyyah => 3,
    hamzatWasl => 2,
    silent => 1,
  };
}

/// Renk grupları: renk karmaşasını azaltmak için 18 kural 7 renkte
/// toplanır; kuralın adı dokununca ayrıca gösterilir.
enum TajweedGroup {
  /// Okunmayan harfler: hemze-i vasl, lâm-ı şemsiyye, okunmaz harf.
  silent,

  /// Medd-i tabîî (2 hareke).
  maddNatural,

  /// Caiz medler: munfasıl, ârız ve lîn.
  maddPermissible,

  /// Vacip ve lâzım medler: muttasıl, lâzım.
  maddObligatory,

  /// Genizden okuma: gunne, ihfâ, iklâb, gunneli idğam.
  ghunnah,

  /// Gunnesiz idğamlar.
  idghaam,

  /// Kalkale.
  qalqalah,
}

/// Glif metninde bir kuralın aralığı: [start, end) UTF-16 konumları.
class TajweedSpan {
  const TajweedSpan(this.start, this.end, this.rule);

  final int start;
  final int end;
  final TajweedRule rule;

  @override
  bool operator ==(Object other) =>
      other is TajweedSpan &&
      other.start == start &&
      other.end == end &&
      other.rule == rule;

  @override
  int get hashCode => Object.hash(start, end, rule);

  @override
  String toString() => '$start-$end:${rule.name}';
}
