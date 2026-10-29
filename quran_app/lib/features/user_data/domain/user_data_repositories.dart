import '../../quran/domain/quran_models.dart';

/// Cihazdaki kullanıcı (MK-09).
abstract interface class UserProfileRepository {
  /// Yerel kullanıcı kimliğini döndürür; ilk açılışta oluşturur.
  Future<String> ensureLocalUserId();
}

/// Ayarlar (M13-02, T-05). Değerler JSON olarak saklanır.
abstract interface class SettingsRepository {
  /// Silinmemiş tüm ayarlar: anahtar → JSON çözülmüş değer.
  Future<Map<String, Object?>> loadAll();

  /// Ayarı yazar (yoksa oluşturur); `updatedAt` güncellenir.
  Future<void> save(String key, Object? value);
}

/// Adlandırılmış okuma konumları (ör. son okunan). Konum düzenden
/// bağımsızdır: sure:ayet(:kelime) (M2-15).
abstract interface class ReadingPositionRepository {
  Future<AyahRef?> load(String kind);

  Future<void> save(String kind, AyahRef position, {int? word});
}

/// Konum adları.
abstract final class ReadingPositionKind {
  /// Son okunan yer (M6).
  static const lastRead = 'lastRead';
}

/// Kurulu içerik paketi kaydı (TK-13).
class InstalledPackage {
  const InstalledPackage({
    required this.packageId,
    required this.kind,
    required this.version,
    required this.fileName,
    required this.sizeBytes,
  });

  final String packageId;
  final String kind;
  final int version;
  final String fileName;
  final int sizeBytes;
}

/// Paket türleri.
abstract final class PackageKind {
  /// Mushaf düzeni (M2-14).
  static const layout = 'layout';
}

/// Kurulu paketlerin listesi (TK-13). Paket dosyaları uygulamanın paket
/// klasöründedir; burada yalnızca kayıtları tutulur.
abstract interface class InstalledPackageRepository {
  /// Silinmemiş kayıtlar; [kind] verilirse yalnız o türden.
  Future<List<InstalledPackage>> list({String? kind});

  /// Kaydı yazar; aynı kimlikli paket varsa günceller (yeni sürüm).
  Future<void> save(InstalledPackage package);

  /// Kaydı yumuşak siler (MK-03).
  Future<void> remove(String packageId);
}
