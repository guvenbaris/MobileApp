import 'package:flutter/material.dart';

/// Uygulamanın temaları (M2-08).
enum AppThemeId { light, sepia, dark }

/// Renkli tecvid grupları (M2-06). Kur'an metni büyük yazı olduğu için
/// her renk mushaf zeminine karşı en az 3:1 kontrast taşır (WCAG AA büyük
/// metin); çoğu 4,5:1'in üstündedir. Kontrast testi denetler.
@immutable
class TajweedColors {
  const TajweedColors({
    required this.silent,
    required this.maddNatural,
    required this.maddPermissible,
    required this.maddObligatory,
    required this.ghunnah,
    required this.idghaam,
    required this.qalqalah,
  });

  /// Okunmayan harfler (gri).
  final Color silent;

  /// Medd-i tabîî.
  final Color maddNatural;

  /// Caiz medler.
  final Color maddPermissible;

  /// Vacip ve lâzım medler.
  final Color maddObligatory;

  /// Gunne, ihfâ, iklâb, gunneli idğam.
  final Color ghunnah;

  /// Gunnesiz idğam.
  final Color idghaam;
  final Color qalqalah;

  List<Color> get all => [
    silent,
    maddNatural,
    maddPermissible,
    maddObligatory,
    ghunnah,
    idghaam,
    qalqalah,
  ];

  static TajweedColors lerp(TajweedColors a, TajweedColors b, double t) {
    Color c(Color x, Color y) => Color.lerp(x, y, t)!;
    return TajweedColors(
      silent: c(a.silent, b.silent),
      maddNatural: c(a.maddNatural, b.maddNatural),
      maddPermissible: c(a.maddPermissible, b.maddPermissible),
      maddObligatory: c(a.maddObligatory, b.maddObligatory),
      ghunnah: c(a.ghunnah, b.ghunnah),
      idghaam: c(a.idghaam, b.idghaam),
      qalqalah: c(a.qalqalah, b.qalqalah),
    );
  }
}

/// Mushaf sayfasının renkleri. Koyu temada metin alanı da koyudur (M2-08).
@immutable
class MushafColors {
  const MushafColors({
    required this.background,
    required this.text,
    required this.ornament,
    required this.highlight,
    required this.tajweed,
  });

  final Color background;
  final Color text;

  /// Sure başlığı çerçevesi, ayet numarası gibi süsler.
  final Color ornament;

  /// Seçili kelimenin arka planı (yarı saydam; [background] üzerine biner).
  final Color highlight;

  /// Renkli tecvid (M2-06).
  final TajweedColors tajweed;

  static MushafColors lerp(MushafColors a, MushafColors b, double t) =>
      MushafColors(
        background: Color.lerp(a.background, b.background, t)!,
        text: Color.lerp(a.text, b.text, t)!,
        ornament: Color.lerp(a.ornament, b.ornament, t)!,
        highlight: Color.lerp(a.highlight, b.highlight, t)!,
        tajweed: TajweedColors.lerp(a.tajweed, b.tajweed, t),
      );
}

/// Bir temanın anlamsal renkleri. Arayüz renkleri yalnızca buradan gelir;
/// widget'larda renk kodu yazılmaz. Yeni tema eklemek: [AppThemeId]'ye bir
/// değer ve aşağıya bir palet eklemek (kontrast testi kendiliğinden denetler).
///
/// `ThemeExtension` olduğu için ağaçta `context.palette` ile okunur ve tema
/// değişiminde renkler yumuşak geçer.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.id,
    required this.brightness,
    required this.background,
    required this.surface,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.outline,
    required this.error,
    required this.onError,
    required this.mushaf,
  });

  static AppPalette of(AppThemeId id) => switch (id) {
    AppThemeId.light => light,
    AppThemeId.sepia => sepia,
    AppThemeId.dark => dark,
  };

  static const light = AppPalette(
    id: AppThemeId.light,
    brightness: Brightness.light,
    background: Color(0xFFFAFAF7),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1B1C1A),
    onSurfaceMuted: Color(0xFF575C56),
    primary: Color(0xFF1F6F4A),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD3EBDD),
    onPrimaryContainer: Color(0xFF0A3622),
    outline: Color(0xFF767B73),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    mushaf: MushafColors(
      background: Color(0xFFFFFFFF),
      text: Color(0xFF111111),
      ornament: Color(0xFF1F6F4A),
      highlight: Color(0x332E7D32),
      tajweed: TajweedColors(
        silent: Color(0xFF7A7F87),
        maddNatural: Color(0xFF9A6200),
        maddPermissible: Color(0xFFD84315),
        maddObligatory: Color(0xFFB71C1C),
        ghunnah: Color(0xFF2E7D32),
        idghaam: Color(0xFF7B4FA0),
        qalqalah: Color(0xFF1565C0),
      ),
    ),
  );

  static const sepia = AppPalette(
    id: AppThemeId.sepia,
    brightness: Brightness.light,
    background: Color(0xFFF7EEDB),
    surface: Color(0xFFFBF5E8),
    onSurface: Color(0xFF2B2116),
    onSurfaceMuted: Color(0xFF5E4E3B),
    primary: Color(0xFF7A4E14),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFEBD8B2),
    onPrimaryContainer: Color(0xFF3A2508),
    outline: Color(0xFF85725A),
    error: Color(0xFFA3261E),
    onError: Color(0xFFFFFFFF),
    mushaf: MushafColors(
      background: Color(0xFFF7EEDB),
      text: Color(0xFF2B2116),
      ornament: Color(0xFF7A4E14),
      highlight: Color(0x40C08A2E),
      tajweed: TajweedColors(
        silent: Color(0xFF736B5E),
        maddNatural: Color(0xFF8A5600),
        maddPermissible: Color(0xFFBF360C),
        maddObligatory: Color(0xFFA31515),
        ghunnah: Color(0xFF2E6B2F),
        idghaam: Color(0xFF6E4592),
        qalqalah: Color(0xFF1257A8),
      ),
    ),
  );

  static const dark = AppPalette(
    id: AppThemeId.dark,
    brightness: Brightness.dark,
    background: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFE8E2D6),
    onSurfaceMuted: Color(0xFFB5AFA4),
    primary: Color(0xFFC9A55C),
    onPrimary: Color(0xFF2A1E00),
    primaryContainer: Color(0xFF4A3A16),
    onPrimaryContainer: Color(0xFFF3E2B8),
    outline: Color(0xFF8F8A80),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    mushaf: MushafColors(
      background: Color(0xFF121212),
      text: Color(0xFFE8E2D6),
      ornament: Color(0xFFC9A55C),
      highlight: Color(0x40C9A55C),
      tajweed: TajweedColors(
        silent: Color(0xFF9A958C),
        maddNatural: Color(0xFFE0B04A),
        maddPermissible: Color(0xFFFF8A50),
        maddObligatory: Color(0xFFEF5350),
        ghunnah: Color(0xFF66BB6A),
        idghaam: Color(0xFFB39DDB),
        qalqalah: Color(0xFF64B5F6),
      ),
    ),
  );

  final AppThemeId id;
  final Brightness brightness;

  /// Ekran arka planı.
  final Color background;

  /// Kart, liste, çubuk gibi yüzeyler.
  final Color surface;

  /// Ana metin.
  final Color onSurface;

  /// İkincil metin (alt başlık, açıklama).
  final Color onSurfaceMuted;

  /// Vurgu rengi: düğmeler, seçili öğeler, bölüm başlıkları.
  final Color primary;
  final Color onPrimary;

  /// Vurgunun yumuşak hali (ör. yüzen düğme, seçili satır).
  final Color primaryContainer;
  final Color onPrimaryContainer;

  /// Kenarlık ve ayırıcılar (metin değil; en az 3:1).
  final Color outline;
  final Color error;
  final Color onError;
  final MushafColors mushaf;

  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      id: t < 0.5 ? id : other.id,
      brightness: t < 0.5 ? brightness : other.brightness,
      background: c(background, other.background),
      surface: c(surface, other.surface),
      onSurface: c(onSurface, other.onSurface),
      onSurfaceMuted: c(onSurfaceMuted, other.onSurfaceMuted),
      primary: c(primary, other.primary),
      onPrimary: c(onPrimary, other.onPrimary),
      primaryContainer: c(primaryContainer, other.primaryContainer),
      onPrimaryContainer: c(onPrimaryContainer, other.onPrimaryContainer),
      outline: c(outline, other.outline),
      error: c(error, other.error),
      onError: c(onError, other.onError),
      mushaf: MushafColors.lerp(mushaf, other.mushaf, t),
    );
  }
}

extension AppPaletteContext on BuildContext {
  /// Geçerli temanın paleti. Tema kurulmamışsa (ör. tek ekranlı testler)
  /// açık tema.
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}
