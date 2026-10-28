// İçerik veritabanının sağlama değerlerini referans dosyasına yazar.
//
// YALNIZCA kaynak veri bilerek güncellendiğinde ve değişiklik incelenip
// doğrulandıktan sonra çalıştırılır. Bu dosyanın git'teki farkı, hangi
// surelerin metninin değiştiğini gösterir; commit'ten önce gözden geçirilmeli.
//
// Çalıştırma (quran_app klasöründe):
//   dart run tool/content/build_content_db.dart
//   dart run tool/content/update_checksums.dart
import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:quran_app/features/quran/data/content_database.dart';

import 'content_checksums.dart';

Future<void> main() async {
  final db = ContentDatabase(NativeDatabase(File(kContentAssetPath)));
  try {
    final checksums = await computeChecksums(db);
    final file = File(checksumsPath);
    await file.parent.create(recursive: true);
    await file.writeAsString(
      '${const JsonEncoder.withIndent('  ').convert(checksums)}\n',
    );
    stdout.writeln('Yazıldı: $checksumsPath');
  } finally {
    await db.close();
  }
}
