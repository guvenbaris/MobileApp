import 'package:drift/drift.dart';

import '../domain/quran_models.dart';
import '../domain/tajweed.dart';

part 'content_database.g.dart';

/// Uygulamayla gelen içerik veritabanının sürümü (M16-01).
///
/// Kaynak veri veya şema değiştiğinde artırılır; uygulama yeni sürümü
/// görünce paketteki veritabanını yeniden kopyalar. Kullanıcı verisi ayrı
/// veritabanındadır (MK-05) ve bundan etkilenmez.
const int kContentVersion = 9;

/// Paketteki veritabanının yolu (pubspec `assets` ile aynı olmalı).
const String kContentAssetPath = 'assets/db/content.sqlite';

/// `content_meta` anahtarları. İçerik veritabanında ilk dördü; düzen
/// paketinde (TK-13) `package…` anahtarları ve paketin üretildiği içeriğin
/// `wordsHash` değeri bulunur.
abstract final class ContentMetaKeys {
  static const contentVersion = 'contentVersion';
  static const source = 'source';
  static const builtAt = 'builtAt';

  /// Kelime tablosunun parmak izi (kimlik, ayet, sıra). Düzen paketleri
  /// kelimelere kimlikle bağlanır; paket ancak aynı parmak izli içerikle
  /// kullanılır.
  static const wordsHash = 'wordsHash';
  static const packageId = 'packageId';
  static const packageKind = 'packageKind';
  static const packageVersion = 'packageVersion';
}

/// Anahtar-değer; anahtarlar [ContentMetaKeys].
class ContentMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DataClassName('SurahRow')
class Surahs extends Table {
  IntColumn get id => integer()();
  TextColumn get nameArabic => text()();
  TextColumn get nameSimple => text()();
  TextColumn get nameTr => text()();
  TextColumn get nameEn => text()();
  TextColumn get revelationPlace => textEnum<RevelationPlace>()();
  IntColumn get revelationOrder => integer()();
  BoolColumn get bismillahPre => boolean()();
  IntColumn get ayahCount => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Ayetler. `id` Kur'an sırasıdır (1–6236).
@DataClassName('AyahRow')
class Ayahs extends Table {
  IntColumn get id => integer()();
  IntColumn get surah => integer().references(Surahs, #id)();
  IntColumn get ayah => integer()();
  IntColumn get juz => integer()();
  IntColumn get hizb => integer()();
  IntColumn get rub => integer()();
  IntColumn get sajdah => integer().nullable()();

  /// KFGQPC (resmi Medine 1421H) metni: esas kelime bölünmesinin kaynağı ve
  /// ekrandaki metnin referansı. Tanzil kökenli `text_uthmani` alanı
  /// içerik sürümü 7'de kaldırıldı (Faz 1 S9; Tanzil yalnızca test
  /// referansıdır, uygulamaya girmez).
  TextColumn get textQpcHafs => text()();

  /// Ekranda gösterilen metin: DigitalKhatt yazılışı (kelimeler + ayet sonu
  /// işareti). Harfleri ve durak işaretleri T-01'de KFGQPC metniyle denetlenir.
  TextColumn get textDigitalKhatt => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {surah, ayah},
  ];
}

/// Kelimeler ve ayet sonu işaretleri. `id` Kur'an sırasıdır.
///
/// Esas kelime bölünmesi KFGQPC resmi metnidir (77.430 kelime): kelimeler
/// `Ayahs.textQpcHafs` boşluklardan bölünerek elde edilir (۞ işareti kelime
/// sayılmaz). Konumlar (sure:ayet:kelime) bu bölünmeye bağlıdır.
@DataClassName('WordRow')
class Words extends Table {
  IntColumn get id => integer()();
  IntColumn get ayahId => integer().references(Ayahs, #id)();
  IntColumn get surah => integer()();
  IntColumn get ayah => integer()();

  /// Ayet içindeki sıra (1'den başlar); ayet sonu işareti son sıradadır.
  IntColumn get position => integer()();

  /// Ayet sonu (numara) işareti mi.
  BoolColumn get isAyahEnd => boolean()();

  /// KFGQPC metnindeki yazılışı.
  TextColumn get wordText => text()();

  /// Quran.com/Corpus kelime bölünmesinde karşılık gelen sıra aralığı
  /// (kelime meali ve ses verileri için). 7 yer dışında ikisi eşittir.
  IntColumn get morphFirst => integer()();
  IntColumn get morphLast => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {surah, ayah, position},
  ];
}

/// Mushaf düzenleri (M2-02, M2-14). Yeni düzen = yeni kayıt + font paketi.
@DataClassName('MushafLayoutRow')
class MushafLayouts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get pageCount => integer()();
  IntColumn get linesPerPage => integer()();

  /// Sayfanın çizildiği font (`digital_khatt`). Başka bir font paketiyle
  /// gelen düzen kendi kimliğini yazar (ör. izin alınırsa `qcf_v2`).
  TextColumn get fontPack => text()();
  IntColumn get version => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Sayfa → satır → glif aralığı eşlemesi.
@DataClassName('LayoutLineRow')
class LayoutLines extends Table {
  TextColumn get layoutId => text().references(MushafLayouts, #id)();
  IntColumn get page => integer()();
  IntColumn get line => integer()();
  TextColumn get type => textEnum<LayoutLineType>()();

  /// Sure başlığı ve besmele satırlarında hangi sureye ait olduğu.
  IntColumn get surah => integer().nullable()();

  /// Satır ortalı mı (değilse iki yana yaslı).
  BoolColumn get isCentered => boolean()();

  /// Ayet satırlarında satırdaki ilk ve son glif (`LayoutGlyphs.id`).
  IntColumn get firstGlyphId => integer().nullable()();
  IntColumn get lastGlyphId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {layoutId, page, line};
}

/// Sayfa başına ilk ve son ayet; ayet ↔ sayfa dönüşümü için (M2-15).
@DataClassName('LayoutPageRow')
class LayoutPages extends Table {
  TextColumn get layoutId => text().references(MushafLayouts, #id)();
  IntColumn get page => integer()();
  IntColumn get firstAyahId => integer()();
  IntColumn get lastAyahId => integer()();

  @override
  Set<Column> get primaryKey => {layoutId, page};
}

/// Düzenin sayfa fontundaki glif birimleri, okuma sırasıyla.
///
/// Bir glif genellikle bir kelimedir; düzenin kelime bölünmesi esas
/// bölünmeden farklıysa bir glif birden fazla kelimeyi kapsayabilir veya bir
/// kelime birden fazla glife bölünebilir. Kelimeye dokunma bu eşlemeyle
/// çözülür.
@DataClassName('LayoutGlyphRow')
class LayoutGlyphs extends Table {
  TextColumn get layoutId => text().references(MushafLayouts, #id)();
  IntColumn get id => integer()();
  IntColumn get firstWordId => integer().references(Words, #id)();
  IntColumn get lastWordId => integer().references(Words, #id)();

  /// Sayfa fontundaki (QCF V2) karakter kodu.
  TextColumn get glyph => text()();

  /// Aynı birimin DigitalKhatt yazılışı (DigitalKhatt fontuyla çizilir).
  TextColumn get digitalKhattText => text().nullable()();

  @override
  Set<Column> get primaryKey => {layoutId, id};
}

/// Renkli tecvid aralıkları (M2-06): bir düzenin glif metninde kural
/// aralıkları. Kaynak cpfair/quran-tajweed (CC BY 4.0) açıklamalarının
/// DigitalKhatt metnine eşlenmiş halidir; aynı harfe düşen kurallardan
/// öncelikli olan kalır, aralıklar örtüşmez.
@DataClassName('TajweedSpanRow')
class TajweedSpans extends Table {
  TextColumn get layoutId => text().references(MushafLayouts, #id)();
  IntColumn get glyphId => integer()();

  /// [start, end) UTF-16 konumları, `layout_glyphs.digital_khatt_text`
  /// içinde.
  IntColumn get start => integer()();
  IntColumn get end => integer()();

  /// Kural, [TajweedRule] sırasıyla (yer için sayı; sıra değişirse
  /// `kContentVersion` artırılır ve veritabanı yeniden üretilir).
  IntColumn get rule => intEnum<TajweedRule>()();

  @override
  Set<Column> get primaryKey => {layoutId, glyphId, start};

  // 72 bin satır: ayrı rowid tutulmaz, kayıt birincil anahtarda durur.
  @override
  bool get withoutRowId => true;
}

/// Salt okunur Kur'an içerik veritabanı (MK-05).
///
/// Şema değişikliği migration ile değil, `kContentVersion` artırılıp
/// veritabanı yeniden üretilerek yapılır.
@DriftDatabase(
  tables: [
    ContentMeta,
    Surahs,
    Ayahs,
    Words,
    MushafLayouts,
    LayoutLines,
    LayoutPages,
    LayoutGlyphs,
    TajweedSpans,
  ],
)
class ContentDatabase extends _$ContentDatabase {
  ContentDatabase(super.executor);

  @override
  int get schemaVersion => 1;
}
