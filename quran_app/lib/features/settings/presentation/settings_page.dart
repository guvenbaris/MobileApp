import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../application/locale_settings.dart';

/// Tema seçimi (F0-08) buraya eklenir.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(localeSettingsProvider);
    final notifier = ref.read(localeSettingsProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          _SectionHeader(l10n.settingsLanguage),
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
          _SectionHeader(l10n.settingsNumerals),
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
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 4),
      child: Text(
        text,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
