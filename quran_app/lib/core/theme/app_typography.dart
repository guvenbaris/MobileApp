import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';

/// Uygulamanın Kur'an fontu: DigitalKhatt New Madina (SIL OFL 1.1,
/// `assets/fonts/DigitalKhatt-OFL.txt`). Medine mushafı hattının dijital
/// yeniden çizimi (TK-06).
const kQuranFontFamily = 'DigitalKhatt'; // l10n-ignore: font adı

/// DigitalKhatt'ın boşluk karakteri dar (0,1 em): kelime aralığını basılı
/// nüshada yaslama motoru açar. Akan metinde (ayet görünümü, başlık, besmele)
/// kelime aralığı bu oranda genişletilir.
const kQuranWordSpacing = 0.2;

/// Tipografi ölçeği.
///
/// - **Arayüz:** Material 3 ölçeği (display…label) ve platformun sistem fontu
///   (Android'de Roboto, iOS'ta SF; Arapça harfler için sistemin Arapça
///   fontu). Sistem yazı boyutu ayarı Flutter tarafından kendiliğinden
///   uygulanır (M13-04). Marka fontu seçilirse yalnızca [uiFontFamily]
///   değişir.
/// - **Kur'an metni:** [quran] ile; boyutlar okuma ayarındaki çarpanla
///   ölçeklenir (M2-07).
abstract final class AppTypography {
  /// Arayüz fontu; `null` = platformun sistem fontu.
  static const String? uiFontFamily = null;

  /// Ayet görünümündeki ayet metninin temel boyutu.
  static const quranAyahSize = 26.0;

  /// Ayet görünümündeki sure başlığının temel boyutu.
  static const quranHeaderSize = 22.0;

  /// Arayüz metin ölçeği, verilen metin rengiyle.
  static TextTheme textTheme(Brightness brightness, Color onSurface) {
    final typography = Typography.material2021(platform: defaultTargetPlatform);
    final base = brightness == Brightness.dark
        ? typography.white
        : typography.black;
    return base.apply(
      fontFamily: uiFontFamily,
      bodyColor: onSurface,
      displayColor: onSurface,
    );
  }

  /// Kur'an metni stili. [fontSize] satıra sığdırma veya yazı boyutu
  /// çarpanıyla hesaplanmış boyuttur.
  static TextStyle quran({
    required double fontSize,
    required Color color,
    double? height,
  }) => TextStyle(
    fontFamily: kQuranFontFamily,
    fontSize: fontSize,
    height: height,
    wordSpacing: fontSize * kQuranWordSpacing,
    color: color,
  );
}
