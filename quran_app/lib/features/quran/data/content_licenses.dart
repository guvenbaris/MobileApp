import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// DigitalKhatt fontunun lisans dosyası (SIL OFL 1.1).
const kQuranFontLicenseAsset = 'assets/fonts/DigitalKhatt-OFL.txt';

/// Uygulamayla dağıtılan Kur'an fontunun lisansını Flutter'ın lisans
/// sayfasına (`showLicensePage`) ekler. Paketlerin lisanslarını Flutter
/// kendisi ekler. Ayrıntı: VERI_KAYNAKLARI.md.
void registerContentLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(const [
      'DigitalKhatt New Madina',
    ], await rootBundle.loadString(kQuranFontLicenseAsset));
  });
}
