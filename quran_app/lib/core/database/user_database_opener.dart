import 'dart:io';

import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import 'user_database.dart';

/// Saklanan en fazla yedek sayısı (NF-G03).
const kMaxUserDatabaseBackups = 3;

/// Kullanıcı veritabanını açar. Mevcut dosyanın şema sürümü kodun beklediği
/// sürümden eskiyse (yani bir migration çalışacaksa) önce yedek alınır.
Future<UserDatabase> openUserDatabase() async {
  final dir = Directory(
    p.join((await getApplicationSupportDirectory()).path, 'user'),
  );
  await dir.create(recursive: true);
  final file = File(p.join(dir.path, 'user.sqlite'));

  await backupBeforeMigration(
    database: file,
    backups: Directory(p.join(dir.path, 'backups')),
    targetVersion: UserDatabase.currentSchemaVersion,
  );

  return UserDatabase(NativeDatabase.createInBackground(file));
}

/// [database] dosyasının şema sürümü [targetVersion]'dan küçükse dosyayı
/// [backups] klasörüne kopyalar ve en yeni [kMaxUserDatabaseBackups] yedeği
/// tutar. Yedek alındıysa yedeğin dosyasını döndürür.
///
/// Yedek adı: `user_v{eski sürüm}_{UTC zaman}.sqlite`.
Future<File?> backupBeforeMigration({
  required File database,
  required Directory backups,
  required int targetVersion,
  DateTime? now,
}) async {
  if (!database.existsSync()) return null;
  final version = _schemaVersionOf(database);
  // 0: henüz şema oluşturulmamış (boş dosya); yedeklenecek veri yok.
  if (version == 0 || version >= targetVersion) return null;

  await backups.create(recursive: true);
  final stamp = (now ?? DateTime.now()).toUtc().toIso8601String().replaceAll(
    RegExp('[:.]'),
    '-',
  );
  final backup = await database.copy(
    p.join(backups.path, 'user_v${version}_$stamp.sqlite'),
  );

  // Ad, yedeğin alındığı UTC zamanı taşır: ada göre sıralama zamana göre
  // sıralamadır (dosya değiştirilme zamanlarından bağımsız).
  final existing =
      backups
          .listSync()
          .whereType<File>()
          .where((f) => p.basename(f.path).startsWith('user_v'))
          .toList()
        ..sort((a, b) => _stampOf(b).compareTo(_stampOf(a)));
  for (final old in existing.skip(kMaxUserDatabaseBackups)) {
    await old.delete();
  }
  return backup;
}

/// `user_v{sürüm}_{zaman}.sqlite` → `{zaman}`.
String _stampOf(File backup) {
  final name = p.basenameWithoutExtension(backup.path);
  return name.substring(name.indexOf('_', 'user_v'.length) + 1);
}

int _schemaVersionOf(File file) {
  final db = sqlite.sqlite3.open(file.path, mode: sqlite.OpenMode.readOnly);
  try {
    return db.userVersion;
  } finally {
    db.close();
  }
}
