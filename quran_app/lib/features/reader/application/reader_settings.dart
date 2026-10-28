import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/app_logger.dart';
import '../../user_data/application/user_data_providers.dart';
import '../../user_data/domain/user_data_repositories.dart';

/// Mushaf sayfa teması (M2-08). Koyu temada metin alanı da koyudur.
enum MushafTheme { light, sepia, dark }

/// Okuma görünümü (M2-01): mushaf sayfası veya ayet ayet liste.
enum ReaderViewMode { page, ayah }

class ReaderSettings {
  const ReaderSettings({
    this.theme = MushafTheme.sepia,
    this.viewMode = ReaderViewMode.page,
    this.textScale = 1.0,
  });

  /// Yazı boyutu çarpanının sınırları (M2-07: en az %50–%250).
  static const minTextScale = 0.5;
  static const maxTextScale = 2.5;

  final MushafTheme theme;
  final ReaderViewMode viewMode;

  /// Ayet görünümünde yazı boyutu çarpanı.
  final double textScale;

  ReaderSettings copyWith({
    MushafTheme? theme,
    ReaderViewMode? viewMode,
    double? textScale,
  }) => ReaderSettings(
    theme: theme ?? this.theme,
    viewMode: viewMode ?? this.viewMode,
    textScale: textScale ?? this.textScale,
  );
}

/// Okuma ayarları; kullanıcı veritabanında kalıcıdır (M13-02, T-05).
class ReaderSettingsNotifier extends Notifier<ReaderSettings> {
  static const _themeKey = 'reader.theme';
  static const _viewModeKey = 'reader.viewMode';
  static const _textScaleKey = 'reader.textScale';

  @override
  ReaderSettings build() {
    final saved = ref.read(userDataSnapshotProvider).settings;
    const defaults = ReaderSettings();
    return ReaderSettings(
      theme: _enumOr(MushafTheme.values, saved[_themeKey], defaults.theme),
      viewMode: _enumOr(
        ReaderViewMode.values,
        saved[_viewModeKey],
        defaults.viewMode,
      ),
      textScale: switch (saved[_textScaleKey]) {
        final num v => v.toDouble().clamp(
          ReaderSettings.minTextScale,
          ReaderSettings.maxTextScale,
        ),
        _ => defaults.textScale,
      },
    );
  }

  void setTheme(MushafTheme theme) {
    state = state.copyWith(theme: theme);
    _persist(_themeKey, theme.name);
  }

  void setViewMode(ReaderViewMode mode) {
    state = state.copyWith(viewMode: mode);
    _persist(_viewModeKey, mode.name);
  }

  void setTextScale(double scale) {
    state = state.copyWith(
      textScale: scale.clamp(
        ReaderSettings.minTextScale,
        ReaderSettings.maxTextScale,
      ),
    );
    _persist(_textScaleKey, state.textScale);
  }

  /// Kayıt hatası okumayı engellemez; loglanır. Kullanıcı veritabanı yoksa
  /// (ör. testler) kayıt atlanır.
  void _persist(String key, Object value) {
    final SettingsRepository repository;
    final AppLogger logger;
    try {
      repository = ref.read(settingsRepositoryProvider);
      logger = ref.read(appLoggerProvider);
    } on Object {
      return;
    }
    repository.save(key, value).catchError((Object e, StackTrace st) {
      logger.error('Ayar kaydedilemedi: $key', error: e, stackTrace: st);
    }).ignore();
  }

  static T _enumOr<T extends Enum>(List<T> values, Object? name, T fallback) =>
      values.where((v) => v.name == name).firstOrNull ?? fallback;
}

final readerSettingsProvider =
    NotifierProvider<ReaderSettingsNotifier, ReaderSettings>(
      ReaderSettingsNotifier.new,
    );
