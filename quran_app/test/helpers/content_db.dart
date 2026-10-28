import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/quran/data/content_database.dart';

/// Üretilmiş içerik veritabanını salt okunur açar; test sonunda kapatır.
///
/// Dosya yoksa önce `dart run tool/content/build_content_db.dart` çalıştırılmalı.
ContentDatabase openTestContentDatabase() {
  final file = File(kContentAssetPath);
  if (!file.existsSync()) {
    fail(
      '$kContentAssetPath bulunamadı. Önce çalıştırın: '
      'dart run tool/content/build_content_db.dart',
    );
  }
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final db = ContentDatabase(
    NativeDatabase(file, setup: (db) => db.execute('PRAGMA query_only = ON')),
  );
  addTearDown(db.close);
  return db;
}
