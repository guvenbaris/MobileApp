import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'flavor.dart';

/// Çalışan ortam. Değeri `bootstrap` içinde override edilir.
final flavorProvider = Provider<Flavor>(
  (ref) => throw UnimplementedError(
    'flavorProvider bootstrap içinde override edilmeli',
  ),
);
