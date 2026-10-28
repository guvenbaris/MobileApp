import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/app_list_item.dart';
import '../../../core/widgets/state_views.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/domain/quran_models.dart';
import '../../quran/presentation/surah_l10n.dart';
import '../../reader/application/reader_providers.dart';
import '../../user_data/application/user_data_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahs = ref.watch(surahsProvider);
    final l10n = context.l10n;
    final arabicUi = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          IconButton(
            key: const Key('home.settings'),
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settingsTitle,
            onPressed: () => context.go(AppRoutes.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('home.read'),
        onPressed: () => _openAt(context, ref, ref.read(readerAnchorProvider)),
        // Son okunan yer varsa oradan devam edilir (M6).
        label: Text(
          ref.watch(userDataSnapshotProvider).lastRead == null
              ? l10n.homeStartReading
              : l10n.homeContinueReading,
        ),
      ),
      body: switch (surahs) {
        AsyncData(:final value) => ListView.builder(
          key: const Key('home.surahList'),
          itemCount: value.length,
          itemBuilder: (context, i) {
            final surah = value[i];
            return AppListItem(
              key: Key('home.surah.${surah.id}'),
              onTap: () => _openSurah(context, ref, surah.id),
              leading: Text(context.formatInt(surah.id)),
              title: surah.localizedName(context),
              subtitle: l10n.surahAyahCount(
                surah.ayahCount,
                context.formatInt(surah.ayahCount),
              ),
              // Arapça arayüzde başlık zaten Arapça addır.
              trailing: arabicUi
                  ? null
                  : Text(
                      surah.nameArabic,
                      textDirection: TextDirection.rtl,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
            );
          },
        ),
        AsyncError(:final error) => ErrorState(
          error: error,
          onRetry: () => ref.invalidate(surahsProvider),
        ),
        _ => const LoadingState(),
      },
    );
  }

  Future<void> _openSurah(BuildContext context, WidgetRef ref, int surah) =>
      _openAt(context, ref, AyahRef(surah, 1));

  /// Okuma ekranını ayetin sayfasında açar; okunan konum o ayet olur.
  Future<void> _openAt(
    BuildContext context,
    WidgetRef ref,
    AyahRef ayah,
  ) async {
    final page = await ref
        .read(quranRepositoryProvider)
        .pageOf(kDefaultLayoutId, ayah);
    if (!context.mounted) return;
    ref.read(readerAnchorProvider.notifier).set(ayah);
    context.go(AppRoutes.readerAt(page.valueOrNull ?? 1));
  }
}
