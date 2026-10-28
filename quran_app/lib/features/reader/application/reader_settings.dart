import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../user_data/application/user_data_providers.dart';

/// Okuma görünümü (M2-01): mushaf sayfası veya ayet ayet liste.
enum ReaderViewMode { page, ayah }

class ReaderSettings {
  const ReaderSettings({
    this.viewMode = ReaderViewMode.page,
    this.textScale = 1.0,
  });

  /// Yazı boyutu çarpanının sınırları (M2-07: en az %50–%250).
  static const minTextScale = 0.5;
  static const maxTextScale = 2.5;

  final ReaderViewMode viewMode;

  /// Ayet görünümünde yazı boyutu çarpanı.
  final double textScale;

  ReaderSettings copyWith({ReaderViewMode? viewMode, double? textScale}) =>
      ReaderSettings(
        viewMode: viewMode ?? this.viewMode,
        textScale: textScale ?? this.textScale,
      );
}

/// Okuma ayarları; kullanıcı veritabanında kalıcıdır (M13-02, T-05). Tema
/// uygulamayla ortaktır (`themeSettingsProvider`).
class ReaderSettingsNotifier extends Notifier<ReaderSettings> {
  static const _viewModeKey = 'reader.viewMode';
  static const _textScaleKey = 'reader.textScale';

  @override
  ReaderSettings build() {
    final saved = ref.read(userDataSnapshotProvider).settings;
    const defaults = ReaderSettings();
    return ReaderSettings(
      viewMode: enumSetting(
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

  void setViewMode(ReaderViewMode mode) {
    state = state.copyWith(viewMode: mode);
    persistSetting(ref, _viewModeKey, mode.name);
  }

  void setTextScale(double scale) {
    state = state.copyWith(
      textScale: scale.clamp(
        ReaderSettings.minTextScale,
        ReaderSettings.maxTextScale,
      ),
    );
    persistSetting(ref, _textScaleKey, state.textScale);
  }
}

final readerSettingsProvider =
    NotifierProvider<ReaderSettingsNotifier, ReaderSettings>(
      ReaderSettingsNotifier.new,
    );
