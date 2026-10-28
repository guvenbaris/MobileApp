import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mushaf sayfa teması (M2-08). Koyu temada metin alanı da koyudur.
enum MushafTheme { light, sepia, dark }

/// Sayfanın nasıl çizileceği (TK-06).
enum MushafRenderMode {
  /// Varsayılan: tek Kur'an fontu (KFGQPC Hafs), uygulamayla gelir.
  unicodeFont,

  /// İsteğe bağlı paket: QCF V2 sayfa fontları, basılı nüshanın birebir aynısı.
  pageFonts,
}

/// Okuma görünümü (M2-01): mushaf sayfası veya ayet ayet liste.
enum ReaderViewMode { page, ayah }

class ReaderSettings {
  const ReaderSettings({
    this.theme = MushafTheme.sepia,
    this.renderMode = MushafRenderMode.unicodeFont,
    this.viewMode = ReaderViewMode.page,
    this.textScale = 1.0,
  });

  /// Yazı boyutu çarpanının sınırları (M2-07: en az %50–%250).
  static const minTextScale = 0.5;
  static const maxTextScale = 2.5;

  final MushafTheme theme;
  final MushafRenderMode renderMode;
  final ReaderViewMode viewMode;

  /// Ayet görünümünde yazı boyutu çarpanı.
  final double textScale;

  ReaderSettings copyWith({
    MushafTheme? theme,
    MushafRenderMode? renderMode,
    ReaderViewMode? viewMode,
    double? textScale,
  }) => ReaderSettings(
    theme: theme ?? this.theme,
    renderMode: renderMode ?? this.renderMode,
    viewMode: viewMode ?? this.viewMode,
    textScale: textScale ?? this.textScale,
  );
}

/// Okuma ayarları. Kalıcılık F0-06/F0-08'de kullanıcı veritabanına bağlanır.
class ReaderSettingsNotifier extends Notifier<ReaderSettings> {
  @override
  ReaderSettings build() => const ReaderSettings();

  void setTheme(MushafTheme theme) => state = state.copyWith(theme: theme);

  void setRenderMode(MushafRenderMode mode) =>
      state = state.copyWith(renderMode: mode);

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
