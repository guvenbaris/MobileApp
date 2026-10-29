import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../quran/domain/tajweed.dart';
import '../../quran/presentation/tajweed_l10n.dart';

/// [text]'i tecvid aralıklarına göre renkli parçalara böler (M2-06).
/// Yalnızca renk değişir: harf bağlantısı ve hareke yerleşimi bozulmaz
/// (F1-04 spike, `Faz_1_Notlar.md` §6). Kur'an metninin hiçbir karakteri
/// değişmez; parçalar birleşince aynı metin elde edilir.
TextSpan tajweedTextSpan(
  String text,
  List<TajweedSpan> spans,
  TajweedColors colors,
) {
  if (spans.isEmpty) return TextSpan(text: text);
  final children = <TextSpan>[];
  var i = 0;
  for (final s in spans) {
    if (s.start < i || s.end > text.length) continue;
    if (s.start > i) children.add(TextSpan(text: text.substring(i, s.start)));
    children.add(
      TextSpan(
        text: text.substring(s.start, s.end),
        style: TextStyle(color: s.rule.group.color(colors)),
      ),
    );
    i = s.end;
  }
  if (i < text.length) children.add(TextSpan(text: text.substring(i)));
  return TextSpan(children: children);
}

/// Bir tecvid kuralının adı ve açıklaması; "Tüm renkler" ile renk
/// açıklamalarına geçilir.
Future<void> showTajweedRuleSheet(BuildContext context, TajweedRule rule) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final colors = context.palette.mushaf.tajweed;
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
                _RuleTile(rule: rule, colors: colors, large: true),
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    key: const Key('tajweed.allColors'),
                    onPressed: () {
                      Navigator.pop(context);
                      showTajweedLegendSheet(context);
                    },
                    child: Text(context.l10n.tajweedAllColors),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

/// Renk açıklamaları: her renk grubu ve kuralları, kısa açıklamalarıyla.
Future<void> showTajweedLegendSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        final l10n = context.l10n;
        final colors = context.palette.mushaf.tajweed;
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.85,
          ),
          child: ListView(
            key: const Key('tajweed.legend'),
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.lg,
            ),
            children: [
              Semantics(
                header: true,
                child: Text(
                  l10n.tajweedLegend,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              for (final group in TajweedGroup.values) ...[
                const SizedBox(height: AppSpacing.md),
                Semantics(
                  header: true,
                  child: Row(
                    children: [
                      _Swatch(color: group.color(colors)),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          group.localizedName(context),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                ),
                for (final rule in TajweedRule.values.where(
                  (r) => r.group == group,
                ))
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: AppSpacing.lg,
                      top: AppSpacing.xs,
                    ),
                    child: _RuleTile(rule: rule, colors: colors),
                  ),
              ],
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.tajweedSource,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: context.palette.onSurfaceMuted),
              ),
            ],
          ),
        );
      },
    );

class _RuleTile extends StatelessWidget {
  const _RuleTile({
    required this.rule,
    required this.colors,
    this.large = false,
  });

  final TajweedRule rule;
  final TajweedColors colors;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (large) ...[
              _Swatch(color: rule.group.color(colors)),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Text(
                rule.localizedName(context),
                key: Key('tajweed.rule.${rule.name}'),
                style: large ? theme.titleLarge : theme.bodyLarge,
              ),
            ),
          ],
        ),
        Text(
          rule.localizedInfo(context),
          style: theme.bodyMedium?.copyWith(
            color: context.palette.onSurfaceMuted,
          ),
        ),
      ],
    );
  }
}

/// Renk örneği (süs; adı yanındaki metinde).
class _Swatch extends StatelessWidget {
  const _Swatch({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    ),
  );
}
