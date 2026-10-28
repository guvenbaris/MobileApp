// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Kur\'an';

  @override
  String get homeTitle => 'Ana Sayfa';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get homeStartReading => 'Okumaya başla';

  @override
  String get homeContinueReading => 'Okumaya devam et';

  @override
  String surahAyahCount(int count, String countText) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countText ayet',
    );
    return '$_temp0';
  }

  @override
  String readerPageTitle(String page) {
    return 'Sayfa $page';
  }

  @override
  String readerPageJuzTitle(String page, String juz) {
    return 'Sayfa $page · Cüz $juz';
  }

  @override
  String readerAyahTitle(String ayah) {
    return 'Ayet $ayah';
  }

  @override
  String get readerShowPageView => 'Sayfa görünümü';

  @override
  String get readerShowAyahView => 'Ayet görünümü';

  @override
  String get readerTextSmaller => 'Yazıyı küçült';

  @override
  String get readerTextLarger => 'Yazıyı büyüt';

  @override
  String get readerTheme => 'Tema';

  @override
  String readerSelectedWord(String word) {
    return 'Seçilen kelime: $word';
  }

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsLanguageSystem => 'Cihaz dili';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsNumerals => 'Rakamlar';

  @override
  String get settingsNumeralsAuto => 'Dile göre';

  @override
  String get settingsNumeralsWestern => 'Batı rakamları (0123)';

  @override
  String get settingsNumeralsArabic => 'Arap rakamları (٠١٢٣)';
}
