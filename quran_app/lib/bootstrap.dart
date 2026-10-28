import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/flavor.dart';
import 'core/config/flavor_provider.dart';
import 'core/crash/crash_reporter.dart';
import 'features/quran/application/quran_providers.dart';
import 'features/quran/data/content_database_opener.dart';

/// Tüm giriş noktalarının ortak başlangıcı.
Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();

  final contentDb = await openContentDatabase();
  final container = ProviderContainer(
    overrides: [
      flavorProvider.overrideWithValue(flavor),
      contentDatabaseProvider.overrideWithValue(contentDb),
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
