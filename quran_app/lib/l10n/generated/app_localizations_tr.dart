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

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Cihaz ayarı';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeSepia => 'Sepya';

  @override
  String get themeDark => 'Koyu';

  @override
  String get errorTitle => 'Bir sorun oluştu';

  @override
  String get errorLoadContent => 'İçerik yüklenemedi.';

  @override
  String get errorRetry => 'Tekrar dene';

  @override
  String get settingsAbout => 'Hakkında';

  @override
  String get settingsLicenses => 'Lisanslar';

  @override
  String get settingsLicensesSubtitle =>
      'Kur\'an fontu, metin kaynakları ve yazılım lisansları';

  @override
  String get aboutLegalese =>
      'Kur\'an fontu: DigitalKhatt New Madina (SIL Open Font License 1.1).\nKur\'an metni ve sayfa düzeni kaynakları: Kral Fahd Kur\'an Basım Kompleksi (KFGQPC), Quran.com, Quranic Universal Library (Tarteel).';

  @override
  String get loading => 'Yükleniyor';

  @override
  String surahNumber(String number) {
    return '$number. sure';
  }

  @override
  String mushafPageLabel(String page) {
    return 'Mushaf, sayfa $page';
  }
}
