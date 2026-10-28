import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_list_item.dart';
import '../application/locale_settings.dart';
import '../application/theme_settings.dart';

/// Tema, dil ve rakam seçimi. Seçimler anında uygulanır ve kalıcıdır.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(localeSettingsProvider);
    final notifier = ref.read(localeSettingsProvider.notifier);
    final theme = ref.watch(themeSettingsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          AppSectionHeader(l10n.settingsTheme),
          RadioGroup<ThemePreference>(
            groupValue: theme,
            onChanged: (v) => v == null
                ? null
                : ref.read(themeSettingsProvider.notifier).set(v),
            child: Column(
              children: [
                for (final preference in ThemePreference.values)
                  RadioListTile<ThemePreference>(
                    key: Key('settings.theme.${preference.name}'),
                    value: preference,
                    title: Text(switch (preference) {
                      ThemePreference.system => l10n.themeSystem,
                      ThemePreference.light => l10n.themeLight,
                      ThemePreference.sepia => l10n.themeSepia,
                      ThemePreference.dark => l10n.themeDark,
                    }),
                  ),
              ],
            ),
          ),
          const Divider(),
          AppSectionHeader(l10n.settingsLanguage),
          RadioGroup<AppLanguage>(
            groupValue: settings.language,
            onChanged: (v) => v == null ? null : notifier.setLanguage(v),
            child: Column(
              children: [
                for (final language in AppLanguage.values)
                  RadioListTile<AppLanguage>(
                    key: Key('settings.language.${language.name}'),
                    value: language,
                    title: Text(switch (language) {
                      AppLanguage.system => l10n.settingsLanguageSystem,
                      AppLanguage.tr => l10n.languageTurkish,
                      AppLanguage.ar => l10n.languageArabic,
                      AppLanguage.en => l10n.languageEnglish,
                    }),
                  ),
              ],
            ),
          ),
          const Divider(),
          AppSectionHeader(l10n.settingsNumerals),
          RadioGroup<NumeralSystem>(
            groupValue: settings.numerals,
            onChanged: (v) => v == null ? null : notifier.setNumerals(v),
            child: Column(
              children: [
                for (final numerals in NumeralSystem.values)
                  RadioListTile<NumeralSystem>(
                    key: Key('settings.numerals.${numerals.name}'),
                    value: numerals,
                    title: Text(switch (numerals) {
                      NumeralSystem.auto => l10n.settingsNumeralsAuto,
                      NumeralSystem.western => l10n.settingsNumeralsWestern,
                      NumeralSystem.arabic => l10n.settingsNumeralsArabic,
                    }),
                  ),
              ],
            ),
          ),
          const Divider(),
          AppSectionHeader(l10n.settingsAbout),
          // Font, Kur'an metni (Tanzil notu) ve paket lisansları
          // (VERI_KAYNAKLARI.md). Ayrıntılı "Hakkında" ekranı İÇ-01 ile gelir.
          AppListItem(
            key: const Key('settings.licenses'),
            leading: const Icon(Icons.description_outlined),
            title: l10n.settingsLicenses,
            subtitle: l10n.settingsLicensesSubtitle,
            onTap: () => showLicensePage(
              context: context,
              applicationName: l10n.appTitle,
              applicationLegalese: l10n.aboutLegalese,
            ),
          ),
        ],
      ),
    );
  }
}
