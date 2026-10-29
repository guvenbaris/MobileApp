import 'package:flutter/widgets.dart';

import '../../../core/l10n/l10n.dart';
import '../domain/mushaf_layout.dart';

extension MushafLayoutL10n on MushafLayout {
  /// Arayüz dilindeki ad: bilinen düzenler dil dosyasından, yeni paketler
  /// verideki adıyla.
  String localizedName(BuildContext context) => switch (id) {
    'madani_1421' => context.l10n.layoutMadani1421,
    'madani_1405' => context.l10n.layoutMadani1405,
    _ => name,
  };
}
