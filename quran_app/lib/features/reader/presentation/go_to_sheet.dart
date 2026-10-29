import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../quran/application/layout_providers.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/domain/quran_models.dart';
import '../../quran/domain/quran_navigation.dart';
import '../../quran/presentation/surah_l10n.dart';

/// Git paneli (M4-07, `Ekran_Tasarimi.md` E-03): okuma ekranından çıkmadan
/// sure ve ayete, sayfaya veya cüze gitmek. Seçilen yer [JumpTarget] olarak
/// döner; panel kapatılırsa `null`.
Future<JumpTarget?> showGoToSheet(BuildContext context, AyahRef current) =>
    showModalBottomSheet<JumpTarget>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: _GoToSheet(current: current),
      ),
    );

class _GoToSheet extends ConsumerStatefulWidget {
  const _GoToSheet({required this.current});

  final AyahRef current;

  @override
  ConsumerState<_GoToSheet> createState() => _GoToSheetState();
}

class _GoToSheetState extends ConsumerState<_GoToSheet> {
  late int _surah = widget.current.surah;
  late final _ayah = TextEditingController(text: '${widget.current.ayah}');
  final _page = TextEditingController();

  @override
  void dispose() {
    _ayah.dispose();
    _page.dispose();
    super.dispose();
  }

  void _goToAyah(Map<int, int> counts) {
    final ayah = int.tryParse(_ayah.text.trim());
    final count = counts[_surah] ?? 0;
    if (ayah == null || ayah < 1 || ayah > count) return;
    Navigator.pop(context, AyahJump(AyahRef(_surah, ayah)));
  }

  void _goToPage() {
    final page = int.tryParse(_page.text.trim());
    final pageCount = ref.read(currentLayoutProvider).pageCount;
    if (page == null || page < 1 || page > pageCount) return;
    Navigator.pop(context, PageJump(page));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final surahs = ref.watch(surahsProvider).value ?? const <Surah>[];
    final counts = {for (final s in surahs) s.id: s.ayahCount};
    final quarters = ref.watch(quarterStartsProvider).value ?? const [];
    final juzStarts = {
      for (final q in quarters.reversed) q.juz: q.start,
    }; // her cüzün ilk rubu'u
    final digitsOnly = [FilteringTextInputFormatter.digitsOnly];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.goToTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<int>(
                    key: const Key('goTo.surah'),
                    initialValue: _surah,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l10n.goToSurah),
                    items: [
                      for (final s in surahs)
                        DropdownMenuItem(
                          value: s.id,
                          child: Text(
                            '${context.formatInt(s.id)}. '
                            '${s.localizedName(context)}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (v) => setState(() {
                      _surah = v ?? _surah;
                      _ayah.text = '1';
                    }),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  flex: 2,
                  child: TextField(
                    key: const Key('goTo.ayah'),
                    controller: _ayah,
                    keyboardType: TextInputType.number,
                    inputFormatters: digitsOnly,
                    decoration: InputDecoration(
                      labelText: l10n.goToAyah,
                      helperText: '1–${context.formatInt(counts[_surah] ?? 1)}',
                    ),
                    onSubmitted: (_) => _goToAyah(counts),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              key: const Key('goTo.ayahGo'),
              label: l10n.goToButton,
              onPressed: () => _goToAyah(counts),
            ),
            const Divider(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('goTo.page'),
                    controller: _page,
                    keyboardType: TextInputType.number,
                    inputFormatters: digitsOnly,
                    decoration: InputDecoration(
                      labelText: l10n.goToPage,
                      helperText:
                          '1–${context.formatInt(ref.watch(currentLayoutProvider).pageCount)}',
                    ),
                    onSubmitted: (_) => _goToPage(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                AppButton.secondary(
                  key: const Key('goTo.pageGo'),
                  label: l10n.goToButton,
                  onPressed: _goToPage,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    key: const Key('goTo.juz'),
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l10n.goToJuz),
                    items: [
                      for (final juz in juzStarts.keys.toList()..sort())
                        DropdownMenuItem(
                          value: juz,
                          child: Text(context.formatInt(juz)),
                        ),
                    ],
                    onChanged: (juz) {
                      final start = juzStarts[juz];
                      if (start != null) {
                        Navigator.pop(context, AyahJump(start));
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
