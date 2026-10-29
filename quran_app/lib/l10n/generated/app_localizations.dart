import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('tr'),
  ];

  /// Görev değiştiricide görünen geçici uygulama adı (AK-04 kararına kadar).
  ///
  /// In tr, this message translates to:
  /// **'Kur\'an'**
  String get appTitle;

  /// Ayarlar ekranının başlığı; ana sayfadaki ayarlar düğmesinin ipucu olarak da kullanılır.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @homeStartReading.
  ///
  /// In tr, this message translates to:
  /// **'Okumaya başla'**
  String get homeStartReading;

  /// Son okunan yer kayıtlıysa ana sayfadaki okuma düğmesi.
  ///
  /// In tr, this message translates to:
  /// **'Okumaya devam et'**
  String get homeContinueReading;

  /// Sure listesinde surenin ayet sayısı. countText, seçili rakam sistemiyle biçimlenmiş sayıdır.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, other{{countText} ayet}}'**
  String surahAyahCount(int count, String countText);

  /// No description provided for @readerPageTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sayfa {page}'**
  String readerPageTitle(String page);

  /// No description provided for @readerPageJuzTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sayfa {page} · Cüz {juz}'**
  String readerPageJuzTitle(String page, String juz);

  /// Ayet görünümünde okunan ayet (sure:ayet).
  ///
  /// In tr, this message translates to:
  /// **'Ayet {ayah}'**
  String readerAyahTitle(String ayah);

  /// No description provided for @readerShowPageView.
  ///
  /// In tr, this message translates to:
  /// **'Sayfa görünümü'**
  String get readerShowPageView;

  /// No description provided for @readerShowAyahView.
  ///
  /// In tr, this message translates to:
  /// **'Ayet görünümü'**
  String get readerShowAyahView;

  /// No description provided for @readerTextSmaller.
  ///
  /// In tr, this message translates to:
  /// **'Yazıyı küçült'**
  String get readerTextSmaller;

  /// No description provided for @readerTextLarger.
  ///
  /// In tr, this message translates to:
  /// **'Yazıyı büyüt'**
  String get readerTextLarger;

  /// No description provided for @readerTheme.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get readerTheme;

  /// Dokunulan kelimenin konumu (sure:ayet:kelime).
  ///
  /// In tr, this message translates to:
  /// **'Seçilen kelime: {word}'**
  String readerSelectedWord(String word);

  /// No description provided for @settingsLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get settingsLanguage;

  /// Dil seçeneği: cihazın dilini izler; desteklenmiyorsa İngilizce.
  ///
  /// In tr, this message translates to:
  /// **'Cihaz dili'**
  String get settingsLanguageSystem;

  /// Dilin kendi adı; her dilde aynı yazılır.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;

  /// Dilin kendi adı; her dilde aynı yazılır.
  ///
  /// In tr, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// Dilin kendi adı; her dilde aynı yazılır.
  ///
  /// In tr, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// NF-Y03: sayıların rakam sistemi.
  ///
  /// In tr, this message translates to:
  /// **'Rakamlar'**
  String get settingsNumerals;

  /// Arapçada Doğu Arap rakamları (٠١٢), diğer dillerde 0123.
  ///
  /// In tr, this message translates to:
  /// **'Dile göre'**
  String get settingsNumeralsAuto;

  /// No description provided for @settingsNumeralsWestern.
  ///
  /// In tr, this message translates to:
  /// **'Batı rakamları (0123)'**
  String get settingsNumeralsWestern;

  /// No description provided for @settingsNumeralsArabic.
  ///
  /// In tr, this message translates to:
  /// **'Arap rakamları (٠١٢٣)'**
  String get settingsNumeralsArabic;

  /// No description provided for @settingsTheme.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get settingsTheme;

  /// Tema seçeneği: cihaz açık moddaysa açık, koyu moddaysa koyu tema.
  ///
  /// In tr, this message translates to:
  /// **'Cihaz ayarı'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get themeLight;

  /// Krem/sepya mushaf rengi (M2-08).
  ///
  /// In tr, this message translates to:
  /// **'Sepya'**
  String get themeSepia;

  /// No description provided for @themeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get themeDark;

  /// No description provided for @errorTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bir sorun oluştu'**
  String get errorTitle;

  /// Hata durumu bileşeninin genel açıklaması (veri okunamadı).
  ///
  /// In tr, this message translates to:
  /// **'İçerik yüklenemedi.'**
  String get errorLoadContent;

  /// No description provided for @errorRetry.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dene'**
  String get errorRetry;

  /// No description provided for @settingsAbout.
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get settingsAbout;

  /// Flutter'ın lisans sayfasını açar (Kur'an fontu ve paket lisansları).
  ///
  /// In tr, this message translates to:
  /// **'Lisanslar'**
  String get settingsLicenses;

  /// No description provided for @settingsLicensesSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kur\'an fontu, metin kaynakları ve yazılım lisansları'**
  String get settingsLicensesSubtitle;

  /// Lisans sayfasının üstündeki kaynak ve atıf metni (İÇ-01). Uygulamayla dağıtılan içeriğin kaynakları; yalnızca testte kullanılan kaynaklar (Tanzil) yazılmaz.
  ///
  /// In tr, this message translates to:
  /// **'Kur\'an fontu: DigitalKhatt New Madina (SIL Open Font License 1.1).\nKur\'an metni ve sayfa düzeni kaynakları: Kral Fahd Kur\'an Basım Kompleksi (KFGQPC), Quran.com, Quranic Universal Library (Tarteel).'**
  String get aboutLegalese;

  /// Ekran okuyucu için yükleniyor göstergesinin adı (M13-03).
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor'**
  String get loading;

  /// Ekran okuyucu: sure listesindeki numara.
  ///
  /// In tr, this message translates to:
  /// **'{number}. sure'**
  String surahNumber(String number);

  /// Ekran okuyucu: mushaf sayfasının adı.
  ///
  /// In tr, this message translates to:
  /// **'Mushaf, sayfa {page}'**
  String mushafPageLabel(String page);

  /// No description provided for @tabToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get tabToday;

  /// No description provided for @tabQuran.
  ///
  /// In tr, this message translates to:
  /// **'Kur\'an'**
  String get tabQuran;

  /// No description provided for @tabMemorize.
  ///
  /// In tr, this message translates to:
  /// **'Hafızlık'**
  String get tabMemorize;

  /// Kişisel alan sekmesi (ET-1: "Ben" önerisi; hesapsız kullanımda "Profil" yanıltıcı).
  ///
  /// In tr, this message translates to:
  /// **'Ben'**
  String get tabMe;

  /// No description provided for @todayContinueButton.
  ///
  /// In tr, this message translates to:
  /// **'Devam et'**
  String get todayContinueButton;

  /// No description provided for @todayStartButton.
  ///
  /// In tr, this message translates to:
  /// **'Başla'**
  String get todayStartButton;

  /// No description provided for @todayStartDetail.
  ///
  /// In tr, this message translates to:
  /// **'Fâtiha\'dan başlayın'**
  String get todayStartDetail;

  /// Bir konumun özeti (devam et kartı).
  ///
  /// In tr, this message translates to:
  /// **'{surah} {ayah} · Sayfa {page} · Cüz {juz}'**
  String locationDetail(String surah, String ayah, String page, String juz);

  /// Sure adı ve ayet numarası (ör. "Bakara 255").
  ///
  /// In tr, this message translates to:
  /// **'{surah} {ayah}'**
  String surahAyah(String surah, String ayah);

  /// No description provided for @todayDailyAyah.
  ///
  /// In tr, this message translates to:
  /// **'Günün ayeti'**
  String get todayDailyAyah;

  /// No description provided for @todayRead.
  ///
  /// In tr, this message translates to:
  /// **'Oku'**
  String get todayRead;

  /// No description provided for @quranJumpHint.
  ///
  /// In tr, this message translates to:
  /// **'Sure:ayet (2:255) veya sayfa'**
  String get quranJumpHint;

  /// No description provided for @quranJumpInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Bulunamadı. Örnek: 2:255 veya sayfa 1–604'**
  String get quranJumpInvalid;

  /// No description provided for @quranTabSurah.
  ///
  /// In tr, this message translates to:
  /// **'Sure'**
  String get quranTabSurah;

  /// No description provided for @quranTabJuz.
  ///
  /// In tr, this message translates to:
  /// **'Cüz'**
  String get quranTabJuz;

  /// No description provided for @quranTabPage.
  ///
  /// In tr, this message translates to:
  /// **'Sayfa'**
  String get quranTabPage;

  /// No description provided for @juzTitle.
  ///
  /// In tr, this message translates to:
  /// **'{juz}. Cüz'**
  String juzTitle(String juz);

  /// No description provided for @pageAt.
  ///
  /// In tr, this message translates to:
  /// **'{location} · Sayfa {page}'**
  String pageAt(String location, String page);

  /// No description provided for @hizbStart.
  ///
  /// In tr, this message translates to:
  /// **'Hizb {hizb}'**
  String hizbStart(String hizb);

  /// fraction: ¼, ½ veya ¾ (rubu').
  ///
  /// In tr, this message translates to:
  /// **'Hizb {hizb} · {fraction}'**
  String hizbQuarter(String hizb, String fraction);

  /// No description provided for @lastRead.
  ///
  /// In tr, this message translates to:
  /// **'Son okunan: {location}'**
  String lastRead(String location);

  /// No description provided for @surahMeccan.
  ///
  /// In tr, this message translates to:
  /// **'Mekkî'**
  String get surahMeccan;

  /// No description provided for @surahMedinan.
  ///
  /// In tr, this message translates to:
  /// **'Medenî'**
  String get surahMedinan;

  /// No description provided for @memorizeSoonTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hafızlık araçları yakında'**
  String get memorizeSoonTitle;

  /// No description provided for @memorizeSoonMessage.
  ///
  /// In tr, this message translates to:
  /// **'Ayet gizleme, ezber haritası, tekrar planı ve ezber testi bu sekmede olacak. Hepsi ücretsiz ve internetsiz.'**
  String get memorizeSoonMessage;

  /// Okuma ekranındaki gezinme düğmesi (M4-07).
  ///
  /// In tr, this message translates to:
  /// **'Git'**
  String get readerGoTo;

  /// No description provided for @goToTitle.
  ///
  /// In tr, this message translates to:
  /// **'Git'**
  String get goToTitle;

  /// No description provided for @goToSurah.
  ///
  /// In tr, this message translates to:
  /// **'Sure'**
  String get goToSurah;

  /// No description provided for @goToAyah.
  ///
  /// In tr, this message translates to:
  /// **'Ayet'**
  String get goToAyah;

  /// No description provided for @goToPage.
  ///
  /// In tr, this message translates to:
  /// **'Sayfa'**
  String get goToPage;

  /// No description provided for @goToJuz.
  ///
  /// In tr, this message translates to:
  /// **'Cüz'**
  String get goToJuz;

  /// No description provided for @goToButton.
  ///
  /// In tr, this message translates to:
  /// **'Git'**
  String get goToButton;

  /// No description provided for @linkInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Bu bağlantı geçerli bir ayete veya sayfaya ait değil.'**
  String get linkInvalid;

  /// Okuma ekranında her zaman görünen konum bilgisi (M2-04).
  ///
  /// In tr, this message translates to:
  /// **'Cüz {juz} · Hizb {hizb}'**
  String readerJuzHizb(String juz, String hizb);

  /// Basılı mushafta sayfanın açılımdaki yeri (M2-04); hafızlar sayfa yerini ezberler.
  ///
  /// In tr, this message translates to:
  /// **'Sağ sayfa'**
  String get readerRightPage;

  /// No description provided for @readerLeftPage.
  ///
  /// In tr, this message translates to:
  /// **'Sol sayfa'**
  String get readerLeftPage;

  /// Secde ayeti işareti (M2-05); önünde ۩ simgesi durur.
  ///
  /// In tr, this message translates to:
  /// **'Secde'**
  String get readerSajdah;

  /// Sayfa oku (M2-09).
  ///
  /// In tr, this message translates to:
  /// **'Sonraki sayfa'**
  String get readerNextPage;

  /// No description provided for @readerPreviousPage.
  ///
  /// In tr, this message translates to:
  /// **'Önceki sayfa'**
  String get readerPreviousPage;

  /// Okuma ayarları paneli (E-10).
  ///
  /// In tr, this message translates to:
  /// **'Okuma ayarları'**
  String get readerSettings;

  /// Ekran okuyucu: okuma ekranının içerik bölgesi.
  ///
  /// In tr, this message translates to:
  /// **'Okuma alanı'**
  String get readerContent;

  /// Ekran okuyucu: içeriğe dokununca çubuklar görünür (M2-13).
  ///
  /// In tr, this message translates to:
  /// **'Menüyü göster'**
  String get readerShowControls;

  /// No description provided for @readerHideControls.
  ///
  /// In tr, this message translates to:
  /// **'Menüyü gizle'**
  String get readerHideControls;

  /// M2-11.
  ///
  /// In tr, this message translates to:
  /// **'Otomatik kaydırmayı başlat'**
  String get readerAutoScrollStart;

  /// No description provided for @readerAutoScrollStop.
  ///
  /// In tr, this message translates to:
  /// **'Otomatik kaydırmayı durdur'**
  String get readerAutoScrollStop;

  /// No description provided for @readerAutoScrollSpeed.
  ///
  /// In tr, this message translates to:
  /// **'Otomatik kaydırma hızı'**
  String get readerAutoScrollSpeed;

  /// No description provided for @readerView.
  ///
  /// In tr, this message translates to:
  /// **'Görünüm'**
  String get readerView;

  /// Mushaf sayfası görünümü (M2-01).
  ///
  /// In tr, this message translates to:
  /// **'Sayfa'**
  String get readerViewPage;

  /// Ayet ayet görünüm (M2-01).
  ///
  /// In tr, this message translates to:
  /// **'Ayet'**
  String get readerViewAyah;

  /// Ayet görünümündeki yazı boyutu (M2-07).
  ///
  /// In tr, this message translates to:
  /// **'Yazı boyutu'**
  String get readerTextSize;

  /// No description provided for @readerTextLock.
  ///
  /// In tr, this message translates to:
  /// **'Yazı boyutunu kilitle'**
  String get readerTextLock;

  /// No description provided for @readerTextLockHint.
  ///
  /// In tr, this message translates to:
  /// **'Yazı boyutu ve sayfa yakınlaştırması değişmez'**
  String get readerTextLockHint;

  /// M2-14; düzen seçimi F1-03'te gelir.
  ///
  /// In tr, this message translates to:
  /// **'Mushaf düzeni'**
  String get readerMushafLayout;

  /// Varsayılan mushaf düzeninin adı.
  ///
  /// In tr, this message translates to:
  /// **'Medine Mushafı (1421 H)'**
  String get layoutMadani1421;

  /// M2-12.
  ///
  /// In tr, this message translates to:
  /// **'Ekran açık kalsın'**
  String get readerKeepScreenOn;

  /// No description provided for @readerKeepScreenOnHint.
  ///
  /// In tr, this message translates to:
  /// **'Okurken ekran kapanmaz'**
  String get readerKeepScreenOnHint;

  /// M2-09.
  ///
  /// In tr, this message translates to:
  /// **'Sayfa okları'**
  String get readerPageArrows;

  /// No description provided for @readerPageArrowsHint.
  ///
  /// In tr, this message translates to:
  /// **'Kaydırmanın yanında sayfa çevirme düğmeleri'**
  String get readerPageArrowsHint;

  /// Yüzde; Türkçede işaret sayının önünde.
  ///
  /// In tr, this message translates to:
  /// **'%{value}'**
  String readerPercent(String value);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
