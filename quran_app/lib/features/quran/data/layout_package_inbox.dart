import 'dart:io';

import 'package:path/path.dart' as p;

import '../../../core/logging/app_logger.dart';
import '../../../core/result/result.dart';
import '../../user_data/domain/user_data_repositories.dart';
import 'layout_package_store.dart';

/// Yalnızca `dev`: [inbox] klasörüne bırakılan düzen paketlerini kurar ve
/// klasörden siler. İndirme altyapısı (F1-11, TK-14) gelene kadar paketleri
/// emülatörde/cihazda denemek içindir; `prod`'da çağrılmaz.
///
/// Android'de klasör `/sdcard/Android/data/<paket>/files/packages_inbox`;
/// `adb push` ile dosya bırakılır (README "Düzen paketleri").
Future<void> installLayoutPackagesFromInbox({
  required Directory inbox,
  required LayoutPackageStore store,
  required InstalledPackageRepository packages,
  required AppLogger logger,
}) async {
  if (!inbox.existsSync()) return;
  await for (final entry in inbox.list()) {
    if (entry is! File || p.extension(entry.path) != '.sqlite') continue;
    switch (await store.install(entry)) {
      case Ok(:final value):
        await packages.save(value);
        logger.info(
          'Düzen paketi kuruldu: ${value.packageId} v${value.version}',
        );
      case Err(:final failure):
        logger.warning(
          'Düzen paketi kurulamadı: ${entry.path}',
          error: failure,
        );
    }
    await entry.delete();
  }
}
