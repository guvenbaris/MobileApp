import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_list_item.dart';
import '../../../core/widgets/state_views.dart';
import '../../today/application/today_providers.dart';
import '../application/quran_providers.dart';
import '../domain/quran_models.dart';
import '../domain/quran_navigation.dart';
import 'surah_l10n.dart';

/// Kur'an sekmesi (E-03): sure, cüz ve sayfa dizini; `2:255` veya sayfa
/// numarasıyla atlama (M4-01). Kelime araması F1-08'de bu kutuya eklenir.
class QuranIndexPage extends ConsumerWidget {
  const QuranIndexPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.tabQuran),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(124),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: _JumpField(),
                ),
                TabBar(
                  tabs: [
                    Tab(
                      key: const Key('quran.tab.surah'),
                      text: l10n.quranTabSurah,
                    ),
                    Tab(
                      key: const Key('quran.tab.juz'),
                      text: l10n.quranTabJuz,
                    ),
                    Tab(
                      key: const Key('quran.tab.page'),
                      text: l10n.quranTabPage,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [_SurahList(), _JuzList(), _PageGrid()],
        ),
        bottomNavigationBar: const _LastReadStrip(),
      ),
    );
  }
}

void _openAyah(BuildContext context, AyahRef ayah) =>
    context.push(AppRoutes.readerAtAyah(ayah));

void _openPage(BuildContext context, int page) =>
    context.push(AppRoutes.readerAtPage(page));

/// `2:255` → ayet, `50` → sayfa. Geçersizse kutunun altında uyarı.
class _JumpField extends ConsumerStatefulWidget {
  const _JumpField();

  @override
  ConsumerState<_JumpField> createState() => _JumpFieldState();
}

class _JumpFieldState extends ConsumerState<_JumpField> {
  final _controller = TextEditingController();
  bool _invalid = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit(String text) async {
    if (text.trim().isEmpty) return;
    // Ayet sayıları ilk aramada yüklenir; beklenmeden okunursa girdi yok
    // sayılırdı.
    final counts = await ref.read(ayahCountsProvider.future);
    if (!mounted) return;
    final target = parseJump(
      text,
      ayahCounts: counts,
      pageCount: kDefaultPageCount,
    );
    setState(() => _invalid = target == null);
    switch (target) {
      case AyahJump(:final ayah):
        _openAyah(context, ayah);
      case PageJump(:final page):
        _openPage(context, page);
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextField(
      key: const Key('quran.jump'),
      controller: _controller,
      textInputAction: TextInputAction.go,
      onSubmitted: _submit,
      onChanged: (_) {
        if (_invalid) setState(() => _invalid = false);
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: l10n.quranJumpHint,
        errorText: _invalid ? l10n.quranJumpInvalid : null,
        isDense: true,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _SurahList extends ConsumerWidget {
  const _SurahList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final arabicUi = Localizations.localeOf(context).languageCode == 'ar';
    return switch (ref.watch(surahsProvider)) {
      AsyncData(:final value) => ListView.builder(
        key: const Key('quran.surahList'),
        itemCount: value.length,
        itemBuilder: (context, i) {
          final surah = value[i];
          final place = surah.revelationPlace == RevelationPlace.makkah
              ? l10n.surahMeccan
              : l10n.surahMedinan;
          final ayahs = l10n.surahAyahCount(
            surah.ayahCount,
            context.formatInt(surah.ayahCount),
          );
          return AppListItem(
            key: Key('quran.surah.${surah.id}'),
            onTap: () => _openAyah(context, AyahRef(surah.id, 1)),
            leading: Text(
              context.formatInt(surah.id),
              semanticsLabel: l10n.surahNumber(context.formatInt(surah.id)),
            ),
            title: surah.localizedName(context),
            subtitle: '$place · $ayahs',
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
    };
  }
}

/// Cüz listesi; her cüz açılınca hizb ve rubu' başlangıçları görünür.
class _JuzList extends ConsumerWidget {
  const _JuzList();

  static const _fractions = ['', '¼', '½', '¾'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final surahs = ref.watch(surahsProvider).value;
    return switch (ref.watch(quarterStartsProvider)) {
      AsyncData(:final value) when surahs != null => () {
        final byJuz = <int, List<QuarterStart>>{};
        for (final q in value) {
          (byJuz[q.juz] ??= []).add(q);
        }
        String location(QuarterStart q) => l10n.pageAt(
          l10n.surahAyah(
            surahs[q.start.surah - 1].localizedName(context),
            context.formatInt(q.start.ayah),
          ),
          context.formatInt(q.page),
        );
        return ListView(
          key: const Key('quran.juzList'),
          children: [
            for (final MapEntry(key: juz, value: quarters) in byJuz.entries)
              ExpansionTile(
                key: Key('quran.juz.$juz'),
                title: Text(l10n.juzTitle(context.formatInt(juz))),
                subtitle: Text(
                  location(quarters.first),
                  style: TextStyle(color: context.palette.onSurfaceMuted),
                ),
                children: [
                  for (final q in quarters)
                    AppListItem(
                      key: Key('quran.rub.${q.rub}'),
                      onTap: () => _openAyah(context, q.start),
                      title: q.quarterInHizb == 0
                          ? l10n.hizbStart(context.formatInt(q.hizb))
                          : l10n.hizbQuarter(
                              context.formatInt(q.hizb),
                              _fractions[q.quarterInHizb],
                            ),
                      subtitle: location(q),
                    ),
                ],
              ),
          ],
        );
      }(),
      AsyncError(:final error) => ErrorState(
        error: error,
        onRetry: () => ref.invalidate(quarterStartsProvider),
      ),
      _ => const LoadingState(),
    };
  }
}

class _PageGrid extends StatelessWidget {
  const _PageGrid();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GridView.builder(
      key: const Key('quran.pageGrid'),
      padding: const EdgeInsets.all(AppSpacing.sm),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 72,
        mainAxisExtent: AppSpacing.minTapTarget,
        crossAxisSpacing: AppSpacing.xs,
        mainAxisSpacing: AppSpacing.xs,
      ),
      itemCount: kDefaultPageCount,
      itemBuilder: (context, i) {
        final page = i + 1;
        return OutlinedButton(
          key: Key('quran.page.$page'),
          // Varsayılan yatay boşluk dar hücrede üç basamağı alt satıra iter.
          style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: () => _openPage(context, page),
          child: Text(
            context.formatInt(page),
            semanticsLabel: l10n.readerPageTitle(context.formatInt(page)),
          ),
        );
      },
    );
  }
}

/// Altta yapışkan "Son okunan" şeridi; kullanıcı henüz okumadıysa yok.
class _LastReadStrip extends ConsumerWidget {
  const _LastReadStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(lastReadSummaryProvider).value;
    if (summary == null) return const SizedBox.shrink();
    final l10n = context.l10n;
    return Material(
      color: context.palette.surface,
      child: SafeArea(
        top: false,
        child: AppListItem(
          key: const Key('quran.lastRead'),
          leading: const Icon(Icons.bookmark_outline),
          title: l10n.lastRead(
            l10n.pageAt(
              l10n.surahAyah(
                summary.surah.localizedName(context),
                context.formatInt(summary.ayah.ayah),
              ),
              context.formatInt(summary.page),
            ),
          ),
          onTap: () => _openAyah(context, summary.ayah),
        ),
      ),
    );
  }
}
