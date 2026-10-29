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

  @override
  String get tabToday => 'Bugün';

  @override
  String get tabQuran => 'Kur\'an';

  @override
  String get tabMemorize => 'Hafızlık';

  @override
  String get tabMe => 'Ben';

  @override
  String get todayContinueButton => 'Devam et';

  @override
  String get todayStartButton => 'Başla';

  @override
  String get todayStartDetail => 'Fâtiha\'dan başlayın';

  @override
  String locationDetail(String surah, String ayah, String page, String juz) {
    return '$surah $ayah · Sayfa $page · Cüz $juz';
  }

  @override
  String surahAyah(String surah, String ayah) {
    return '$surah $ayah';
  }

  @override
  String get todayDailyAyah => 'Günün ayeti';

  @override
  String get todayRead => 'Oku';

  @override
  String get quranJumpHint => 'Sure:ayet (2:255) veya sayfa';

  @override
  String get quranJumpInvalid => 'Bulunamadı. Örnek: 2:255 veya sayfa 1–604';

  @override
  String get quranTabSurah => 'Sure';

  @override
  String get quranTabJuz => 'Cüz';

  @override
  String get quranTabPage => 'Sayfa';

  @override
  String juzTitle(String juz) {
    return '$juz. Cüz';
  }

  @override
  String pageAt(String location, String page) {
    return '$location · Sayfa $page';
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
    return 'Son okunan: $location';
  }

  @override
  String get surahMeccan => 'Mekkî';

  @override
  String get surahMedinan => 'Medenî';

  @override
  String get memorizeSoonTitle => 'Hafızlık araçları yakında';

  @override
  String get memorizeSoonMessage =>
      'Ayet gizleme, ezber haritası, tekrar planı ve ezber testi bu sekmede olacak. Hepsi ücretsiz ve internetsiz.';

  @override
  String get readerGoTo => 'Git';

  @override
  String get goToTitle => 'Git';

  @override
  String get goToSurah => 'Sure';

  @override
  String get goToAyah => 'Ayet';

  @override
  String get goToPage => 'Sayfa';

  @override
  String get goToJuz => 'Cüz';

  @override
  String get goToButton => 'Git';

  @override
  String get linkInvalid =>
      'Bu bağlantı geçerli bir ayete veya sayfaya ait değil.';

  @override
  String readerJuzHizb(String juz, String hizb) {
    return 'Cüz $juz · Hizb $hizb';
  }

  @override
  String get readerRightPage => 'Sağ sayfa';

  @override
  String get readerLeftPage => 'Sol sayfa';

  @override
  String get readerSajdah => 'Secde';

  @override
  String get readerNextPage => 'Sonraki sayfa';

  @override
  String get readerPreviousPage => 'Önceki sayfa';

  @override
  String get readerSettings => 'Okuma ayarları';

  @override
  String get readerContent => 'Okuma alanı';

  @override
  String get readerShowControls => 'Menüyü göster';

  @override
  String get readerHideControls => 'Menüyü gizle';

  @override
  String get readerAutoScrollStart => 'Otomatik kaydırmayı başlat';

  @override
  String get readerAutoScrollStop => 'Otomatik kaydırmayı durdur';

  @override
  String get readerAutoScrollSpeed => 'Otomatik kaydırma hızı';

  @override
  String get readerView => 'Görünüm';

  @override
  String get readerViewPage => 'Sayfa';

  @override
  String get readerViewAyah => 'Ayet';

  @override
  String get readerTextSize => 'Yazı boyutu';

  @override
  String get readerTextLock => 'Yazı boyutunu kilitle';

  @override
  String get readerTextLockHint =>
      'Yazı boyutu ve sayfa yakınlaştırması değişmez';

  @override
  String get readerMushafLayout => 'Mushaf düzeni';

  @override
  String get layoutMadani1421 => 'Medine Mushafı (1421 H)';

  @override
  String get readerKeepScreenOn => 'Ekran açık kalsın';

  @override
  String get readerKeepScreenOnHint => 'Okurken ekran kapanmaz';

  @override
  String get readerPageArrows => 'Sayfa okları';

  @override
  String get readerPageArrowsHint =>
      'Kaydırmanın yanında sayfa çevirme düğmeleri';

  @override
  String readerPercent(String value) {
    return '%$value';
  }
}
