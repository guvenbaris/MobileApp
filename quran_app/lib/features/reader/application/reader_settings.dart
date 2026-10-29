import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../user_data/application/user_data_providers.dart';

/// Okuma görünümü (M2-01): mushaf sayfası veya ayet ayet liste.
enum ReaderViewMode { page, ayah }

class ReaderSettings {
  const ReaderSettings({
    this.viewMode = ReaderViewMode.page,
    this.textScale = 1.0,
    this.textScaleLocked = false,
    this.keepScreenOn = true,
    this.pageArrows = false,
    this.autoScrollSpeed = 3,
  });

  /// Yazı boyutu çarpanının sınırları (M2-07: en az %50–%250).
  static const minTextScale = 0.5;
  static const maxTextScale = 2.5;
  static const textScaleStep = 0.25;

  /// Otomatik kaydırma hız kademeleri (M2-11).
  static const minAutoScrollSpeed = 1;
  static const maxAutoScrollSpeed = 10;

  final ReaderViewMode viewMode;

  /// Ayet görünümünde yazı boyutu çarpanı.
  final double textScale;

  /// Yazı boyutu kilidi (M2-07): açıkken yazı boyutu değişmez, sayfa
  /// görünümünde yakınlaştırma kapanır.
  final bool textScaleLocked;

  /// Okurken ekran kapanmasın (M2-12). Varsayılan açık: okuma ekranının
  /// asıl işi metni göstermektir.
  final bool keepScreenOn;

  /// Sayfa okları (M2-09). Varsayılan kapalı; kaydırma yeterli (ET-5).
  final bool pageArrows;

  /// Otomatik kaydırma hızı, 1 (en yavaş) – 10.
  final int autoScrollSpeed;

  /// Ayet görünümünde otomatik kaydırma hızı (mantıksal piksel/saniye).
  double get autoScrollPixelsPerSecond => 5.0 + 10 * autoScrollSpeed;

  /// Sayfa görünümünde otomatik kaydırmada bir sayfada kalma süresi.
  /// 15 satırlık bir sayfa orta hızla yaklaşık iki dakikada okunur (kademe 5).
  Duration get autoScrollPageDuration =>
      Duration(seconds: 200 - 16 * autoScrollSpeed);

  ReaderSettings copyWith({
    ReaderViewMode? viewMode,
    double? textScale,
    bool? textScaleLocked,
    bool? keepScreenOn,
    bool? pageArrows,
    int? autoScrollSpeed,
  }) => ReaderSettings(
    viewMode: viewMode ?? this.viewMode,
    textScale: textScale ?? this.textScale,
    textScaleLocked: textScaleLocked ?? this.textScaleLocked,
    keepScreenOn: keepScreenOn ?? this.keepScreenOn,
    pageArrows: pageArrows ?? this.pageArrows,
    autoScrollSpeed: autoScrollSpeed ?? this.autoScrollSpeed,
  );
}

/// Okuma ayarları; kullanıcı veritabanında kalıcıdır (M13-02, T-05). Tema
/// uygulamayla ortaktır (`themeSettingsProvider`).
class ReaderSettingsNotifier extends Notifier<ReaderSettings> {
  static const _viewModeKey = 'reader.viewMode';
  static const _textScaleKey = 'reader.textScale';
  static const _textScaleLockedKey = 'reader.textScaleLocked';
  static const _keepScreenOnKey = 'reader.keepScreenOn';
  static const _pageArrowsKey = 'reader.pageArrows';
  static const _autoScrollSpeedKey = 'reader.autoScrollSpeed';

  @override
  ReaderSettings build() {
    final saved = ref.read(userDataSnapshotProvider).settings;
    const defaults = ReaderSettings();
    bool flag(String key, bool fallback) => switch (saved[key]) {
      final bool v => v,
      _ => fallback,
    };
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
      textScaleLocked: flag(_textScaleLockedKey, defaults.textScaleLocked),
      keepScreenOn: flag(_keepScreenOnKey, defaults.keepScreenOn),
      pageArrows: flag(_pageArrowsKey, defaults.pageArrows),
      autoScrollSpeed: switch (saved[_autoScrollSpeedKey]) {
        final num v => v.round().clamp(
          ReaderSettings.minAutoScrollSpeed,
          ReaderSettings.maxAutoScrollSpeed,
        ),
        _ => defaults.autoScrollSpeed,
      },
    );
  }

  void setViewMode(ReaderViewMode mode) {
    state = state.copyWith(viewMode: mode);
    persistSetting(ref, _viewModeKey, mode.name);
  }

  /// Kilitliyse yok sayılır (M2-07).
  void setTextScale(double scale) {
    if (state.textScaleLocked) return;
    state = state.copyWith(
      textScale: scale.clamp(
        ReaderSettings.minTextScale,
        ReaderSettings.maxTextScale,
      ),
    );
    persistSetting(ref, _textScaleKey, state.textScale);
  }

  void setTextScaleLocked(bool locked) {
    state = state.copyWith(textScaleLocked: locked);
    persistSetting(ref, _textScaleLockedKey, locked);
  }

  void setKeepScreenOn(bool on) {
    state = state.copyWith(keepScreenOn: on);
    persistSetting(ref, _keepScreenOnKey, on);
  }

  void setPageArrows(bool on) {
    state = state.copyWith(pageArrows: on);
    persistSetting(ref, _pageArrowsKey, on);
  }

  void setAutoScrollSpeed(int speed) {
    state = state.copyWith(
      autoScrollSpeed: speed.clamp(
        ReaderSettings.minAutoScrollSpeed,
        ReaderSettings.maxAutoScrollSpeed,
      ),
    );
    persistSetting(ref, _autoScrollSpeedKey, state.autoScrollSpeed);
  }
}

final readerSettingsProvider =
    NotifierProvider<ReaderSettingsNotifier, ReaderSettings>(
      ReaderSettingsNotifier.new,
    );
