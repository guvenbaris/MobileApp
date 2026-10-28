// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'القرآن';

  @override
  String get homeTitle => 'الرئيسية';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get homeStartReading => 'ابدأ القراءة';

  @override
  String get homeContinueReading => 'تابع القراءة';

  @override
  String surahAyahCount(int count, String countText) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countText آية',
      few: '$countText آيات',
      two: 'آيتان',
      one: 'آية واحدة',
    );
    return '$_temp0';
  }

  @override
  String readerPageTitle(String page) {
    return 'الصفحة $page';
  }

  @override
  String readerPageJuzTitle(String page, String juz) {
    return 'الصفحة $page · الجزء $juz';
  }

  @override
  String readerAyahTitle(String ayah) {
    return 'الآية $ayah';
  }

  @override
  String get readerShowPageView => 'عرض الصفحة';

  @override
  String get readerShowAyahView => 'عرض الآيات';

  @override
  String get readerTextSmaller => 'تصغير الخط';

  @override
  String get readerTextLarger => 'تكبير الخط';

  @override
  String get readerTheme => 'السمة';

  @override
  String readerSelectedWord(String word) {
    return 'الكلمة المحددة: $word';
  }

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsLanguageSystem => 'لغة الجهاز';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsNumerals => 'الأرقام';

  @override
  String get settingsNumeralsAuto => 'حسب اللغة';

  @override
  String get settingsNumeralsWestern => 'أرقام غربية (0123)';

  @override
  String get settingsNumeralsArabic => 'أرقام عربية (٠١٢٣)';

  @override
  String get settingsTheme => 'السمة';

  @override
  String get themeSystem => 'حسب إعداد الجهاز';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeSepia => 'بني فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get errorTitle => 'حدث خطأ ما';

  @override
  String get errorLoadContent => 'تعذّر تحميل المحتوى.';

  @override
  String get errorRetry => 'إعادة المحاولة';

  @override
  String get settingsAbout => 'حول التطبيق';

  @override
  String get settingsLicenses => 'التراخيص';

  @override
  String get settingsLicensesSubtitle =>
      'خط المصحف ومصادر النص وتراخيص البرمجيات';

  @override
  String get aboutLegalese =>
      'خط المصحف: DigitalKhatt New Madina (رخصة SIL Open Font License 1.1).\nمصادر نص القرآن وتخطيط الصفحات: مجمع الملك فهد لطباعة المصحف الشريف، Quran.com، Quranic Universal Library (Tarteel).';

  @override
  String get loading => 'جارٍ التحميل';

  @override
  String surahNumber(String number) {
    return 'السورة $number';
  }

  @override
  String mushafPageLabel(String page) {
    return 'المصحف، الصفحة $page';
  }
}
