import 'package:flutter/widgets.dart';

/// Arayüz dili seçimi (M13-01). [system] cihazın dilini izler.
enum AppLanguage {
  system(null),
  tr('tr'),
  ar('ar'),
  en('en');

  const AppLanguage(this.languageCode);

  /// Seçili dilin kodu; [system] için `null`.
  final String? languageCode;
}

/// Sayıların rakam sistemi (NF-Y03). [auto]: Arapçada Doğu Arap rakamları
/// (٠١٢), diğer dillerde Batı rakamları (012).
enum NumeralSystem { auto, western, arabic }

/// Desteklenen diller. Sıra, ayarlar ekranındaki sıradır.
const kSupportedLocales = [Locale('tr'), Locale('ar'), Locale('en')];

/// Cihaz dili desteklenmiyorsa kullanılan dil.
const kFallbackLocale = Locale('en');

/// Uygulamanın kullanacağı dili seçer: kullanıcı bir dil seçtiyse o,
/// yoksa cihazın tercih ettiği dillerden desteklenen ilki, o da yoksa
/// [kFallbackLocale]. Yalnızca dil kodu karşılaştırılır (tr_TR → tr).
Locale resolveAppLocale(AppLanguage language, List<Locale>? deviceLocales) {
  if (language.languageCode case final code?) return Locale(code);
  for (final device in deviceLocales ?? const <Locale>[]) {
    for (final supported in kSupportedLocales) {
      if (supported.languageCode == device.languageCode) return supported;
    }
  }
  return kFallbackLocale;
}
