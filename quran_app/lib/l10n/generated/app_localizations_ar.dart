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
      'خط المصحف: DigitalKhatt New Madina (رخصة SIL Open Font License 1.1).\nمصادر نص القرآن وتخطيط الصفحات: مجمع الملك فهد لطباعة المصحف الشريف، Quran.com، Quranic Universal Library (Tarteel).\nبيانات التجويد الملوّن: cpfair/quran-tajweed (Colin Pfair)، رخصة المشاع الإبداعي نسب المصنف 4.0 (https://creativecommons.org/licenses/by/4.0/). عُدِّلت في هذا التطبيق لتطابق نص DigitalKhatt وجُمعت الأحكام في 7 مجموعات لونية.';

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

  @override
  String readerJuzHizb(String juz, String hizb) {
    return 'الجزء $juz · الحزب $hizb';
  }

  @override
  String get readerRightPage => 'الصفحة اليمنى';

  @override
  String get readerLeftPage => 'الصفحة اليسرى';

  @override
  String get readerSajdah => 'سجدة';

  @override
  String get readerNextPage => 'الصفحة التالية';

  @override
  String get readerPreviousPage => 'الصفحة السابقة';

  @override
  String get readerSettings => 'إعدادات القراءة';

  @override
  String get readerContent => 'منطقة القراءة';

  @override
  String get readerShowControls => 'إظهار أدوات التحكم';

  @override
  String get readerHideControls => 'إخفاء أدوات التحكم';

  @override
  String get readerAutoScrollStart => 'بدء التمرير التلقائي';

  @override
  String get readerAutoScrollStop => 'إيقاف التمرير التلقائي';

  @override
  String get readerAutoScrollSpeed => 'سرعة التمرير التلقائي';

  @override
  String get readerView => 'طريقة العرض';

  @override
  String get readerViewPage => 'صفحة';

  @override
  String get readerViewAyah => 'آية';

  @override
  String get readerTextSize => 'حجم الخط';

  @override
  String get readerTextLock => 'تثبيت حجم الخط';

  @override
  String get readerTextLockHint => 'لا يتغير حجم الخط ولا تكبير الصفحة';

  @override
  String get readerMushafLayout => 'تخطيط المصحف';

  @override
  String get layoutMadani1421 => 'مصحف المدينة النبوية (1421 هـ)';

  @override
  String get readerKeepScreenOn => 'إبقاء الشاشة مضاءة';

  @override
  String get readerKeepScreenOnHint => 'لا تنطفئ الشاشة أثناء القراءة';

  @override
  String get readerPageArrows => 'أسهم الصفحات';

  @override
  String get readerPageArrowsHint => 'أزرار لتقليب الصفحات إلى جانب السحب';

  @override
  String readerPercent(String value) {
    return '$value٪';
  }

  @override
  String get layoutMadani1405 => 'مصحف المدينة النبوية (1405 هـ)';

  @override
  String readerLayoutInfo(String pages, String lines) {
    return '$pages صفحة · $lines سطرًا';
  }

  @override
  String get readerLayoutDownloaded => 'حزمة منزّلة';

  @override
  String get readerTajweed => 'التجويد الملوّن';

  @override
  String get readerTajweedHint =>
      'تُعرض الأحكام بالألوان؛ المس الكلمة لترى اسم الحكم وشرحه';

  @override
  String get tajweedLegend => 'ألوان التجويد';

  @override
  String get tajweedSource =>
      'بيانات الأحكام: cpfair/quran-tajweed (CC BY 4.0)، مُعدَّلة لتطابق نص DigitalKhatt. الشروح موجزة؛ للتفصيل راجع معلّمًا.';

  @override
  String get tajweedAllColors => 'كل الألوان';

  @override
  String get tajweedGroupSilent => 'حروف لا تُنطق';

  @override
  String get tajweedGroupMaddNatural => 'المد الطبيعي';

  @override
  String get tajweedGroupMaddPermissible => 'المدود الجائزة';

  @override
  String get tajweedGroupMaddObligatory => 'المد الواجب واللازم';

  @override
  String get tajweedGroupGhunnah => 'الغنة والإخفاء';

  @override
  String get tajweedGroupIdghaam => 'الإدغام بلا غنة';

  @override
  String get tajweedGroupQalqalah => 'القلقلة';

  @override
  String get tajweedHamzatWasl => 'همزة الوصل';

  @override
  String get tajweedHamzatWaslInfo =>
      'همزة في أول الكلمة تسقط في الوصل وتُنطق عند الابتداء بالكلمة.';

  @override
  String get tajweedLamShamsiyyah => 'اللام الشمسية';

  @override
  String get tajweedLamShamsiyyahInfo =>
      'لام التعريف لا تُنطق قبل الحروف الشمسية، ويُشدَّد الحرف الذي بعدها.';

  @override
  String get tajweedSilent => 'حرف لا يُنطق';

  @override
  String get tajweedSilentInfo => 'حرف مكتوب لا يُنطق.';

  @override
  String get tajweedMadd2 => 'المد الطبيعي';

  @override
  String get tajweedMadd2Info =>
      'يُمدّ حرف المد حركتين إذا لم يأتِ بعده همز ولا سكون.';

  @override
  String get tajweedMadd246 => 'المد العارض واللين';

  @override
  String get tajweedMadd246Info =>
      'يُسكَّن ما بعد حرف المد أو اللين للوقف، فيجوز مدّه حركتين أو أربعًا أو ستًّا.';

  @override
  String get tajweedMaddMunfasil => 'المد المنفصل';

  @override
  String get tajweedMaddMunfasilInfo =>
      'حرف المد في آخر كلمة والهمز في أول التي تليها؛ مدّه جائز ويختلف مقداره بحسب الطريق.';

  @override
  String get tajweedMaddMuttasil => 'المد المتصل';

  @override
  String get tajweedMaddMuttasilInfo =>
      'حرف المد والهمز في كلمة واحدة؛ مدّه واجب (أربع أو خمس حركات).';

  @override
  String get tajweedMadd6 => 'المد اللازم';

  @override
  String get tajweedMadd6Info =>
      'يأتي بعد حرف المد سكون أصلي أو حرف مشدد؛ يُمدّ ست حركات.';

  @override
  String get tajweedGhunnah => 'الغنة';

  @override
  String get tajweedGhunnahInfo =>
      'الميم والنون المشددتان تُنطقان بغنة من الخيشوم مقدار حركتين.';

  @override
  String get tajweedIkhfa => 'الإخفاء';

  @override
  String get tajweedIkhfaInfo =>
      'إذا جاء بعد النون الساكنة أو التنوين أحد حروف الإخفاء أُخفيت النون مع الغنة.';

  @override
  String get tajweedIkhfaShafawi => 'الإخفاء الشفوي';

  @override
  String get tajweedIkhfaShafawiInfo =>
      'إذا جاء بعد الميم الساكنة باء أُخفيت الميم مع الغنة.';

  @override
  String get tajweedIdghaamGhunnah => 'الإدغام بغنة';

  @override
  String get tajweedIdghaamGhunnahInfo =>
      'إذا جاء بعد النون الساكنة أو التنوين أحد حروف «ينمو» أُدغمت النون فيه بغنة.';

  @override
  String get tajweedIdghaamShafawi => 'الإدغام الشفوي';

  @override
  String get tajweedIdghaamShafawiInfo =>
      'إذا جاء بعد الميم الساكنة ميم أُدغمتا بغنة.';

  @override
  String get tajweedIqlab => 'الإقلاب';

  @override
  String get tajweedIqlabInfo =>
      'إذا جاء بعد النون الساكنة أو التنوين باء قُلبت النون ميمًا مع الغنة.';

  @override
  String get tajweedIdghaamNoGhunnah => 'الإدغام بلا غنة';

  @override
  String get tajweedIdghaamNoGhunnahInfo =>
      'إذا جاء بعد النون الساكنة أو التنوين لام أو راء أُدغمت النون فيهما بلا غنة.';

  @override
  String get tajweedIdghaamMutajanisayn => 'إدغام المتجانسين';

  @override
  String get tajweedIdghaamMutajanisaynInfo =>
      'حرفان اتحدا مخرجًا واختلفا صفةً، سكن أولهما فأُدغم في الثاني.';

  @override
  String get tajweedIdghaamMutaqaribayn => 'إدغام المتقاربين';

  @override
  String get tajweedIdghaamMutaqaribaynInfo =>
      'حرفان تقاربا مخرجًا وصفةً، سكن أولهما فأُدغم في الثاني.';

  @override
  String get tajweedQalqalah => 'القلقلة';

  @override
  String get tajweedQalqalahInfo =>
      'حروف «قطب جد» إذا سكنت نُطقت بنبرة مهتزّة خفيفة.';
}
