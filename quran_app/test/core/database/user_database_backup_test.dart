import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:quran_app/core/database/user_database_opener.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

/// Verilen şema sürümünde, içinde bir kayıt olan bir SQLite dosyası yazar.
File _databaseAt(Directory dir, int version) {
  final file = File(p.join(dir.path, 'user.sqlite'));
  final db = sqlite.sqlite3.open(file.path)
    ..execute('CREATE TABLE IF NOT EXISTS t (v TEXT)')
    ..execute("INSERT INTO t VALUES ('kayıt')")
    ..userVersion = version;
  db.close();
  return file;
}

void main() {
  late Directory dir;
  late Directory backups;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('user_db_backup_');
    backups = Directory(p.join(dir.path, 'backups'));
    addTearDown(() => dir.deleteSync(recursive: true));
  });

  test('eski sürümdeki veritabanı migration öncesi yedeklenir', () async {
    final db = _databaseAt(dir, 1);
    final backup = await backupBeforeMigration(
      database: db,
      backups: backups,
      targetVersion: 2,
      now: DateTime.utc(2026, 10, 28, 12),
    );
    expect(backup, isNotNull);
    expect(p.basename(backup!.path), startsWith('user_v1_2026-10-28T12'));
    expect(backup.readAsBytesSync(), db.readAsBytesSync());
  });

  test('güncel sürümde veya dosya yokken yedek alınmaz', () async {
    expect(
      await backupBeforeMigration(
        database: File(p.join(dir.path, 'yok.sqlite')),
        backups: backups,
        targetVersion: 2,
      ),
      isNull,
    );
    final db = _databaseAt(dir, 2);
    expect(
      await backupBeforeMigration(
        database: db,
        backups: backups,
        targetVersion: 2,
      ),
      isNull,
    );
    expect(backups.existsSync(), isFalse);
  });

  test('en fazla 3 yedek tutulur, en yeniler kalır', () async {
    final db = _databaseAt(dir, 1);
    final created = <String>[];
    for (var i = 0; i < 5; i++) {
      final backup = await backupBeforeMigration(
        database: db,
        backups: backups,
        targetVersion: 2,
        now: DateTime.utc(2026, 10, 28, 12, i),
      );
      created.add(p.basename(backup!.path));
    }
    final remaining = backups.listSync().map((f) => p.basename(f.path)).toList()
      ..sort();
    expect(remaining, hasLength(kMaxUserDatabaseBackups));
    expect(remaining, created.sublist(2)..sort());
  });
}
