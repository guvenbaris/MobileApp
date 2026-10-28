import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../quran/domain/mushaf_page.dart';
import '../../quran/domain/quran_models.dart';
import '../application/reader_providers.dart';

/// Bir mushaf sayfasını basılı nüshadaki satır düzeniyle çizer (M2-01, M2-02).
///
/// Her satır basılı nüshadaki glif birimlerini (kelimeleri) taşır: iki yana
/// yaslı satırlarda kelimeler satıra yayılır, ortalı satırlar ortalanır. Yazı
/// boyutu, sayfanın en uzun satırı ekrana sığacak şekilde hesaplanır.
class MushafPageView extends ConsumerWidget {
  const MushafPageView({
    required this.page,
    required this.surahs,
    required this.basmala,
    required this.colors,
    super.key,
  });

  final MushafPage page;
  final Map<int, Surah> surahs;
  final String basmala;
  final MushafColors colors;

  static const _linesPerPage = 15;

  /// Basılı Medine mushafı metin alanının genişlik/yükseklik oranı (yaklaşık).
  static const _pageAspect = 0.62;

  /// Sayfanın bundan daha geniş çizilmesine izin verilmez.
  static const _maxAspect = 0.8;

  /// Ortalı satırlarda kelimeler arası boşluk (yazı boyutuna oranla).
  static const _centeredGap = 0.24;

  /// İki yana yaslı satırlarda kelimeler arasında bırakılacak en az boşluk.
  static const _minJustifiedGap = 0.15;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedWordProvider);
    // Ekran okuyucu sayfayı adıyla duyurur, ardından kelimeleri okur
    // (M13-03).
    return Semantics(
      container: true,
      label: context.l10n.mushafPageLabel(context.formatInt(page.number)),
      child: ColoredBox(
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
                final tooWide = width / height > _maxAspect;
                final scroll = tooWide && height < 500;
                if (tooWide) {
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
                            child: _buildLine(ref, line, fontSize, selected),
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
      ),
    );
  }

  Widget _buildLine(
    WidgetRef ref,
    MushafLine line,
    double fontSize,
    WordRef? selected,
  ) {
    final style = _style(fontSize);
    switch (line.type) {
      case LayoutLineType.surahName:
        return _SurahHeader(
          name: surahs[line.surah]?.nameArabic ?? '',
          colors: colors,
          fontSize: fontSize,
        );
      case LayoutLineType.basmala:
        return Center(child: Text(basmala, style: style));
      case LayoutLineType.ayah:
        return Row(
          mainAxisAlignment: line.isCentered
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceBetween,
          children: [
            for (final g in line.glyphs)
              _GlyphUnit(
                glyph: g,
                style: style,
                selected: g.words.contains(selected),
                highlight: colors.highlight,
                padding: line.isCentered
                    ? EdgeInsets.symmetric(
                        horizontal: fontSize * _centeredGap / 2,
                      )
                    : null,
                onTap: (selectedNow) => ref
                    .read(selectedWordProvider.notifier)
                    .select(selectedNow ? null : g.words.first),
              ),
          ],
        );
    }
  }

  TextStyle _style(double fontSize) => TextStyle(
    fontFamily: kQuranFontFamily,
    fontSize: fontSize,
    height: 1.5,
    wordSpacing: fontSize * kQuranWordSpacing,
    color: colors.text,
  );

  /// Hesaplanan yazı boyutları: (sayfa, genişlik, yükseklik) → boyut.
  /// Kelime seçimi gibi her yeniden çizimde ölçümün tekrarlanmasını önler.
  static final Map<String, double> _fontSizeCache = {};

  /// Her satırı ekrandaki gibi parça parça ölçer; en uzun satırın sığacağı
  /// yazı boyutunu bulur.
  double _fontSizeFor(double width, double lineHeight) {
    final key =
        '${page.layoutId}/${page.number}/'
        '${width.round()}/${lineHeight.round()}';
    final cached = _fontSizeCache[key];
    if (cached != null) return cached;

    const reference = 100.0;
    final style = _style(reference);
    var widest = 0.0;
    for (final line in page.lines) {
      if (line.type != LayoutLineType.ayah) continue;
      var total = 0.0;
      for (final g in line.glyphs) {
        final painter = TextPainter(
          text: TextSpan(text: g.digitalKhattText ?? '', style: style),
          textDirection: TextDirection.rtl,
          maxLines: 1,
        )..layout();
        total += painter.width;
        painter.dispose();
      }
      final count = line.glyphs.length;
      total +=
          reference *
          (line.isCentered
              ? _centeredGap * count
              : _minJustifiedGap * (count - 1));
      if (total > widest) widest = total;
    }
    final byHeight = lineHeight * 0.5;
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

/// Dokunulabilir glif birimi. Dokununca kapsadığı ilk kelime seçilir.
class _GlyphUnit extends StatelessWidget {
  const _GlyphUnit({
    required this.glyph,
    required this.style,
    required this.selected,
    required this.highlight,
    required this.onTap,
    this.padding,
  });

  final PageGlyph glyph;
  final TextStyle style;
  final bool selected;
  final Color highlight;
  final EdgeInsets? padding;
  final void Function(bool selectedNow) onTap;

  @override
  Widget build(BuildContext context) {
    // Ekran okuyucuda her kelime seçilebilir bir düğmedir; seçili olduğu
    // duyurulur (M13-03).
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(selected),
        child: Container(
          color: selected ? highlight : null,
          padding: padding,
          child: Text(
            glyph.digitalKhattText ?? '',
            style: style,
            softWrap: false,
            textDirection: TextDirection.rtl,
          ),
        ),
      ),
    );
  }
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
        'سُورَةُ $name', // l10n-ignore: mushaf metni
        style: TextStyle(
          fontFamily: kQuranFontFamily,
          fontSize: fontSize * 0.9,
          wordSpacing: fontSize * 0.9 * kQuranWordSpacing,
          color: colors.ornament,
        ),
      ),
    );
  }
}
