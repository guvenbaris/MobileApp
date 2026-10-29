import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/diagnostics/perf_probe.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/result/result.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/domain/mushaf_page.dart';
import '../../quran/domain/quran_models.dart';
import '../../quran/domain/quran_navigation.dart';
import '../../user_data/application/user_data_providers.dart';
import '../../user_data/domain/user_data_repositories.dart';

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

/// Besmele (DigitalKhatt yazılışı): Fatiha 1. ayetin ilk dört glif birimi,
/// ayet numarası olmadan.
final basmalaTextProvider = FutureProvider<String>((ref) async {
  final page = await ref.watch(mushafPageProvider(1).future);
  final glyphs = page.lines.expand((l) => l.glyphs).take(4);
  return glyphs.map((g) => g.digitalKhattText ?? '').join(' ');
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
///
/// Son okunan yer olarak kalıcıdır: değişiklik kısa bir beklemeden sonra
/// yazılır (ayet görünümünde her kaydırma karesinde yazmamak için).
class ReaderAnchorNotifier extends Notifier<AyahRef> {
  static const _saveDelay = Duration(milliseconds: 800);

  Timer? _saveTimer;
  Future<void> Function()? _pendingSave;

  @override
  AyahRef build() {
    ref.onDispose(_flush);
    return ref.read(userDataSnapshotProvider).lastRead ?? const AyahRef(1, 1);
  }

  void set(AyahRef position) {
    if (position == state) return;
    state = position;
    // Kayıt işi şimdi hazırlanır: gecikmeli çalışırken `ref` kullanılmaz
    // (sağlayıcı o arada kapanmış olabilir).
    final save = _savePositionLater(position);
    if (save == null) return;
    _pendingSave = save;
    _saveTimer?.cancel();
    _saveTimer = Timer(_saveDelay, _flush);
  }

  /// Kullanıcı veritabanı yoksa (ör. testler) null döner; kayıt atlanır.
  Future<void> Function()? _savePositionLater(AyahRef position) {
    final ReadingPositionRepository repository;
    final AppLogger logger;
    try {
      repository = ref.read(readingPositionRepositoryProvider);
      logger = ref.read(appLoggerProvider);
    } on Object {
      return null;
    }
    return () => repository
        .save(ReadingPositionKind.lastRead, position)
        .catchError((Object e, StackTrace st) {
          logger.error(
            'Son okunan yer kaydedilemedi',
            error: e,
            stackTrace: st,
          );
        });
  }

  void _flush() {
    _saveTimer?.cancel();
    _saveTimer = null;
    final save = _pendingSave;
    _pendingSave = null;
    save?.call().ignore();
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

/// Okunan ayetin cüz, hizb ve sayfası: ayet görünümünde her zaman görünen
/// bilgi satırı için (M2-04).
class AyahLocation {
  const AyahLocation({
    required this.juz,
    required this.hizb,
    required this.page,
  });

  final int juz;
  final int hizb;
  final int page;
}

final anchorLocationProvider = FutureProvider<AyahLocation>((ref) async {
  final anchor = ref.watch(readerAnchorProvider);
  final repo = ref.watch(quranRepositoryProvider);
  final ayah = _unwrap(await repo.getAyah(anchor));
  final page = _unwrap(await repo.pageOf(kDefaultLayoutId, anchor));
  return AyahLocation(juz: ayah.juz, hizb: ayah.hizb, page: page);
});

/// Rubu' başı olan ayetler (ayet görünümünde ۞ işareti, M2-05).
final quarterStartByAyahProvider = FutureProvider<Map<AyahRef, QuarterStart>>(
  (ref) async => {
    for (final q in await ref.watch(quarterStartsProvider.future)) q.start: q,
  },
);
