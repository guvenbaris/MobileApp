import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'content_database.dart';

/// DigitalKhatt fontunun lisans dosyası (SIL OFL 1.1).
const kQuranFontLicenseAsset = 'assets/fonts/DigitalKhatt-OFL.txt';

/// Uygulamayla dağıtılan Kur'an fontu ve metin lisanslarını Flutter'ın lisans
/// sayfasına (`showLicensePage`) ekler. Paketlerin lisanslarını Flutter
/// kendisi ekler. Ayrıntı: VERI_KAYNAKLARI.md.
void registerContentLicenses(ContentDatabase contentDb) {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(const [
      'DigitalKhatt New Madina',
    ], await rootBundle.loadString(kQuranFontLicenseAsset));
    // `ayahs.text_uthmani` Tanzil metnidir; telif notu veritabanında durur.
    final tanzil = await contentDb.metaValue('notice.tanzil');
    if (tanzil != null) {
      yield LicenseEntryWithLineBreaks(const ['Tanzil Quran Text'], tanzil);
    }
  });
}
