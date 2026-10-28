import 'package:drift/drift.dart';

import '../domain/quran_models.dart';

part 'content_database.g.dart';

/// Uygulamayla gelen içerik veritabanının sürümü (M16-01).
///
/// Kaynak veri veya şema değiştiğinde artırılır; uygulama yeni sürümü
/// görünce paketteki veritabanını yeniden kopyalar. Kullanıcı verisi ayrı
/// veritabanındadır (MK-05) ve bundan etkilenmez.
const int kContentVersion = 1;

/// Paketteki veritabanının yolu (pubspec `assets` ile aynı olmalı).
const String kContentAssetPath = 'assets/db/content.sqlite';

/// Anahtar-değer: `contentVersion`, `source`, `builtAt`.
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
  TextColumn get textUthmani => text()();
  TextColumn get textQpcHafs => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {surah, ayah},
  ];
}

/// Kelimeler ve ayet sonu işaretleri. `id` Kur'an sırasıdır.
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
  TextColumn get textUthmani => text()();

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

  /// Sayfa fontlarının paket kimliği (ör. `qcf_v2`).
  TextColumn get fontPack => text()();
  IntColumn get version => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Sayfa → satır → kelime aralığı eşlemesi.
@DataClassName('LayoutLineRow')
class LayoutLines extends Table {
  TextColumn get layoutId => text().references(MushafLayouts, #id)();
  IntColumn get page => integer()();
  IntColumn get line => integer()();
  TextColumn get type => textEnum<LayoutLineType>()();

  /// Sure başlığı ve besmele satırlarında hangi sureye ait olduğu.
  IntColumn get surah => integer().nullable()();

  /// Ayet satırlarında satırdaki ilk ve son kelime (`Words.id`).
  IntColumn get firstWordId => integer().nullable()();
  IntColumn get lastWordId => integer().nullable()();

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

/// Kelimenin o düzenin sayfa fontundaki glifi.
@DataClassName('LayoutWordGlyphRow')
class LayoutWordGlyphs extends Table {
  TextColumn get layoutId => text().references(MushafLayouts, #id)();
  IntColumn get wordId => integer().references(Words, #id)();
  TextColumn get glyph => text()();

  @override
  Set<Column> get primaryKey => {layoutId, wordId};
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
    LayoutWordGlyphs,
  ],
)
class ContentDatabase extends _$ContentDatabase {
  ContentDatabase(super.executor);

  @override
  int get schemaVersion => 1;
}
