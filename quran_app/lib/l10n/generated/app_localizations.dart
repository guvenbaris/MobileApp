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

  /// No description provided for @homeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get homeTitle;

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
