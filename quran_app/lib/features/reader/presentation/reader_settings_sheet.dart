import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_list_item.dart';
import '../../quran/application/layout_providers.dart';
import '../../quran/presentation/layout_l10n.dart';
import '../../settings/application/theme_settings.dart';
import '../application/reader_settings.dart';
import 'tajweed_text.dart';

/// Okuma ayarları paneli (E-10). Her değişiklik anında sayfaya uygulanır ve
/// kalıcıdır (M13-02). Görünüm değişikliği okuma ekranından geçer: okunan
/// ayet korunarak sayfa hesaplanır (M2-01).
///
/// Kelime meali (F1-06) o iş paketinde eklenir.
Future<void> showReaderSettingsSheet(
  BuildContext context, {
  required ValueChanged<ReaderViewMode> onViewMode,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (context) => _ReaderSettingsSheet(onViewMode: onViewMode),
);

class _ReaderSettingsSheet extends ConsumerWidget {
  const _ReaderSettingsSheet({required this.onViewMode});

  final ValueChanged<ReaderViewMode> onViewMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(readerSettingsProvider);
    final notifier = ref.read(readerSettingsProvider.notifier);
    final theme = ref.watch(themeSettingsProvider);
    final locked = settings.textScaleLocked;
    final layouts = ref.watch(layoutCatalogProvider).layouts;
    final currentLayout = ref.watch(currentLayoutProvider);
    final percent = l10n.readerPercent(
      context.formatInt((settings.textScale * 100).round()),
    );

    Widget chips<T>(
      List<T> values,
      T selected,
      String Function(T) label,
      Key Function(T) keyOf,
      ValueChanged<T> onSelected,
    ) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Wrap(
        spacing: AppSpacing.sm,
        children: [
          for (final v in values)
            ChoiceChip(
              key: keyOf(v),
              label: Text(label(v)),
              selected: v == selected,
              onSelected: (_) => onSelected(v),
            ),
        ],
      ),
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Semantics(
                  header: true,
                  child: Text(
                    l10n.readerSettings,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              AppSectionHeader(l10n.readerView),
              chips(
                ReaderViewMode.values,
                settings.viewMode,
                (v) => switch (v) {
                  ReaderViewMode.page => l10n.readerViewPage,
                  ReaderViewMode.ayah => l10n.readerViewAyah,
                },
                (v) => Key('readerSettings.view.${v.name}'),
                onViewMode,
              ),
              AppSectionHeader(l10n.readerTheme),
              chips(
                ThemePreference.values,
                theme,
                (v) => switch (v) {
                  ThemePreference.system => l10n.themeSystem,
                  ThemePreference.light => l10n.themeLight,
                  ThemePreference.sepia => l10n.themeSepia,
                  ThemePreference.dark => l10n.themeDark,
                },
                (v) => Key('readerSettings.theme.${v.name}'),
                ref.read(themeSettingsProvider.notifier).set,
              ),
              AppSectionHeader(l10n.readerTextSize),
              Row(
                children: [
                  const SizedBox(width: AppSpacing.xs),
                  IconButton(
                    key: const Key('readerSettings.textSmaller'),
                    tooltip: l10n.readerTextSmaller,
                    icon: const Icon(Icons.text_decrease),
                    onPressed: locked
                        ? null
                        : () => notifier.setTextScale(
                            settings.textScale - ReaderSettings.textScaleStep,
                          ),
                  ),
                  Expanded(
                    child: Slider(
                      key: const Key('readerSettings.textScale'),
                      value: settings.textScale,
                      min: ReaderSettings.minTextScale,
                      max: ReaderSettings.maxTextScale,
                      divisions:
                          ((ReaderSettings.maxTextScale -
                                      ReaderSettings.minTextScale) /
                                  ReaderSettings.textScaleStep)
                              .round(),
                      label: percent,
                      semanticFormatterCallback: (v) => l10n.readerPercent(
                        context.formatInt((v * 100).round()),
                      ),
                      onChanged: locked ? null : notifier.setTextScale,
                    ),
                  ),
                  IconButton(
                    key: const Key('readerSettings.textLarger'),
                    tooltip: l10n.readerTextLarger,
                    icon: const Icon(Icons.text_increase),
                    onPressed: locked
                        ? null
                        : () => notifier.setTextScale(
                            settings.textScale + ReaderSettings.textScaleStep,
                          ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],
              ),
              SwitchListTile(
                key: const Key('readerSettings.textLock'),
                secondary: Icon(locked ? Icons.lock : Icons.lock_open),
                title: Text(l10n.readerTextLock),
                subtitle: Text(l10n.readerTextLockHint),
                value: locked,
                onChanged: notifier.setTextScaleLocked,
              ),
              const Divider(),
              // M2-14: cihazdaki düzenler; seçim anında uygulanır, okunan
              // ayet korunur (M2-15).
              AppSectionHeader(l10n.readerMushafLayout),
              RadioGroup<String>(
                groupValue: currentLayout.id,
                onChanged: (id) => id == null
                    ? null
                    : ref.read(layoutSelectionProvider.notifier).select(id),
                child: Column(
                  children: [
                    for (final layout in layouts)
                      RadioListTile<String>(
                        key: Key('readerSettings.layout.${layout.id}'),
                        value: layout.id,
                        title: Text(layout.localizedName(context)),
                        subtitle: Text(
                          [
                            l10n.readerLayoutInfo(
                              context.formatInt(layout.pageCount),
                              context.formatInt(layout.linesPerPage),
                            ),
                            if (!layout.isBuiltIn) l10n.readerLayoutDownloaded,
                          ].join(' · '),
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(),
              // M2-06: renkli tecvid ve renk açıklamaları.
              SwitchListTile(
                key: const Key('readerSettings.tajweed'),
                secondary: const Icon(Icons.palette_outlined),
                title: Text(l10n.readerTajweed),
                subtitle: Text(l10n.readerTajweedHint),
                value: settings.tajweed,
                onChanged: notifier.setTajweed,
              ),
              AppListItem(
                key: const Key('readerSettings.tajweedLegend'),
                leading: const Icon(Icons.info_outline),
                title: l10n.tajweedLegend,
                onTap: () => showTajweedLegendSheet(context),
              ),
              const Divider(),
              SwitchListTile(
                key: const Key('readerSettings.keepScreenOn'),
                secondary: const Icon(Icons.light_mode_outlined),
                title: Text(l10n.readerKeepScreenOn),
                subtitle: Text(l10n.readerKeepScreenOnHint),
                value: settings.keepScreenOn,
                onChanged: notifier.setKeepScreenOn,
              ),
              SwitchListTile(
                key: const Key('readerSettings.pageArrows'),
                secondary: const Icon(Icons.swap_horiz),
                title: Text(l10n.readerPageArrows),
                subtitle: Text(l10n.readerPageArrowsHint),
                value: settings.pageArrows,
                onChanged: notifier.setPageArrows,
              ),
              AppSectionHeader(l10n.readerAutoScrollSpeed),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Slider(
                  key: const Key('readerSettings.autoScrollSpeed'),
                  value: settings.autoScrollSpeed.toDouble(),
                  min: ReaderSettings.minAutoScrollSpeed.toDouble(),
                  max: ReaderSettings.maxAutoScrollSpeed.toDouble(),
                  divisions:
                      ReaderSettings.maxAutoScrollSpeed -
                      ReaderSettings.minAutoScrollSpeed,
                  label: context.formatInt(settings.autoScrollSpeed),
                  semanticFormatterCallback: (v) =>
                      context.formatInt(v.round()),
                  onChanged: (v) => notifier.setAutoScrollSpeed(v.round()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
