import 'package:flutter/widgets.dart';

import '../domain/quran_models.dart';

extension SurahL10n on Surah {
  /// Arayüz dilindeki sure adı: Türkçede Türkçe okunuş (Bakara), Arapçada
  /// Arapça ad, İngilizcede Latin harfli okunuş (Al-Baqarah).
  String localizedName(BuildContext context) =>
      switch (Localizations.localeOf(context).languageCode) {
        'tr' => nameTr,
        'ar' => nameArabic,
        _ => nameSimple,
      };
}
