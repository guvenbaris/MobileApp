import 'package:flutter/widgets.dart';

import '../../../core/l10n/l10n.dart';
import '../domain/quran_navigation.dart';

const _fractions = ['', '¼', '½', '¾'];

extension QuarterL10n on QuarterStart {
  /// "Hizb 3" (hizb başı) veya "Hizb 3 · ½" (rubu').
  String label(BuildContext context) => quarterInHizb == 0
      ? context.l10n.hizbStart(context.formatInt(hizb))
      : context.l10n.hizbQuarter(
          context.formatInt(hizb),
          _fractions[quarterInHizb],
        );
}
