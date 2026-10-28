import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'content_database.dart';

/// Paketteki içerik veritabanını cihaza kopyalayıp salt okunur açar (M16-01).
///
/// Dosya adı içerik sürümünü taşır; sürüm değişince yeni dosya kopyalanır ve
/// eskisi silinir. İnternet gerekmez.
Future<ContentDatabase> openContentDatabase() async {
  final dir = Directory(
    p.join((await getApplicationSupportDirectory()).path, 'content'),
  );
  await dir.create(recursive: true);
  final file = File(p.join(dir.path, 'content_v$kContentVersion.sqlite'));

  if (!file.existsSync()) {
    final data = await rootBundle.load(kContentAssetPath);
    final temp = File('${file.path}.tmp');
    await temp.writeAsBytes(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      flush: true,
    );
    await temp.rename(file.path);
    await for (final old in dir.list()) {
      if (old.path != file.path) await old.delete();
    }
  }

  return ContentDatabase(
    NativeDatabase.createInBackground(
      file,
      setup: (db) => db.execute('PRAGMA query_only = ON'),
    ),
  );
}
