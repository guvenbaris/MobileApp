import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/domain/quran_models.dart';
import '../../reader/application/reader_providers.dart';
import '../../user_data/application/user_data_providers.dart';

/// Şimdiki zaman; testlerde sabit bir tarihle değiştirilir.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// "Okumaya devam et" kartının bilgisi (M6-05). Kullanıcı henüz hiç
/// okumadıysa `null` (kart "Okumaya başla" olur).
class LastReadSummary {
  const LastReadSummary({
    required this.ayah,
    required this.surah,
    required this.page,
    required this.juz,
  });

  final AyahRef ayah;
  final Surah surah;
  final int page;
  final int juz;
}

final lastReadSummaryProvider = FutureProvider<LastReadSummary?>((ref) async {
  final anchor = ref.watch(readerAnchorProvider);
  final saved = ref.watch(userDataSnapshotProvider).lastRead;
  // Bu oturumda okunan yer de sayılır (çapa başlangıç değerinden değiştiyse).
  if (saved == null && anchor == const AyahRef(1, 1)) return null;

  final repo = ref.watch(quranRepositoryProvider);
  final surahs = await ref.watch(surahsProvider.future);
  final page = await repo.pageOf(kDefaultLayoutId, anchor);
  final ayah = await repo.getAyah(anchor);
  return LastReadSummary(
    ayah: anchor,
    surah: surahs.firstWhere((s) => s.id == anchor.surah),
    page: page.valueOrNull ?? 1,
    juz: ayah.valueOrNull?.juz ?? 1,
  );
});

/// Günün ayeti: tarihe göre belirlenir; aynı gün herkese aynı ayet gelir ve
/// 6.236 gün içinde her ayet bir kez seçilir (977, 6.236 ile aralarında
/// asal). Kartta taşmasın diye uzun ayetler atlanır.
///
/// Açık soru ET-2: seçilmiş bir ayet listesi veya kullanıcının favorileri
/// bu kuralın yerini alabilir (`Ekran_Tasarimi.md` §10).
final dailyAyahProvider = FutureProvider<Ayah>((ref) async {
  const step = 977;
  const maxLength = 180;
  final today = ref.watch(clockProvider)();
  final days = DateTime.utc(
    today.year,
    today.month,
    today.day,
  ).difference(DateTime.utc(2026)).inDays;

  final index = await ref.watch(ayahIndexProvider.future);
  final repo = ref.watch(quranRepositoryProvider);
  var position = (days * step) % index.length;
  Ayah? fallback;
  for (var tries = 0; tries < 50; tries++) {
    final result = await repo.getAyah(index.refAt(position));
    if (result case Ok(:final value)) {
      fallback ??= value;
      if (value.textDigitalKhatt.length <= maxLength) return value;
    }
    position = (position + 1) % index.length;
  }
  if (fallback != null) return fallback;
  throw StateError('Günün ayeti okunamadı');
});
