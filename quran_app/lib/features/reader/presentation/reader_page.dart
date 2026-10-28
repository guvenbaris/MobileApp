import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/state_views.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/domain/mushaf_page.dart';
import '../../quran/domain/quran_models.dart';
import '../../settings/application/theme_settings.dart';
import '../application/reader_providers.dart';
import '../application/reader_settings.dart';
import 'ayah_list_view.dart';
import 'mushaf_page_view.dart';

// F0-05 denemesi: okuma ekranının tam özellikleri (gösterge çubukları,
// otomatik kaydırma vb.) Faz 1'dedir.
class ReaderPage extends ConsumerStatefulWidget {
  const ReaderPage({this.initialPage = 1, super.key});

  static const pageCount = 604;

  final int initialPage;

  @override
  ConsumerState<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends ConsumerState<ReaderPage> {
  late PageController _controller = PageController(
    initialPage: widget.initialPage - 1,
  );
  late int _page = widget.initialPage;

  /// Çift sayfa (açılım) görünümü mü (M2-03). Döndürmede değişir; okunan
  /// sayfa [_page] korunur (M2-10).
  bool _twoPage = false;

  /// Tablet yatay tutulduğunda iki sayfa yan yana gösterilir.
  static bool _useTwoPages(Size size) =>
      size.shortestSide >= 600 && size.width > size.height;

  /// [page] sayfasını gösteren kaydırma öğesinin sırası.
  int _itemOf(int page) => _twoPage ? (page - 1) ~/ 2 : page - 1;

  /// Yeni bir denetleyiciyle [page] sayfasına gider. Eski denetleyici,
  /// eski sayfa görünümü ağaçtan çıktıktan sonra (bir kare sonra) kapatılır.
  void _resetController(int page) {
    final old = _controller;
    _controller = PageController(initialPage: _itemOf(page));
    WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prefetchAround(widget.initialPage);
      _anchorToPage(widget.initialPage, keepIfOnPage: true);
    });
  }

  /// Sayfa görünümünde okunan konum, sayfanın ilk ayetidir (M2-15).
  /// [keepIfOnPage]: okunan ayet zaten bu sayfadaysa korunur (ör. son
  /// okunan yerden devam ederken sayfanın başına kaymaz).
  Future<void> _anchorToPage(int page, {bool keepIfOnPage = false}) async {
    try {
      final data = await ref.read(mushafPageProvider(page).future);
      if (!mounted || page != _page) return;
      final anchor = ref.read(readerAnchorProvider);
      if (keepIfOnPage && _pageContains(data, anchor)) return;
      ref.read(readerAnchorProvider.notifier).set(data.firstAyah);
    } on Object {
      // Sayfa okunamadıysa hata sayfada gösterilir; konum değişmez.
    }
  }

  /// Görünüm değiştirir; sayfa görünümüne dönerken okunan ayetin sayfası
  /// açılır (M2-01: konum korunur).
  Future<void> _setViewMode(ReaderViewMode mode) async {
    final settings = ref.read(readerSettingsProvider.notifier);
    if (mode == ReaderViewMode.page) {
      final anchor = ref.read(readerAnchorProvider);
      final page = await ref
          .read(quranRepositoryProvider)
          .pageOf(kDefaultLayoutId, anchor);
      if (!mounted) return;
      final target = page.valueOrNull ?? _page;
      setState(() {
        _page = target;
        _resetController(target);
      });
      // Sayfa görünümünde çapa yine okunan ayettir; sayfanın ilk ayetine
      // ancak kullanıcı sayfa değiştirince geçer.
      _prefetchAround(target);
    }
    ref.read(selectedWordProvider.notifier).select(null);
    settings.setViewMode(mode);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Önceki ve sonraki iki sayfanın verisini arka planda yükler.
  void _prefetchAround(int page) {
    for (final p in [page + 1, page - 1, page + 2, page - 2]) {
      if (p < 1 || p > ReaderPage.pageCount) continue;
      ref.read(mushafPageProvider(p).future).ignore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(readerSettingsProvider);
    final colors = context.palette.mushaf;
    final twoPage = _useTwoPages(MediaQuery.sizeOf(context));
    if (twoPage != _twoPage) {
      _twoPage = twoPage;
      _resetController(_page);
    }
    final juz = ref.watch(mushafPageProvider(_page)).value?.juz;
    final selected = ref.watch(selectedWordProvider);
    final ayahView = settings.viewMode == ReaderViewMode.ayah;
    final anchor = ref.watch(readerAnchorProvider);
    final index = ayahView ? ref.watch(ayahIndexProvider).value : null;
    final l10n = context.l10n;
    final pageText = context.formatInt(_page);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          ayahView
              ? l10n.readerAyahTitle(context.formatDigits(anchor))
              : juz == null
              ? l10n.readerPageTitle(pageText)
              : l10n.readerPageJuzTitle(pageText, context.formatInt(juz)),
          key: const Key('reader.title'),
        ),
        actions: [
          IconButton(
            key: const Key('reader.viewMode'),
            tooltip: ayahView
                ? l10n.readerShowPageView
                : l10n.readerShowAyahView,
            icon: Icon(ayahView ? Icons.menu_book : Icons.view_agenda_outlined),
            onPressed: () => _setViewMode(
              ayahView ? ReaderViewMode.page : ReaderViewMode.ayah,
            ),
          ),
          if (ayahView) ...[
            IconButton(
              key: const Key('reader.textSmaller'),
              tooltip: l10n.readerTextSmaller,
              icon: const Icon(Icons.text_decrease),
              onPressed: () => ref
                  .read(readerSettingsProvider.notifier)
                  .setTextScale(settings.textScale - 0.25),
            ),
            IconButton(
              key: const Key('reader.textLarger'),
              tooltip: l10n.readerTextLarger,
              icon: const Icon(Icons.text_increase),
              onPressed: () => ref
                  .read(readerSettingsProvider.notifier)
                  .setTextScale(settings.textScale + 0.25),
            ),
          ],
          IconButton(
            key: const Key('reader.theme'),
            tooltip: l10n.readerTheme,
            icon: const Icon(Icons.palette_outlined),
            onPressed: () => ref
                .read(themeSettingsProvider.notifier)
                .cycleFrom(context.palette.id),
          ),
        ],
      ),
      body: ayahView
          ? index == null
                ? ColoredBox(color: colors.background)
                : AyahListView(
                    index: index,
                    colors: colors,
                    textScale: settings.textScale,
                  )
          : Directionality(
              // Arapça mushaf sağdan sola: sonraki sayfa soldan gelir.
              textDirection: TextDirection.rtl,
              child: PageView.builder(
                key: ValueKey(
                  'reader.pages.$_twoPage.${_controller.initialPage}',
                ),
                controller: _controller,
                itemCount: _twoPage
                    ? (ReaderPage.pageCount + 1) ~/ 2
                    : ReaderPage.pageCount,
                // Komşu sayfalar ekran dışında önceden çizilir; kaydırma anında
                // yalnızca hazır görüntü kayar (NF-PF02).
                allowImplicitScrolling: true,
                onPageChanged: (index) {
                  final page = _twoPage ? index * 2 + 1 : index + 1;
                  setState(() => _page = page);
                  ref.read(selectedWordProvider.notifier).select(null);
                  _prefetchAround(page);
                  _anchorToPage(page);
                },
                itemBuilder: (context, index) => _twoPage
                    // Basılı mushaf gibi: tek sayfa sağda, çift sayfa solda.
                    ? Row(
                        key: ValueKey('reader.spread.$index'),
                        children: [
                          for (final page in [index * 2 + 1, index * 2 + 2])
                            Expanded(
                              child: _PageSlot(page: page, colors: colors),
                            ),
                        ],
                      )
                    : _PageSlot(page: index + 1, colors: colors),
              ),
            ),
      bottomNavigationBar: selected == null
          ? null
          // Seçim değişince ekran okuyucu yeni kelimeyi duyurur.
          : Semantics(
              liveRegion: true,
              child: Material(
                color: colors.highlight,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      l10n.readerSelectedWord(context.formatDigits(selected)),
                      key: const Key('reader.selectedWord'),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.text),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

bool _pageContains(MushafPage page, AyahRef ayah) {
  final refs = page.lines.expand((l) => l.glyphs).expand((g) => g.words);
  return refs.any((w) => w.surah == ayah.surah && w.ayah == ayah.ayah);
}

/// Bir sayfanın verisini yükleyip çizer.
class _PageSlot extends ConsumerWidget {
  const _PageSlot({required this.page, required this.colors});

  final int page;
  final MushafColors colors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(mushafPageProvider(page));
    final surahs = ref.watch(surahByIdProvider);
    final basmala = ref.watch(basmalaTextProvider);

    final error = data.error ?? surahs.error ?? basmala.error;
    if (error != null) {
      return ErrorState(
        error: error,
        onRetry: () => ref
          ..invalidate(mushafPageProvider(page))
          ..invalidate(surahsProvider)
          ..invalidate(surahByIdProvider)
          ..invalidate(basmalaTextProvider),
      );
    }
    if (!data.hasValue || !surahs.hasValue || !basmala.hasValue) {
      return ColoredBox(color: colors.background);
    }
    return MushafPageView(
      key: ValueKey('mushafPage.$page'),
      page: data.requireValue,
      surahs: surahs.requireValue,
      basmala: basmala.requireValue,
      colors: colors,
    );
  }
}
