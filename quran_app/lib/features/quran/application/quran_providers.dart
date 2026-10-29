import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../data/content_database.dart';
import '../data/drift_quran_repository.dart';
import '../domain/quran_models.dart';
import '../domain/quran_navigation.dart';
import '../domain/quran_repository.dart';
import 'layout_providers.dart';

/// Açılmış içerik veritabanı. Değeri `bootstrap` içinde override edilir.
final contentDatabaseProvider = Provider<ContentDatabase>(
  (ref) => throw UnimplementedError(
    'contentDatabaseProvider bootstrap içinde override edilmeli',
  ),
);

final quranRepositoryProvider = Provider<QuranRepository>(
  (ref) => DriftQuranRepository(
    ref.watch(contentDatabaseProvider),
    layoutDatabases: ref.watch(layoutCatalogProvider).databases,
  ),
);

final surahsProvider = FutureProvider<List<Surah>>((ref) async {
  final result = await ref.watch(quranRepositoryProvider).getSurahs();
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

/// Sure → ayet sayısı (atlama girdisinin denetimi için).
final ayahCountsProvider = FutureProvider<Map<int, int>>((ref) async {
  final surahs = await ref.watch(surahsProvider.future);
  return {for (final s in surahs) s.id: s.ayahCount};
});

/// 240 rubu' başlangıcı, okunan düzenin sayfalarıyla; cüz dizini bundan
/// türetilir (M4-01).
final quarterStartsProvider = FutureProvider<List<QuarterStart>>((ref) async {
  final result = await ref
      .watch(quranRepositoryProvider)
      .quarterStarts(ref.watch(currentLayoutProvider).id);
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});
