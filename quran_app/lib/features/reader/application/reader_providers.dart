import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/diagnostics/perf_probe.dart';
import '../../../core/result/result.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/domain/mushaf_page.dart';
import '../../quran/domain/quran_models.dart';

T _unwrap<T>(Result<T> result) => switch (result) {
  Ok(:final value) => value,
  Err(:final failure) => throw failure,
};

/// Varsayılan düzendeki bir mushaf sayfası.
final mushafPageProvider = FutureProvider.family<MushafPage, int>((
  ref,
  page,
) async {
  final watch = Stopwatch()..start();
  final result = await ref
      .watch(quranRepositoryProvider)
      .getMushafPage(kDefaultLayoutId, page);
  PerfProbe.instance?.recordPageLoad(page, watch.elapsed);
  return _unwrap(result);
});

/// Sure numarası → sure; sayfa başlıklarında kullanılır.
final surahByIdProvider = FutureProvider<Map<int, Surah>>((ref) async {
  final surahs = await ref.watch(surahsProvider.future);
  return {for (final s in surahs) s.id: s};
});

/// Besmele metni (KFGQPC): Fatiha'nın 1. ayeti, ayet numarası olmadan.
final basmalaTextProvider = FutureProvider<String>((ref) async {
  final ayah = _unwrap(
    await ref.watch(quranRepositoryProvider).getAyah(const AyahRef(1, 1)),
  );
  final tokens = ayah.textQpcHafs.split(RegExp('[ \u00A0]'));
  return tokens.sublist(0, tokens.length - 1).join(' ');
});

/// Kullanıcının dokunduğu kelime (M3-03, M8-02 ön koşulu).
class SelectedWordNotifier extends Notifier<WordRef?> {
  @override
  WordRef? build() => null;

  void select(WordRef? word) => state = word;
}

final selectedWordProvider = NotifierProvider<SelectedWordNotifier, WordRef?>(
  SelectedWordNotifier.new,
);

/// Okunan konum: düzenden ve görünümden bağımsız ayet (M2-15). Sayfa
/// görünümünde sayfanın ilk ayeti, ayet görünümünde ekranın en üstündeki
/// ayettir; görünüm değişince yeni görünüm buradan açılır.
class ReaderAnchorNotifier extends Notifier<AyahRef> {
  @override
  AyahRef build() => const AyahRef(1, 1);

  void set(AyahRef ref) {
    if (ref != state) state = ref;
  }
}

final readerAnchorProvider = NotifierProvider<ReaderAnchorNotifier, AyahRef>(
  ReaderAnchorNotifier.new,
);

/// Ayetlerin Kur'an sırasındaki konumu (0–6235) ↔ sure:ayet dönüşümü.
class AyahIndex {
  AyahIndex(List<Surah> surahs) {
    var offset = 0;
    for (final s in surahs) {
      _offsets[s.id] = offset;
      _counts.add(s.ayahCount);
      offset += s.ayahCount;
    }
    length = offset;
  }

  final Map<int, int> _offsets = {};
  final List<int> _counts = [];
  late final int length;

  int indexOf(AyahRef ref) => _offsets[ref.surah]! + ref.ayah - 1;

  AyahRef refAt(int index) {
    var surah = 1;
    var rest = index;
    while (rest >= _counts[surah - 1]) {
      rest -= _counts[surah - 1];
      surah++;
    }
    return AyahRef(surah, rest + 1);
  }
}

final ayahIndexProvider = FutureProvider<AyahIndex>(
  (ref) async => AyahIndex(await ref.watch(surahsProvider.future)),
);

/// Bir surenin ayetleri (ayet görünümü için).
final surahAyahsProvider = FutureProvider.family<List<Ayah>, int>(
  (ref, surah) async =>
      _unwrap(await ref.watch(quranRepositoryProvider).getAyahsOfSurah(surah)),
);
