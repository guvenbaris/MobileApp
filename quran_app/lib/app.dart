import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/flavor_provider.dart';
import 'core/l10n/l10n.dart';
import 'core/routing/app_router.dart';
import 'features/settings/application/locale_settings.dart';

class QuranApp extends ConsumerWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeSettings = ref.watch(localeSettingsProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: ref.watch(flavorProvider).isDev,
      routerConfig: ref.watch(appRouterProvider),
      onGenerateTitle: (context) => context.l10n.appTitle,
      // Dil seçimi (M13-01). Arapçada yön, Material'ın yerelleştirmesiyle
      // kendiliğinden sağdan sola olur.
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: kSupportedLocales,
      // Seçilen dil doğrudan verilir; "Cihaz dili"nde null kalır ve cihaz
      // dilleri aşağıdaki geri çağırımla çözülür (cihaz dili değişince de).
      locale: localeSettings.language.languageCode == null
          ? null
          : resolveAppLocale(localeSettings.language, null),
      localeListResolutionCallback: (deviceLocales, _) =>
          resolveAppLocale(AppLanguage.system, deviceLocales),
      builder: (context, child) => NumeralScope(
        numerals: localeSettings.numerals,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
