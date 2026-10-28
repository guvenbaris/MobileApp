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

  @override
  String get tabToday => 'اليوم';

  @override
  String get tabQuran => 'القرآن';

  @override
  String get tabMemorize => 'الحفظ';

  @override
  String get tabMe => 'أنا';

  @override
  String get todayContinueButton => 'تابع';

  @override
  String get todayStartButton => 'ابدأ';

  @override
  String get todayStartDetail => 'ابدأ بسورة الفاتحة';

  @override
  String locationDetail(String surah, String ayah, String page, String juz) {
    return '$surah $ayah · الصفحة $page · الجزء $juz';
  }

  @override
  String surahAyah(String surah, String ayah) {
    return '$surah $ayah';
  }

  @override
  String get todayDailyAyah => 'آية اليوم';

  @override
  String get todayRead => 'اقرأ';

  @override
  String get quranJumpHint => 'سورة:آية (2:255) أو صفحة';

  @override
  String get quranJumpInvalid => 'لم يُعثر عليه. مثال: 2:255 أو صفحة 1–604';

  @override
  String get quranTabSurah => 'السور';

  @override
  String get quranTabJuz => 'الأجزاء';

  @override
  String get quranTabPage => 'الصفحات';

  @override
  String juzTitle(String juz) {
    return 'الجزء $juz';
  }

  @override
  String pageAt(String location, String page) {
    return '$location · الصفحة $page';
  }

  @override
  String hizbStart(String hizb) {
    return 'الحزب $hizb';
  }

  @override
  String hizbQuarter(String hizb, String fraction) {
    return 'الحزب $hizb · $fraction';
  }

  @override
  String lastRead(String location) {
    return 'آخر قراءة: $location';
  }

  @override
  String get surahMeccan => 'مكية';

  @override
  String get surahMedinan => 'مدنية';

  @override
  String get memorizeSoonTitle => 'أدوات الحفظ قادمة قريبًا';

  @override
  String get memorizeSoonMessage =>
      'إخفاء الآيات وخريطة الحفظ وخطة المراجعة واختبار الحفظ ستكون هنا. كلها مجانية وتعمل دون إنترنت.';

  @override
  String get readerGoTo => 'انتقال';

  @override
  String get goToTitle => 'الانتقال إلى';

  @override
  String get goToSurah => 'السورة';

  @override
  String get goToAyah => 'الآية';

  @override
  String get goToPage => 'الصفحة';

  @override
  String get goToJuz => 'الجزء';

  @override
  String get goToButton => 'انتقل';

  @override
  String get linkInvalid => 'هذا الرابط لا يشير إلى آية أو صفحة صحيحة.';
}
