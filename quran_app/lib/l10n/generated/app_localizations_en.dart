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
      'Quran font: DigitalKhatt New Madina (SIL Open Font License 1.1).\nQuran text and page layout sources: King Fahd Glorious Quran Printing Complex (KFGQPC), Quran.com, Quranic Universal Library (Tarteel).\nColour-coded tajweed data: cpfair/quran-tajweed (Colin Pfair), Creative Commons Attribution 4.0 (https://creativecommons.org/licenses/by/4.0/). Adapted in this app to the DigitalKhatt text, with rules grouped into 7 colours.';

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

  @override
  String get layoutMadani1405 => 'Madinah Mushaf (1405 AH)';

  @override
  String readerLayoutInfo(String pages, String lines) {
    return '$pages pages · $lines lines';
  }

  @override
  String get readerLayoutDownloaded => 'Downloaded package';

  @override
  String get readerTajweed => 'Colour-coded tajweed';

  @override
  String get readerTajweedHint =>
      'Rules are shown in colour; tap a word for the rule name and explanation';

  @override
  String get tajweedLegend => 'Tajweed colours';

  @override
  String get tajweedSource =>
      'Rule data: cpfair/quran-tajweed (CC BY 4.0), adapted to the DigitalKhatt text. Explanations are brief; consult a teacher for details.';

  @override
  String get tajweedAllColors => 'All colours';

  @override
  String get tajweedGroupSilent => 'Silent letters';

  @override
  String get tajweedGroupMaddNatural => 'Natural madd';

  @override
  String get tajweedGroupMaddPermissible => 'Permissible madd';

  @override
  String get tajweedGroupMaddObligatory => 'Obligatory and necessary madd';

  @override
  String get tajweedGroupGhunnah => 'Ghunnah and ikhfa';

  @override
  String get tajweedGroupIdghaam => 'Idgham without ghunnah';

  @override
  String get tajweedGroupQalqalah => 'Qalqalah';

  @override
  String get tajweedHamzatWasl => 'Hamzat al-wasl';

  @override
  String get tajweedHamzatWaslInfo =>
      'This alif at the start of a word is dropped when joined to the previous word and pronounced only when starting from this word.';

  @override
  String get tajweedLamShamsiyyah => 'Lam shamsiyyah';

  @override
  String get tajweedLamShamsiyyahInfo =>
      'The lam of the definite article is not pronounced before a sun letter; the following letter is doubled.';

  @override
  String get tajweedSilent => 'Silent letter';

  @override
  String get tajweedSilentInfo =>
      'A letter that is written but not pronounced.';

  @override
  String get tajweedMadd2 => 'Natural madd';

  @override
  String get tajweedMadd2Info =>
      'A madd letter not followed by a hamza or sukun is lengthened for 2 counts.';

  @override
  String get tajweedMadd246 => 'Madd ʿarid / leen';

  @override
  String get tajweedMadd246Info =>
      'When stopping, the letter after a madd or leen letter becomes silent; it may be lengthened for 2, 4 or 6 counts.';

  @override
  String get tajweedMaddMunfasil => 'Madd munfasil';

  @override
  String get tajweedMaddMunfasilInfo =>
      'A madd letter ends one word and a hamza begins the next; lengthening is permitted and its amount depends on the recitation method.';

  @override
  String get tajweedMaddMuttasil => 'Madd muttasil';

  @override
  String get tajweedMaddMuttasilInfo =>
      'A madd letter and a hamza in the same word; lengthening is obligatory (4–5 counts).';

  @override
  String get tajweedMadd6 => 'Madd lazim';

  @override
  String get tajweedMadd6Info =>
      'A madd letter followed by an original sukun or a doubled letter; lengthened for 6 counts.';

  @override
  String get tajweedGhunnah => 'Ghunnah';

  @override
  String get tajweedGhunnahInfo =>
      'A doubled meem or noon is nasalised for 2 counts.';

  @override
  String get tajweedIkhfa => 'Ikhfa';

  @override
  String get tajweedIkhfaInfo =>
      'When a silent noon or tanween is followed by an ikhfa letter, the noon is concealed and nasalised.';

  @override
  String get tajweedIkhfaShafawi => 'Ikhfa shafawi';

  @override
  String get tajweedIkhfaShafawiInfo =>
      'When a silent meem is followed by baa, the meem is concealed with nasalisation.';

  @override
  String get tajweedIdghaamGhunnah => 'Idgham with ghunnah';

  @override
  String get tajweedIdghaamGhunnahInfo =>
      'When a silent noon or tanween is followed by ي ن م و, the noon merges into it with nasalisation.';

  @override
  String get tajweedIdghaamShafawi => 'Idgham shafawi';

  @override
  String get tajweedIdghaamShafawiInfo =>
      'A silent meem followed by a meem merges into it with nasalisation.';

  @override
  String get tajweedIqlab => 'Iqlab';

  @override
  String get tajweedIqlabInfo =>
      'When a silent noon or tanween is followed by baa, the noon turns into a meem with nasalisation.';

  @override
  String get tajweedIdghaamNoGhunnah => 'Idgham without ghunnah';

  @override
  String get tajweedIdghaamNoGhunnahInfo =>
      'When a silent noon or tanween is followed by lam or raa, the noon merges into it without nasalisation.';

  @override
  String get tajweedIdghaamMutajanisayn => 'Idgham mutajanisayn';

  @override
  String get tajweedIdghaamMutajanisaynInfo =>
      'Of two letters sharing a point of articulation but differing in qualities, the first (silent) merges into the second.';

  @override
  String get tajweedIdghaamMutaqaribayn => 'Idgham mutaqaribayn';

  @override
  String get tajweedIdghaamMutaqaribaynInfo =>
      'Of two letters close in articulation and qualities, the first (silent) merges into the second.';

  @override
  String get tajweedQalqalah => 'Qalqalah';

  @override
  String get tajweedQalqalahInfo =>
      'The letters ق ط ب ج د, when silent, are pronounced with a slight echoing bounce.';
}
