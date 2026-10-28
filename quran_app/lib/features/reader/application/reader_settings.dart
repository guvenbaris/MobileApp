import 'package:flutter_riverpod/flutter_riverpod.dart';

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

/// Okuma ayarları. Kalıcılık F0-06/F0-08'de kullanıcı veritabanına bağlanır.
class ReaderSettingsNotifier extends Notifier<ReaderSettings> {
  @override
  ReaderSettings build() => const ReaderSettings();

  void setTheme(MushafTheme theme) => state = state.copyWith(theme: theme);

  void setViewMode(ReaderViewMode mode) =>
      state = state.copyWith(viewMode: mode);

  void setTextScale(double scale) => state = state.copyWith(
    textScale: scale.clamp(
      ReaderSettings.minTextScale,
      ReaderSettings.maxTextScale,
    ),
  );
}

final readerSettingsProvider =
    NotifierProvider<ReaderSettingsNotifier, ReaderSettings>(
      ReaderSettingsNotifier.new,
    );
