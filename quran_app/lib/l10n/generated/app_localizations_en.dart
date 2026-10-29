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

  @override
  String get tabToday => 'Today';

  @override
  String get tabQuran => 'Quran';

  @override
  String get tabMemorize => 'Memorize';

  @override
  String get tabMe => 'Me';

  @override
  String get todayContinueButton => 'Continue';

  @override
  String get todayStartButton => 'Start';

  @override
  String get todayStartDetail => 'Start with Al-Fatihah';

  @override
  String locationDetail(String surah, String ayah, String page, String juz) {
    return '$surah $ayah · Page $page · Juz $juz';
  }

  @override
  String surahAyah(String surah, String ayah) {
    return '$surah $ayah';
  }

  @override
  String get todayDailyAyah => 'Verse of the day';

  @override
  String get todayRead => 'Read';

  @override
  String get quranJumpHint => 'Surah:verse (2:255) or page';

  @override
  String get quranJumpInvalid => 'Not found. Example: 2:255 or page 1–604';

  @override
  String get quranTabSurah => 'Surah';

  @override
  String get quranTabJuz => 'Juz';

  @override
  String get quranTabPage => 'Page';

  @override
  String juzTitle(String juz) {
    return 'Juz $juz';
  }

  @override
  String pageAt(String location, String page) {
    return '$location · Page $page';
  }

  @override
  String hizbStart(String hizb) {
    return 'Hizb $hizb';
  }

  @override
  String hizbQuarter(String hizb, String fraction) {
    return 'Hizb $hizb · $fraction';
  }

  @override
  String lastRead(String location) {
    return 'Last read: $location';
  }

  @override
  String get surahMeccan => 'Meccan';

  @override
  String get surahMedinan => 'Medinan';

  @override
  String get memorizeSoonTitle => 'Memorization tools are coming';

  @override
  String get memorizeSoonMessage =>
      'Verse hiding, a memorization map, a review plan and memorization tests will be here. All free and offline.';

  @override
  String get readerGoTo => 'Go to';

  @override
  String get goToTitle => 'Go to';

  @override
  String get goToSurah => 'Surah';

  @override
  String get goToAyah => 'Verse';

  @override
  String get goToPage => 'Page';

  @override
  String get goToJuz => 'Juz';

  @override
  String get goToButton => 'Go';

  @override
  String get linkInvalid =>
      'This link does not point to a valid verse or page.';

  @override
  String readerJuzHizb(String juz, String hizb) {
    return 'Juz $juz · Hizb $hizb';
  }

  @override
  String get readerRightPage => 'Right page';

  @override
  String get readerLeftPage => 'Left page';

  @override
  String get readerSajdah => 'Sajdah';

  @override
  String get readerNextPage => 'Next page';

  @override
  String get readerPreviousPage => 'Previous page';

  @override
  String get readerSettings => 'Reading settings';

  @override
  String get readerContent => 'Reading area';

  @override
  String get readerShowControls => 'Show controls';

  @override
  String get readerHideControls => 'Hide controls';

  @override
  String get readerAutoScrollStart => 'Start auto-scroll';

  @override
  String get readerAutoScrollStop => 'Stop auto-scroll';

  @override
  String get readerAutoScrollSpeed => 'Auto-scroll speed';

  @override
  String get readerView => 'View';

  @override
  String get readerViewPage => 'Page';

  @override
  String get readerViewAyah => 'Verse';

  @override
  String get readerTextSize => 'Text size';

  @override
  String get readerTextLock => 'Lock text size';

  @override
  String get readerTextLockHint => 'Text size and page zoom stay fixed';

  @override
  String get readerMushafLayout => 'Mushaf layout';

  @override
  String get layoutMadani1421 => 'Madinah Mushaf (1421 AH)';

  @override
  String get readerKeepScreenOn => 'Keep screen on';

  @override
  String get readerKeepScreenOnHint => 'The screen stays on while reading';

  @override
  String get readerPageArrows => 'Page arrows';

  @override
  String get readerPageArrowsHint =>
      'Buttons to turn pages, in addition to swiping';

  @override
  String readerPercent(String value) {
    return '$value%';
  }
}
