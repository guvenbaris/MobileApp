import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../quran/domain/mushaf_page.dart';
import '../../quran/domain/quran_models.dart';
import '../../quran/presentation/quarter_l10n.dart';
import '../../quran/presentation/surah_l10n.dart';
import 'mushaf_mark.dart';

/// Mushaf sayfasının çevresi, basılı nüshadaki gibi: üstte sure adı, cüz ve
/// hizb; altta rubu' ve secde işaretleri, sayfa numarası ve sağ/sol sayfa.
/// Çubuklar gizliyken de görünür (M2-04, M2-05).
class MushafPageFrame extends StatelessWidget {
  const MushafPageFrame({
    required this.page,
    required this.surahs,
    required this.colors,
    required this.child,
    this.footerSideInset = 0,
    super.key,
  });

  final MushafPage page;
  final Map<int, Surah> surahs;
  final MushafColors colors;
  final Widget child;

  /// Sayfa okları açıkken alt satırın iki yanında oklara bırakılan boşluk.
  final double footerSideInset;

  static const _barHeight = 28.0;

  /// Basılı mushafta tek numaralı sayfa sağda, çift numaralı solda durur.
  static bool isRightPage(int page) => page.isOdd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final style = Theme.of(context).textTheme.labelMedium
        ?.copyWith(color: colors.ornament);
    final surah = surahs[page.firstAyah.surah]?.localizedName(context) ?? '';
    final marks = [
      for (final q in page.quarterStarts)
        (MushafMark.quarter, q.label(context)),
      if (page.sajdahAyahs.isNotEmpty) (MushafMark.sajdah, l10n.readerSajdah),
    ];
    final pageText = context.formatInt(page.number);

    Widget fitted(String text, AlignmentDirectional alignment, {Key? key}) =>
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: alignment,
          child: Text(text, key: key, style: style, maxLines: 1),
        );
    final marksKey = Key('reader.pageMarks.${page.number}');

    return Column(
      children: [
        SizedBox(
          height: _barHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: fitted(surah, AlignmentDirectional.centerStart),
                ),
                fitted(
                  l10n.readerJuzHizb(
                    context.formatInt(page.juz),
                    context.formatInt(page.hizb),
                  ),
                  AlignmentDirectional.centerEnd,
                  key: Key('reader.pageHeader.${page.number}'),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: child),
        SizedBox(
          key: Key('reader.pageFooter.${page.number}'),
          height: footerSideInset > 0 ? AppSpacing.minTapTarget : _barHeight,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md + footerSideInset,
            ),
            child: Row(
              children: [
                Expanded(
                  child: marks.isEmpty
                      ? SizedBox(key: marksKey)
                      : FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: MushafMarkText(
                            marks,
                            key: marksKey,
                            style: style,
                          ),
                        ),
                ),
                Semantics(
                  label: l10n.readerPageTitle(pageText),
                  child: ExcludeSemantics(child: Text(pageText, style: style)),
                ),
                Expanded(
                  child: fitted(
                    isRightPage(page.number)
                        ? l10n.readerRightPage
                        : l10n.readerLeftPage,
                    AlignmentDirectional.centerEnd,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
