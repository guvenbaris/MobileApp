import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../quran/domain/mushaf_page.dart';
import '../../quran/domain/quran_models.dart';
import '../application/reader_providers.dart';
import '../application/reader_settings.dart';
import 'mushaf_colors.dart';

/// Tek Kur'an fontunun aile adı (pubspec `fonts`). KFGQPC lisansı
/// alınamazsa yalnızca burası ve font dosyası değişir (AK-11).
const kQuranFontFamily = 'QuranHafs';

/// Bir mushaf sayfasını basılı nüshadaki satır düzeniyle çizer (M2-01, M2-02).
///
/// Her satır basılı nüshadaki kelimeleri taşır: iki yana yaslı satırlarda
/// kelimeler satıra yayılır, ortalı satırlar ortalanır. Yazı boyutu,
/// sayfanın en uzun satırı ekrana sığacak şekilde hesaplanır.
class MushafPageView extends ConsumerWidget {
  const MushafPageView({
    required this.page,
    required this.surahs,
    required this.basmala,
    required this.renderMode,
    required this.colors,
    this.pageFontFamily,
    super.key,
  });

  final MushafPage page;
  final Map<int, Surah> surahs;
  final String basmala;
  final MushafRenderMode renderMode;
  final MushafColors colors;

  /// QCF V2 sayfa fontunun yüklenmiş aile adı ([MushafRenderMode.pageFonts]).
  final String? pageFontFamily;

  static const _linesPerPage = 15;

  /// Basılı Medine mushafı metin alanının genişlik/yükseklik oranı (yaklaşık).
  static const _pageAspect = 0.62;

  /// Sayfanın bundan daha geniş çizilmesine izin verilmez.
  static const _maxAspect = 0.8;

  bool get _useGlyphs =>
      renderMode == MushafRenderMode.pageFonts && pageFontFamily != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedWordProvider);
    return ColoredBox(
      color: colors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              var width = constraints.maxWidth;
              var height = constraints.maxHeight;
              // Ekran sayfadan çok genişse (yatay mod, M2-03): yeterince
              // yüksek ekranda (tablet) sayfa daraltılıp ortalanır; telefonda
              // sayfa genişliğe sığdırılıp dikey kaydırılır.
              final scroll = width / height > _maxAspect && height < 500;
              if (width / height > _maxAspect) {
                if (scroll) {
                  height = width / _pageAspect;
                } else {
                  width = height * _maxAspect;
                }
              }
              final lineHeight = height / _linesPerPage;
              final fontSize = _fontSizeFor(width, lineHeight);
              final content = SizedBox(
                width: width,
                height: height,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    // İlk iki sayfa kısa ve ortalıdır.
                    mainAxisAlignment: page.lines.length < _linesPerPage
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      for (final line in page.lines)
                        SizedBox(
                          height: lineHeight,
                          width: width,
                          child: _buildLine(
                            context,
                            ref,
                            line,
                            fontSize,
                            selected,
                          ),
                        ),
                    ],
                  ),
                ),
              );
              return scroll
                  ? SingleChildScrollView(child: content)
                  : Center(child: content);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLine(
    BuildContext context,
    WidgetRef ref,
    MushafLine line,
    double fontSize,
    WordRef? selected,
  ) {
    switch (line.type) {
      case LayoutLineType.surahName:
        return _SurahHeader(
          name: surahs[line.surah]?.nameArabic ?? '',
          colors: colors,
          fontSize: fontSize,
        );
      case LayoutLineType.basmala:
        return Center(child: Text(basmala, style: _unicodeStyle(fontSize)));
      case LayoutLineType.ayah:
        final pieces = _useGlyphs
            ? [
                for (final g in line.glyphs)
                  _Piece(g.glyph, g.words, g.words.contains(selected)),
              ]
            : [
                for (final w in line.words)
                  _Piece(w.text, [w.ref], w.ref == selected),
              ];
        final style = _useGlyphs
            ? TextStyle(
                fontFamily: pageFontFamily,
                fontSize: fontSize,
                color: colors.text,
              )
            : _unicodeStyle(fontSize);
        return Row(
          mainAxisAlignment: line.isCentered
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceBetween,
          children: [
            for (final p in pieces)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => ref
                    .read(selectedWordProvider.notifier)
                    .select(p.selected ? null : p.words.first),
                child: Container(
                  color: p.selected ? colors.highlight : null,
                  padding: line.isCentered
                      ? EdgeInsets.symmetric(
                          horizontal: fontSize * _centeredGap / 2,
                        )
                      : null,
                  child: Text(p.text, style: style, softWrap: false),
                ),
              ),
          ],
        );
    }
  }

  TextStyle _unicodeStyle(double fontSize) => TextStyle(
    fontFamily: kQuranFontFamily,
    fontSize: fontSize,
    height: 1.6,
    color: colors.text,
  );

  /// Ortalı satırlarda kelimeler arası boşluk (yazı boyutuna oranla).
  static const _centeredGap = 0.24;

  /// İki yana yaslı satırlarda kelimeler arasında bırakılacak en az boşluk.
  double get _minJustifiedGap => _useGlyphs ? 0.05 : 0.18;

  /// Hesaplanan yazı boyutları: (sayfa, yöntem, genişlik, yükseklik) → boyut.
  /// Kelime seçimi gibi her yeniden çizimde ölçümün tekrarlanmasını önler.
  static final Map<String, double> _fontSizeCache = {};

  /// Her satırı ekrandaki gibi parça parça ölçer; en uzun satırın sığacağı
  /// yazı boyutunu bulur.
  double _fontSizeFor(double width, double lineHeight) {
    final key =
        '${page.layoutId}/${page.number}/${_useGlyphs ? pageFontFamily : 'u'}/'
        '${width.round()}x${lineHeight.round()}';
    final cached = _fontSizeCache[key];
    if (cached != null) return cached;

    const reference = 100.0;
    final style = _useGlyphs
        ? TextStyle(fontFamily: pageFontFamily, fontSize: reference)
        : _unicodeStyle(reference);
    var widest = 0.0;
    for (final line in page.lines) {
      if (line.type != LayoutLineType.ayah) continue;
      final texts = _useGlyphs
          ? line.glyphs.map((g) => g.glyph)
          : line.words.map((w) => w.text);
      var total = 0.0;
      var count = 0;
      for (final text in texts) {
        final painter = TextPainter(
          text: TextSpan(text: text, style: style),
          textDirection: TextDirection.rtl,
          maxLines: 1,
        )..layout();
        total += painter.width;
        painter.dispose();
        count++;
      }
      total +=
          reference *
          (line.isCentered
              ? _centeredGap * count
              : _minJustifiedGap * (count - 1));
      if (total > widest) widest = total;
    }
    final byHeight = lineHeight * (_useGlyphs ? 0.62 : 0.5);
    final size = widest == 0
        ? byHeight
        : [
            reference * width * 0.99 / widest,
            byHeight,
          ].reduce((a, b) => a < b ? a : b);
    if (_fontSizeCache.length > 64) _fontSizeCache.clear();
    return _fontSizeCache[key] = size;
  }
}

class _Piece {
  const _Piece(this.text, this.words, this.selected);

  final String text;
  final List<WordRef> words;
  final bool selected;
}

/// Sure başlığı satırı. Basılı nüshadaki süslü çerçeve, sure adı fontu
/// eklenince bununla değişecek.
class _SurahHeader extends StatelessWidget {
  const _SurahHeader({
    required this.name,
    required this.colors,
    required this.fontSize,
  });

  final String name;
  final MushafColors colors;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: colors.ornament, width: 1.5),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        'سُورَةُ $name',
        style: TextStyle(
          fontFamily: kQuranFontFamily,
          fontSize: fontSize * 0.9,
          color: colors.ornament,
        ),
      ),
    );
  }
}
