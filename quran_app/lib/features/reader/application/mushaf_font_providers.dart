import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/directory_mushaf_font_pack.dart';
import '../domain/mushaf_font_pack.dart';

final mushafFontPackProvider = Provider<MushafFontPack>(
  (ref) => DirectoryMushafFontPack(fontPackDirectory()),
);

final mushafFontPackInstalledProvider = FutureProvider<bool>(
  (ref) => ref.watch(mushafFontPackProvider).isInstalled(),
);

final pageFontFamilyProvider = FutureProvider.family<String, int>(
  (ref, page) => ref.watch(mushafFontPackProvider).loadPageFont(page),
);
