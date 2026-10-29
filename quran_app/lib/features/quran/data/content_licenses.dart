import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// DigitalKhatt fontunun lisans dosyası (SIL OFL 1.1).
const kQuranFontLicenseAsset = 'assets/fonts/DigitalKhatt-OFL.txt';

/// Renkli tecvid verisinin atfı (CC BY 4.0: eser sahibi, lisans ve yapılan
/// değişiklik belirtilir; İÇ-01).
const kTajweedLicenseNotice =
    'Quran tajweed annotations by Colin Pfair (cpfair/quran-tajweed, '
    'https://github.com/cpfair/quran-tajweed), licensed under the Creative '
    'Commons Attribution 4.0 International License '
    '(https://creativecommons.org/licenses/by/4.0/).\n\n'
    'Changes: the annotations were mapped from the Tanzil Uthmani text '
    'offsets onto the DigitalKhatt word text used in this app, overlapping '
    'rules on the same letter were resolved by priority, and the rules are '
    'displayed in 7 colour groups. The Tanzil text itself is not included.';

/// Uygulamayla dağıtılan içeriklerin lisanslarını Flutter'ın lisans
/// sayfasına (`showLicensePage`) ekler: Kur'an fontu (OFL) ve renkli tecvid
/// verisi (CC BY 4.0). Paketlerin lisanslarını Flutter kendisi ekler.
/// Ayrıntı: VERI_KAYNAKLARI.md.
void registerContentLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(const [
      'DigitalKhatt New Madina',
    ], await rootBundle.loadString(kQuranFontLicenseAsset));
    yield const LicenseEntryWithLineBreaks([
      'cpfair/quran-tajweed',
    ], kTajweedLicenseNotice);
  });
}
