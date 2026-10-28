import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_language.dart';
import '../../user_data/application/user_data_providers.dart';

/// Dil ve rakam seçimi (M13-01, NF-Y03).
class LocaleSettings {
  const LocaleSettings({
    this.language = AppLanguage.system,
    this.numerals = NumeralSystem.auto,
  });

  final AppLanguage language;
  final NumeralSystem numerals;

  LocaleSettings copyWith({AppLanguage? language, NumeralSystem? numerals}) =>
      LocaleSettings(
        language: language ?? this.language,
        numerals: numerals ?? this.numerals,
      );
}

/// Dil ayarları; kullanıcı veritabanında kalıcıdır (M13-02).
class LocaleSettingsNotifier extends Notifier<LocaleSettings> {
  static const languageKey = 'app.language';
  static const numeralsKey = 'app.numerals';

  @override
  LocaleSettings build() {
    final saved = ref.read(userDataSnapshotProvider).settings;
    const defaults = LocaleSettings();
    return LocaleSettings(
      language: enumSetting(
        AppLanguage.values,
        saved[languageKey],
        defaults.language,
      ),
      numerals: enumSetting(
        NumeralSystem.values,
        saved[numeralsKey],
        defaults.numerals,
      ),
    );
  }

  void setLanguage(AppLanguage language) {
    state = state.copyWith(language: language);
    persistSetting(ref, languageKey, language.name);
  }

  void setNumerals(NumeralSystem numerals) {
    state = state.copyWith(numerals: numerals);
    persistSetting(ref, numeralsKey, numerals.name);
  }
}

final localeSettingsProvider =
    NotifierProvider<LocaleSettingsNotifier, LocaleSettings>(
      LocaleSettingsNotifier.new,
    );
