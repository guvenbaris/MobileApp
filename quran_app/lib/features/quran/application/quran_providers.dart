import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../data/content_database.dart';
import '../data/drift_quran_repository.dart';
import '../domain/quran_models.dart';
import '../domain/quran_repository.dart';

/// Varsayılan mushaf düzeni (Faz 0 S3).
const String kDefaultLayoutId = 'madani_1421';

/// Açılmış içerik veritabanı. Değeri `bootstrap` içinde override edilir.
final contentDatabaseProvider = Provider<ContentDatabase>(
  (ref) => throw UnimplementedError(
    'contentDatabaseProvider bootstrap içinde override edilmeli',
  ),
);

final quranRepositoryProvider = Provider<QuranRepository>(
  (ref) => DriftQuranRepository(ref.watch(contentDatabaseProvider)),
);

final surahsProvider = FutureProvider<List<Surah>>((ref) async {
  final result = await ref.watch(quranRepositoryProvider).getSurahs();
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});
