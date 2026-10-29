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
      'Kur\'an fontu: DigitalKhatt New Madina (SIL Open Font License 1.1).\nKur\'an metni ve sayfa düzeni kaynakları: Kral Fahd Kur\'an Basım Kompleksi (KFGQPC), Quran.com, Quranic Universal Library (Tarteel).\nRenkli tecvid verisi: cpfair/quran-tajweed (Colin Pfair), Creative Commons Attribution 4.0 (https://creativecommons.org/licenses/by/4.0/). Bu uygulamada DigitalKhatt metnine uyarlanmış ve kurallar 7 renk grubunda toplanmıştır.';

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

  @override
  String get layoutMadani1405 => 'Medine Mushafı (1405 H)';

  @override
  String readerLayoutInfo(String pages, String lines) {
    return '$pages sayfa · $lines satır';
  }

  @override
  String get readerLayoutDownloaded => 'İndirilen paket';

  @override
  String get readerTajweed => 'Renkli tecvid';

  @override
  String get readerTajweedHint =>
      'Kurallar renkle gösterilir; kelimeye dokununca adı ve açıklaması';

  @override
  String get tajweedLegend => 'Tecvid renkleri';

  @override
  String get tajweedSource =>
      'Kural verisi: cpfair/quran-tajweed (CC BY 4.0), DigitalKhatt metnine uyarlandı. Açıklamalar kısa bir özettir; ayrıntı için bir hocaya danışın.';

  @override
  String get tajweedAllColors => 'Tüm renkler';

  @override
  String get tajweedGroupSilent => 'Okunmayan harfler';

  @override
  String get tajweedGroupMaddNatural => 'Tabii med';

  @override
  String get tajweedGroupMaddPermissible => 'Caiz medler';

  @override
  String get tajweedGroupMaddObligatory => 'Vacip ve lâzım medler';

  @override
  String get tajweedGroupGhunnah => 'Gunne ve ihfâ';

  @override
  String get tajweedGroupIdghaam => 'Gunnesiz idğam';

  @override
  String get tajweedGroupQalqalah => 'Kalkale';

  @override
  String get tajweedHamzatWasl => 'Hemze-i vasl';

  @override
  String get tajweedHamzatWaslInfo =>
      'Kelime başındaki bu elif, önceki kelimeye bağlanarak okunurken okunmaz; okumaya bu kelimeden başlanırsa okunur.';

  @override
  String get tajweedLamShamsiyyah => 'Lâm-ı şemsiyye';

  @override
  String get tajweedLamShamsiyyahInfo =>
      'Harf-i tarifin lâmı şemsî harflerden önce okunmaz; sonraki harf şeddeli okunur.';

  @override
  String get tajweedSilent => 'Okunmayan harf';

  @override
  String get tajweedSilentInfo => 'Yazıda bulunan ama okunmayan harf.';

  @override
  String get tajweedMadd2 => 'Medd-i tabîî';

  @override
  String get tajweedMadd2Info =>
      'Med harfi, ardından hemze veya sükûn gelmediğinde 2 hareke uzatılır.';

  @override
  String get tajweedMadd246 => 'Medd-i ârız / lîn';

  @override
  String get tajweedMadd246Info =>
      'Durulan kelimede med veya lîn harfinden sonra gelen harf geçici olarak sakin olur; 2, 4 veya 6 hareke uzatılabilir.';

  @override
  String get tajweedMaddMunfasil => 'Medd-i munfasıl';

  @override
  String get tajweedMaddMunfasilInfo =>
      'Med harfi bir kelimenin sonunda, hemze sonraki kelimenin başındadır; uzatılması caizdir, miktarı okuma usulüne göre değişir.';

  @override
  String get tajweedMaddMuttasil => 'Medd-i muttasıl';

  @override
  String get tajweedMaddMuttasilInfo =>
      'Med harfi ile hemze aynı kelimededir; uzatılması vaciptir (4–5 hareke).';

  @override
  String get tajweedMadd6 => 'Medd-i lâzım';

  @override
  String get tajweedMadd6Info =>
      'Med harfinden sonra aslen sakin veya şeddeli harf gelir; 6 hareke uzatılır.';

  @override
  String get tajweedGhunnah => 'Gunne';

  @override
  String get tajweedGhunnahInfo =>
      'Şeddeli mim veya nun, 2 hareke miktarı genizden okunur.';

  @override
  String get tajweedIkhfa => 'İhfâ';

  @override
  String get tajweedIkhfaInfo =>
      'Sakin nun veya tenvinden sonra ihfâ harflerinden biri gelince nun gizlenerek genizden okunur.';

  @override
  String get tajweedIkhfaShafawi => 'İhfâ-i şefevî';

  @override
  String get tajweedIkhfaShafawiInfo =>
      'Sakin mimden sonra be gelince mim, dudaklar hafifçe kapatılarak genizden okunur.';

  @override
  String get tajweedIdghaamGhunnah => 'Gunneli idğam';

  @override
  String get tajweedIdghaamGhunnahInfo =>
      'Sakin nun veya tenvinden sonra ي ن م و harflerinden biri gelince nun sonraki harfe katılır ve genizden okunur.';

  @override
  String get tajweedIdghaamShafawi => 'İdğâm-ı şefevî';

  @override
  String get tajweedIdghaamShafawiInfo =>
      'Sakin mimden sonra mim gelince ikisi birleşir ve gunneyle okunur.';

  @override
  String get tajweedIqlab => 'İklâb';

  @override
  String get tajweedIqlabInfo =>
      'Sakin nun veya tenvinden sonra be gelince nun, mime çevrilerek genizden okunur.';

  @override
  String get tajweedIdghaamNoGhunnah => 'Gunnesiz idğam';

  @override
  String get tajweedIdghaamNoGhunnahInfo =>
      'Sakin nun veya tenvinden sonra lâm veya râ gelince nun, gunnesiz olarak sonraki harfe katılır.';

  @override
  String get tajweedIdghaamMutajanisayn => 'İdğâm-ı mütecâniseyn';

  @override
  String get tajweedIdghaamMutajanisaynInfo =>
      'Mahreci aynı, sıfatları farklı iki harften ilki sakin olunca ikinciye katılır.';

  @override
  String get tajweedIdghaamMutaqaribayn => 'İdğâm-ı mütekâribeyn';

  @override
  String get tajweedIdghaamMutaqaribaynInfo =>
      'Mahreci ve sıfatları yakın iki harften ilki sakin olunca ikinciye katılır.';

  @override
  String get tajweedQalqalah => 'Kalkale';

  @override
  String get tajweedQalqalahInfo =>
      'ق ط ب ج د harfleri sakin olunca ses hafifçe titretilerek okunur.';
}
