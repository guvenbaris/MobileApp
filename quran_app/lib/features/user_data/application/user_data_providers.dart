import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/user_database.dart';
import '../../quran/domain/quran_models.dart';
import '../data/drift_user_data_repositories.dart';
import '../domain/user_data_repositories.dart';

/// Açılmış kullanıcı veritabanı. Değeri `bootstrap` içinde override edilir.
final userDatabaseProvider = Provider<UserDatabase>(
  (ref) => throw UnimplementedError(
    'userDatabaseProvider bootstrap içinde override edilmeli',
  ),
);

final userProfileRepositoryProvider = Provider<UserProfileRepository>(
  (ref) => DriftUserProfileRepository(ref.watch(userDatabaseProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => DriftSettingsRepository(ref.watch(userDatabaseProvider)),
);

final readingPositionRepositoryProvider = Provider<ReadingPositionRepository>(
  (ref) => DriftReadingPositionRepository(ref.watch(userDatabaseProvider)),
);

/// Uygulama açılırken okunan kullanıcı verisi. Ayarlar ve son okunan yer
/// ilk karede hazır olsun diye `bootstrap` içinde bir kez yüklenir.
class UserDataSnapshot {
  const UserDataSnapshot({
    this.localUserId,
    this.settings = const {},
    this.lastRead,
  });

  final String? localUserId;
  final Map<String, Object?> settings;
  final AyahRef? lastRead;

  /// Yerel kullanıcıyı oluşturur (ilk açılış) ve kayıtlı veriyi okur.
  static Future<UserDataSnapshot> load(UserDatabase db) async {
    return UserDataSnapshot(
      localUserId: await DriftUserProfileRepository(db).ensureLocalUserId(),
      settings: await DriftSettingsRepository(db).loadAll(),
      lastRead: await DriftReadingPositionRepository(db)
          .load(ReadingPositionKind.lastRead),
    );
  }
}

/// Varsayılanı boştur (testler ve kullanıcı veritabanı olmadan çalışma).
final userDataSnapshotProvider = Provider<UserDataSnapshot>(
  (ref) => const UserDataSnapshot(),
);
