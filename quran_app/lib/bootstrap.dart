import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/config/flavor.dart';

/// Tüm giriş noktalarının ortak başlangıcı.
void bootstrap(Flavor flavor) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(QuranApp(flavor: flavor));
}
