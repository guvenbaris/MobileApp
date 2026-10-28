import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/flavor.dart';
import 'core/config/flavor_provider.dart';
import 'core/crash/crash_reporter.dart';
import 'core/database/user_database_opener.dart';
import 'core/diagnostics/perf_probe.dart';
import 'features/quran/application/quran_providers.dart';
import 'features/quran/data/content_database_opener.dart';
import 'features/quran/data/content_licenses.dart';
import 'features/user_data/application/user_data_providers.dart';

/// Tüm giriş noktalarının ortak başlangıcı.
Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (flavor.isDev) PerfProbe.enable();

  final contentDb = await openContentDatabase();
  registerContentLicenses(contentDb);
  // Gerekirse migration öncesi yedek alınarak açılır (NF-G03).
  final userDb = await openUserDatabase();
  final userData = await UserDataSnapshot.load(userDb);
  final container = ProviderContainer(
    overrides: [
      flavorProvider.overrideWithValue(flavor),
      contentDatabaseProvider.overrideWithValue(contentDb),
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
