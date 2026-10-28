import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/flavor.dart';
import 'core/config/flavor_provider.dart';
import 'core/crash/crash_reporter.dart';

/// Tüm giriş noktalarının ortak başlangıcı.
void bootstrap(Flavor flavor) {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer(
    overrides: [flavorProvider.overrideWithValue(flavor)],
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
