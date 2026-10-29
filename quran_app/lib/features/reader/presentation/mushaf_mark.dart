import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Mushaf işaretleri (M2-05): rubu' başı ve secde.
enum MushafMark {
  quarter('۞'),
  sajdah('۩');

  const MushafMark(this.symbol);

  final String symbol;
}

/// İşaret simgesi ve yanında arayüz dilindeki açıklaması. Simge Kur'an
/// fontuyla çizilir: arayüz fontlarında bulunmayabilir.
class MushafMarkText extends StatelessWidget {
  const MushafMarkText(this.marks, {required this.style, super.key});

  /// İşaret ve açıklaması, sırayla.
  final List<(MushafMark, String)> marks;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      children: [
        for (final (i, (mark, label)) in marks.indexed) ...[
          if (i > 0) const TextSpan(text: '   '),
          TextSpan(
            text: mark.symbol,
            style: const TextStyle(fontFamily: kQuranFontFamily),
          ),
          TextSpan(text: ' $label'),
        ],
      ],
    ),
    style: style,
    maxLines: 1,
  );
}
