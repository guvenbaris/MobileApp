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
