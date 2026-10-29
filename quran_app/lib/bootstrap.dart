import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'core/config/flavor.dart';
import 'core/config/flavor_provider.dart';
import 'core/crash/crash_reporter.dart';
import 'core/database/user_database_opener.dart';
import 'core/diagnostics/perf_probe.dart';
import 'core/logging/app_logger.dart';
import 'features/quran/application/layout_providers.dart';
import 'features/quran/application/quran_providers.dart';
import 'features/quran/data/content_database_opener.dart';
import 'features/quran/data/content_licenses.dart';
import 'features/quran/data/layout_package_inbox.dart';
import 'features/quran/data/layout_package_store.dart';
import 'features/user_data/application/user_data_providers.dart';
import 'features/user_data/data/drift_user_data_repositories.dart';

/// Tüm giriş noktalarının ortak başlangıcı.
Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (flavor.isDev) PerfProbe.enable();

  final contentDb = await openContentDatabase();
  registerContentLicenses();
  // Gerekirse migration öncesi yedek alınarak açılır (NF-G03).
  final userDb = await openUserDatabase();
  final userData = await UserDataSnapshot.load(userDb);

  // İndirilebilir düzen paketleri (TK-13, M2-14).
  // Sağlayıcılar henüz kurulmadı; açılış loglaması için doğrudan.
  const logger = ConsoleAppLogger();
  final packages = DriftInstalledPackageRepository(userDb);
  final layoutStore = LayoutPackageStore(
    contentDb,
    directory: Directory(
      p.join(
        (await getApplicationSupportDirectory()).path,
        'packages',
        'layout',
      ),
    ),
  );
  if (flavor.isDev && Platform.isAndroid) {
    final external = await getExternalStorageDirectory();
    if (external != null) {
      await installLayoutPackagesFromInbox(
        inbox: Directory(p.join(external.path, 'packages_inbox')),
        store: layoutStore,
        packages: packages,
        logger: logger,
      );
    }
  }
  final layoutCatalog = await loadLayoutCatalog(
    content: contentDb,
    store: layoutStore,
    packages: packages,
    logger: logger,
  );

  final container = ProviderContainer(
    overrides: [
      flavorProvider.overrideWithValue(flavor),
      contentDatabaseProvider.overrideWithValue(contentDb),
      layoutPackageStoreProvider.overrideWithValue(layoutStore),
      initialLayoutCatalogProvider.overrideWithValue(layoutCatalog),
      userDatabaseProvider.overrideWithValue(userDb),
      userDataSnapshotProvider.overrideWithValue(userData),
    ],
  );
  final crashReporter = container.read(crashReporterProvider);

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    crashReporter.recordError(details.exception, details.stack);
  };
  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    crashReporter.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(
    UncontrolledProviderScope(container: container, child: const QuranApp()),
  );
}
