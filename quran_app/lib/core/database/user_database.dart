import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'user_database.steps.dart';

part 'user_database.g.dart';

const _uuid = Uuid();

DateTime _nowUtc() => DateTime.now().toUtc();

/// Senkrona hazır kayıt şablonu (MK-02, MK-03).
///
/// Kullanıcı verisi taşıyan her tablo bunu kullanır: UUID kimlik (cihazlar
/// arası birleştirmede çakışmaz), UTC zaman damgaları ve yumuşak silme
/// (`deletedAt`; kayıt fiziksel olarak silinmez, senkronda silme yayılır).
mixin SyncedRecord on Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  DateTimeColumn get createdAt => dateTime().clientDefault(_nowUtc)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(_nowUtc)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cihazdaki kullanıcı (MK-09). Hesapsız kullanımda tek kayıttır; `id`
/// yerel kullanıcı kimliğidir (`localUserId`). Hesap açılınca `accountId`
/// dolar ve veriler hesaba taşınır (M1-05).
@DataClassName('UserProfileRow')
class UserProfiles extends Table with SyncedRecord {
  TextColumn get accountId => text().nullable()();
}

/// Ayarlar: anahtar → JSON değer (M13-02, T-05). Cihazlar arası senkronlanır
/// (M1-06); çakışmada son yazılan kazanır.
@DataClassName('SettingRow')
class Settings extends Table with SyncedRecord {
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
}

/// Okuma konumları (v2): son okunan yer gibi adlandırılmış konumlar.
///
/// Konum düzenden bağımsızdır (M2-15): yalnızca sure:ayet(:kelime) saklanır,
/// sayfa numarası **asla** saklanmaz.
@DataClassName('ReadingPositionRow')
class ReadingPositions extends Table with SyncedRecord {
  /// Konumun adı (ör. `lastRead`); her ad için tek kayıt.
  TextColumn get kind => text().unique()();
  IntColumn get surah => integer()();
  IntColumn get ayah => integer()();

  /// Kelime sırası (esas KFGQPC bölünmesi); ayet düzeyinde konumda boş.
  IntColumn get word => integer().nullable()();
}

/// Kullanıcı veritabanı (MK-01: tek doğru kaynak; MK-05: içerik
/// veritabanından ayrı). Şema her değiştiğinde [schemaVersion] artırılır,
/// `dart run drift_dev make-migrations` çalıştırılır ve migration yazılır
/// (MK-04); migration testleri `test/drift/` altındadır (T-04).
@DriftDatabase(tables: [UserProfiles, Settings, ReadingPositions])
class UserDatabase extends _$UserDatabase {
  UserDatabase(super.executor);

  /// Kodun beklediği şema sürümü; yedekleme kararı da buna göre verilir.
  static const currentSchemaVersion = 2;

  @override
  int get schemaVersion => currentSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: stepByStep(
      // v2: son okunan konum tablosu.
      from1To2: (m, schema) => m.createTable(schema.readingPositions),
    ),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
