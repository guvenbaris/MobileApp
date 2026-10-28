// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Quran';

  @override
  String get homeTitle => 'Home';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get homeStartReading => 'Start reading';

  @override
  String get homeContinueReading => 'Continue reading';

  @override
  String surahAyahCount(int count, String countText) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countText verses',
      one: '$countText verse',
    );
    return '$_temp0';
  }

  @override
  String readerPageTitle(String page) {
    return 'Page $page';
  }

  @override
  String readerPageJuzTitle(String page, String juz) {
    return 'Page $page · Juz $juz';
  }

  @override
  String readerAyahTitle(String ayah) {
    return 'Verse $ayah';
  }

  @override
  String get readerShowPageView => 'Page view';

  @override
  String get readerShowAyahView => 'Verse view';

  @override
  String get readerTextSmaller => 'Smaller text';

  @override
  String get readerTextLarger => 'Larger text';

  @override
  String get readerTheme => 'Theme';

  @override
  String readerSelectedWord(String word) {
    return 'Selected word: $word';
  }

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'Device language';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsNumerals => 'Numerals';

  @override
  String get settingsNumeralsAuto => 'Match language';

  @override
  String get settingsNumeralsWestern => 'Western digits (0123)';

  @override
  String get settingsNumeralsArabic => 'Arabic digits (٠١٢٣)';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeSystem => 'Device setting';

  @override
  String get themeLight => 'Light';

  @override
  String get themeSepia => 'Sepia';

  @override
  String get themeDark => 'Dark';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorLoadContent => 'The content could not be loaded.';

  @override
  String get errorRetry => 'Try again';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsLicenses => 'Licenses';

  @override
  String get settingsLicensesSubtitle =>
      'Quran font, text sources and software licenses';

  @override
  String get aboutLegalese =>
      'Quran font: DigitalKhatt New Madina (SIL Open Font License 1.1).\nQuran text and page layout sources: King Fahd Glorious Quran Printing Complex (KFGQPC), Quran.com, Quranic Universal Library (Tarteel).';

  @override
  String get loading => 'Loading';

  @override
  String surahNumber(String number) {
    return 'Surah $number';
  }

  @override
  String mushafPageLabel(String page) {
    return 'Mushaf, page $page';
  }
}
