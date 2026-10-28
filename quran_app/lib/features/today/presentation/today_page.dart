import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/domain/quran_models.dart';
import '../../quran/presentation/surah_l10n.dart';
import '../application/today_providers.dart';

/// Bugün sekmesi (E-02, Faz 1 sürümü): son okunan yere tek dokunuşla dönüş
/// (M6-05) ve günün ayeti. Hedef, seri ve tekrar kartları Faz 2'de eklenir.
class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabToday),
        actions: [
          IconButton(
            key: const Key('today.settings'),
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settingsTitle,
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: const [
          _ContinueCard(),
          SizedBox(height: AppSpacing.md),
          _DailyAyahCard(),
        ],
      ),
    );
  }
}

class _ContinueCard extends ConsumerWidget {
  const _ContinueCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final summary = ref.watch(lastReadSummaryProvider).value;
    final text = Theme.of(context).textTheme;

    final (title, detail, button, target) = switch (summary) {
      null => (
        l10n.homeStartReading,
        l10n.todayStartDetail,
        l10n.todayStartButton,
        const AyahRef(1, 1),
      ),
      final s => (
        l10n.homeContinueReading,
        l10n.locationDetail(
          s.surah.localizedName(context),
          context.formatInt(s.ayah.ayah),
          context.formatInt(s.page),
          context.formatInt(s.juz),
        ),
        l10n.todayContinueButton,
        s.ayah,
      ),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: text.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              detail,
              key: const Key('today.continue.detail'),
              style: text.bodyMedium?.copyWith(
                color: context.palette.onSurfaceMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: AppButton(
                key: const Key('today.continue'),
                label: button,
                icon: Icons.play_arrow_rounded,
                onPressed: () => context.push(AppRoutes.readerAtAyah(target)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyAyahCard extends ConsumerWidget {
  const _DailyAyahCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final ayah = ref.watch(dailyAyahProvider).value;
    final surahs = ref.watch(surahsProvider).value;
    // Okunamazsa kart gösterilmez; okuma akışı bundan etkilenmez.
    if (ayah == null || surahs == null) return const SizedBox.shrink();
    final surah = surahs.firstWhere((s) => s.id == ayah.ref.surah);
    final mushaf = context.palette.mushaf;

    return Card(
      key: const Key('today.dailyAyah'),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.todayDailyAyah,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              ayah.textDigitalKhatt,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppTypography.quran(
                fontSize: AppTypography.quranHeaderSize,
                height: 1.8,
                color: mushaf.text,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.surahAyah(
                      surah.localizedName(context),
                      context.formatInt(ayah.ref.ayah),
                    ),
                    style: TextStyle(color: context.palette.onSurfaceMuted),
                  ),
                ),
                AppButton.text(
                  key: const Key('today.dailyAyah.read'),
                  label: l10n.todayRead,
                  onPressed: () =>
                      context.push(AppRoutes.readerAtAyah(ayah.ref)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
