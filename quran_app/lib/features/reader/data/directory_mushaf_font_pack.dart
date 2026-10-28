import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../domain/mushaf_font_pack.dart';

/// Paketi cihazdaki bir klasörden okur. Klasör: uygulama dosyaları altında
/// `qcf_v2/p{sayfa}.ttf`. İndirme akışı bu klasörü dolduracak (F0-05).
class DirectoryMushafFontPack implements MushafFontPack {
  DirectoryMushafFontPack(this._directory);

  static const pageCount = 604;

  final Future<Directory> _directory;
  final Map<int, Future<String>> _loaded = {};

  @override
  Future<bool> isInstalled() async {
    final dir = await _directory;
    if (!dir.existsSync()) return false;
    for (var page = 1; page <= pageCount; page++) {
      if (!File(p.join(dir.path, 'p$page.ttf')).existsSync()) return false;
    }
    return true;
  }

  @override
  Future<String> loadPageFont(int page) => _loaded.putIfAbsent(page, () async {
    final family = 'qcf_v2_p$page';
    final file = File(p.join((await _directory).path, 'p$page.ttf'));
    final bytes = await file.readAsBytes();
    final loader = FontLoader(family)
      ..addFont(Future.value(ByteData.sublistView(bytes)));
    await loader.load();
    return family;
  });
}

Future<Directory> fontPackDirectory() async {
  // Android'de uygulamaya özel harici klasör (geliştirmede adb ile
  // doldurulabilir); diğer platformlarda uygulama destek klasörü.
  final base = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationSupportDirectory();
  return Directory(p.join(base!.path, 'qcf_v2'));
}
