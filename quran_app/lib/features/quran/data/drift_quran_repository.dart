import 'package:drift/drift.dart';

import '../../../core/result/result.dart';
import '../domain/mushaf_layout.dart';
import '../domain/mushaf_page.dart';
import '../domain/quran_models.dart';
import '../domain/quran_navigation.dart';
import '../domain/quran_repository.dart';
import 'content_database.dart';

/// İçerik veritabanından okuyan depo. Uygulamayla gelen düzen içerik
/// veritabanındadır; kurulu düzen paketleri (TK-13) ayrı veritabanlarıdır ve
/// [layoutDatabases] ile verilir. Paketler yalnızca düzen tablolarını taşır;
/// metin, kelime ve ayetler her zaman içerik veritabanından okunur.
class DriftQuranRepository implements QuranRepository {
  const DriftQuranRepository(
    this._db, {
    Map<String, ContentDatabase> layoutDatabases = const {},
  }) : _layoutDbs = layoutDatabases;

  final ContentDatabase _db;
  final Map<String, ContentDatabase> _layoutDbs;

  /// Düzen tablolarının bulunduğu veritabanı.
  ContentDatabase _layoutDb(String layoutId) => _layoutDbs[layoutId] ?? _db;

  @override
  Future<Result<List<MushafLayout>>> getLayouts() => _guard(() async {
    final layouts = [
      for (final row in await _db.select(_db.mushafLayouts).get())
        _toLayout(row, isBuiltIn: true),
      for (final MapEntry(key: id, value: db) in _layoutDbs.entries)
        for (final row in await (db.select(
          db.mushafLayouts,
        )..where((l) => l.id.equals(id))).get())
          _toLayout(row, isBuiltIn: false),
    ];
    return Ok(layouts);
  });

  @override
  Future<Result<List<Surah>>> getSurahs() => _guard(() async {
    final rows = await (_db.select(
      _db.surahs,
    )..orderBy([(s) => OrderingTerm(expression: s.id)])).get();
    return Ok(rows.map(_toSurah).toList());
  });

  @override
  Future<Result<Ayah>> getAyah(AyahRef ref) => _guard(() async {
    final row =
        await (_db.select(_db.ayahs)..where(
              (a) => a.surah.equals(ref.surah) & a.ayah.equals(ref.ayah),
            ))
            .getSingleOrNull();
    return row == null
        ? Err(NotFoundFailure('Ayet yok: $ref'))
        : Ok(_toAyah(row));
  });

  @override
  Future<Result<List<Ayah>>> getAyahsOfSurah(int surah) => _guard(() async {
    final rows =
        await (_db.select(_db.ayahs)
              ..where((a) => a.surah.equals(surah))
              ..orderBy([(a) => OrderingTerm(expression: a.ayah)]))
            .get();
    return rows.isEmpty
        ? Err(NotFoundFailure('Sure yok: $surah'))
        : Ok(rows.map(_toAyah).toList());
  });

  @override
  Future<Result<int>> pageOf(String layoutId, AyahRef ref) => _guard(() async {
    final ayah =
        await (_db.select(_db.ayahs)..where(
              (a) => a.surah.equals(ref.surah) & a.ayah.equals(ref.ayah),
            ))
            .getSingleOrNull();
    if (ayah == null) return Err(NotFoundFailure('Ayet yok: $ref'));

    // Birden fazla sayfaya yayılan ayet, başladığı sayfaya aittir.
    final ldb = _layoutDb(layoutId);
    final page =
        await (ldb.select(ldb.layoutPages)
              ..where(
                (p) =>
                    p.layoutId.equals(layoutId) &
                    p.firstAyahId.isSmallerOrEqualValue(ayah.id) &
                    p.lastAyahId.isBiggerOrEqualValue(ayah.id),
              )
              ..orderBy([(p) => OrderingTerm(expression: p.page)])
              ..limit(1))
            .getSingleOrNull();
    return page == null
        ? Err(NotFoundFailure('Düzen yok: $layoutId'))
        : Ok(page.page);
  });

  @override
  Future<Result<AyahRef>> firstAyahOfPage(String layoutId, int page) =>
      _guard(() async {
        final ldb = _layoutDb(layoutId);
        final range =
            await (ldb.select(ldb.layoutPages)..where(
                  (p) => p.layoutId.equals(layoutId) & p.page.equals(page),
                ))
                .getSingleOrNull();
        if (range == null) return Err(NotFoundFailure('Sayfa yok: $page'));
        final ayah = await (_db.select(
          _db.ayahs,
        )..where((a) => a.id.equals(range.firstAyahId))).getSingle();
        return Ok(AyahRef(ayah.surah, ayah.ayah));
      });

  @override
  Future<Result<MushafPage>> getMushafPage(
    String layoutId,
    int page,
  ) => _guard(() async {
    final ldb = _layoutDb(layoutId);
    final lines =
        await (ldb.select(ldb.layoutLines)
              ..where((l) => l.layoutId.equals(layoutId) & l.page.equals(page))
              ..orderBy([(l) => OrderingTerm(expression: l.line)]))
            .get();
    final range =
        await (ldb.select(ldb.layoutPages)
              ..where((p) => p.layoutId.equals(layoutId) & p.page.equals(page)))
            .getSingleOrNull();
    if (lines.isEmpty || range == null) {
      return Err(NotFoundFailure('Sayfa yok: $layoutId/$page'));
    }

    final ayahLines = lines.where((l) => l.firstGlyphId != null);
    final firstGlyph = ayahLines.first.firstGlyphId!;
    final lastGlyph = ayahLines.last.lastGlyphId!;
    final glyphs =
        await (ldb.select(ldb.layoutGlyphs)
              ..where(
                (g) =>
                    g.layoutId.equals(layoutId) &
                    g.id.isBetweenValues(firstGlyph, lastGlyph),
              )
              ..orderBy([(g) => OrderingTerm(expression: g.id)]))
            .get();
    final words = {
      for (final w
          in await (_db.select(_db.words)..where(
                (w) => w.id.isBetweenValues(
                  glyphs.first.firstWordId,
                  glyphs.last.lastWordId,
                ),
              ))
              .get())
        w.id: w,
    };
    final layout = await (ldb.select(
      ldb.mushafLayouts,
    )..where((l) => l.id.equals(layoutId))).getSingle();
    final firstAyah = await (_db.select(
      _db.ayahs,
    )..where((a) => a.id.equals(range.firstAyahId))).getSingle();

    WordRef ref(WordRow w) => WordRef(w.surah, w.ayah, w.position);
    final glyphById = {for (final g in glyphs) g.id: g};
    // Sayfada başlayan ayetler: ilk kelimesi bu sayfada olanlar. Önceki
    // sayfadan taşan ayet başladığı sayfaya aittir (pageOf ile aynı kural).
    final startIds = {
      for (final w in words.values)
        if (w.position == 1) w.ayahId,
    };
    // Başlayan ayetler ve her birinin bir öncekisi: rubu' değişen ayet
    // rubu' başıdır. Secde ve rubu' bilgisi tek sorguda.
    final rows = {
      for (final a
          in await (_db.select(_db.ayahs)..where(
                (a) =>
                    a.id.isIn({...startIds, for (final id in startIds) id - 1}),
              ))
              .get())
        a.id: a,
    };
    final starts = [for (final id in startIds.toList()..sort()) rows[id]!];
    return Ok(
      MushafPage(
        layoutId: layoutId,
        number: page,
        firstAyah: AyahRef(firstAyah.surah, firstAyah.ayah),
        juz: firstAyah.juz,
        hizb: firstAyah.hizb,
        linesPerPage: layout.linesPerPage,
        sajdahAyahs: [
          for (final a in starts)
            if (a.sajdah != null) AyahRef(a.surah, a.ayah),
        ],
        quarterStarts: [
          for (final a in starts)
            if (rows[a.id - 1]?.rub != a.rub)
              QuarterStart(
                juz: a.juz,
                hizb: a.hizb,
                rub: a.rub,
                start: AyahRef(a.surah, a.ayah),
                page: page,
              ),
        ],
        lines: [
          for (final l in lines)
            if (l.firstGlyphId == null)
              MushafLine(
                number: l.line,
                type: l.type,
                isCentered: l.isCentered,
                surah: l.surah,
                words: const [],
                glyphs: const [],
              )
            else
              _ayahLine(l, glyphById, words, ref),
        ],
      ),
    );
  });

  /// Ayet satırı: glifler ve kapsadıkları kelimeler, okuma sırasıyla.
  static MushafLine _ayahLine(
    LayoutLineRow line,
    Map<int, LayoutGlyphRow> glyphById,
    Map<int, WordRow> words,
    WordRef Function(WordRow) ref,
  ) {
    final glyphs = <PageGlyph>[];
    final lineWords = <PageWord>[];
    for (var id = line.firstGlyphId!; id <= line.lastGlyphId!; id++) {
      final g = glyphById[id]!;
      final covered = [
        for (var w = g.firstWordId; w <= g.lastWordId; w++) words[w]!,
      ];
      glyphs.add(
        PageGlyph(
          glyph: g.glyph,
          words: covered.map(ref).toList(),
          digitalKhattText: g.digitalKhattText,
        ),
      );
      for (final w in covered) {
        // Birden fazla glife bölünen kelime bir kez eklenir.
        if (lineWords.isEmpty || lineWords.last.ref != ref(w)) {
          lineWords.add(
            PageWord(ref: ref(w), text: w.wordText, isAyahEnd: w.isAyahEnd),
          );
        }
      }
    }
    return MushafLine(
      number: line.line,
      type: line.type,
      isCentered: line.isCentered,
      words: lineWords,
      glyphs: glyphs,
    );
  }

  @override
  Future<Result<List<QuarterStart>>> quarterStarts(String layoutId) => _guard(
    () async {
      // Her rubu'un ilk ayeti (içerik) ve o ayetin başladığı sayfa
      // (düzen; paketteyse ayrı veritabanı).
      final rows = await _db
          .customSelect(
            'SELECT id, juz, hizb, rub, surah, ayah FROM ayahs '
            'WHERE id IN (SELECT MIN(id) FROM ayahs GROUP BY rub) '
            'ORDER BY rub',
            readsFrom: {_db.ayahs},
          )
          .get();
      final ldb = _layoutDb(layoutId);
      final pages =
          await (ldb.select(ldb.layoutPages)
                ..where((p) => p.layoutId.equals(layoutId))
                ..orderBy([(p) => OrderingTerm(expression: p.page)]))
              .get();
      if (pages.isEmpty) return Err(NotFoundFailure('Düzen yok: $layoutId'));
      // Ayet, aralığına giren ilk sayfaya aittir (pageOf ile aynı kural).
      int pageOf(int ayahId) => pages
          .firstWhere((p) => p.firstAyahId <= ayahId && p.lastAyahId >= ayahId)
          .page;
      return Ok([
        for (final r in rows)
          QuarterStart(
            juz: r.read<int>('juz'),
            hizb: r.read<int>('hizb'),
            rub: r.read<int>('rub'),
            start: AyahRef(r.read<int>('surah'), r.read<int>('ayah')),
            page: pageOf(r.read<int>('id')),
          ),
      ]);
    },
  );

  Future<Result<T>> _guard<T>(Future<Result<T>> Function() body) async {
    try {
      return await body();
    } on Exception catch (e, st) {
      return Err(
        UnexpectedFailure('İçerik okunamadı', error: e, stackTrace: st),
      );
    }
  }

  static Surah _toSurah(SurahRow r) => Surah(
    id: r.id,
    nameArabic: r.nameArabic,
    nameTr: r.nameTr,
    nameEn: r.nameEn,
    nameSimple: r.nameSimple,
    revelationPlace: r.revelationPlace,
    revelationOrder: r.revelationOrder,
    bismillahPre: r.bismillahPre,
    ayahCount: r.ayahCount,
  );

  static MushafLayout _toLayout(MushafLayoutRow r, {required bool isBuiltIn}) =>
      MushafLayout(
        id: r.id,
        name: r.name,
        pageCount: r.pageCount,
        linesPerPage: r.linesPerPage,
        fontPack: r.fontPack,
        version: r.version,
        isBuiltIn: isBuiltIn,
      );

  static Ayah _toAyah(AyahRow r) => Ayah(
    ref: AyahRef(r.surah, r.ayah),
    juz: r.juz,
    hizb: r.hizb,
    rub: r.rub,
    sajdah: r.sajdah,
    textQpcHafs: r.textQpcHafs,
    textDigitalKhatt: r.textDigitalKhatt,
  );
}
