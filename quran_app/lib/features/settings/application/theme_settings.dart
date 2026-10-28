import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../user_data/application/user_data_providers.dart';

/// Tema seçimi (M2-08); kullanıcı veritabanında kalıcıdır (M13-02). Uygulama
/// ve mushaf sayfası aynı temayı kullanır.
class ThemeSettingsNotifier extends Notifier<ThemePreference> {
  static const key = 'app.theme';

  @override
  ThemePreference build() => enumSetting(
    ThemePreference.values,
    ref.read(userDataSnapshotProvider).settings[key],
    ThemePreference.system,
  );

  void set(ThemePreference preference) {
    state = preference;
    persistSetting(ref, key, preference.name);
  }

  /// Okuma ekranındaki tema düğmesi: şu an görünen temadan sonrakine geçer
  /// (açık → sepya → koyu → açık).
  void cycleFrom(AppThemeId current) {
    final next =
        AppThemeId.values[(current.index + 1) % AppThemeId.values.length];
    set(ThemePreference.values.byName(next.name));
  }
}

final themeSettingsProvider =
    NotifierProvider<ThemeSettingsNotifier, ThemePreference>(
      ThemeSettingsNotifier.new,
    );
