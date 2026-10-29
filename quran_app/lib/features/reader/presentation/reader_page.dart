import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/platform/wake_lock.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/state_views.dart';
import '../../quran/application/layout_providers.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/domain/mushaf_layout.dart';
import '../../quran/domain/mushaf_page.dart';
import '../../quran/domain/quran_models.dart';
import '../../quran/domain/quran_navigation.dart';
import '../application/reader_providers.dart';
import '../application/reader_settings.dart';
import 'ayah_list_view.dart';
import 'go_to_sheet.dart';
import 'mushaf_page_frame.dart';
import 'mushaf_page_view.dart';
import 'reader_settings_sheet.dart';

/// Okuma ekranı (E-04, E-05). Üst ve alt çubuk metnin üstünde durur ve
/// boş alana dokununca gizlenir/görünür; kendiliğinden kapanmaz (M2-13).
/// Cüz, hizb ve sayfa bilgisi çubuklar gizliyken de görünür (M2-04).
class ReaderPage extends ConsumerStatefulWidget {
  const ReaderPage({this.initialPage = 1, super.key});

  /// Okunan düzende açılacak sayfa.
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

  /// Git paneliyle her atlamada artar; ayet görünümü yeni çapadan açılır.
  int _jumpGeneration = 0;

  bool _chromeVisible = true;

  /// Otomatik kaydırma (M2-11). Oturumluktur, kaydedilmez.
  bool _autoScrolling = false;

  /// Son dokunuş otomatik kaydırmayı durdurdu mu: o dokunuş çubukları
  /// gizlemez, gösterir (durdurmak için dokunan kullanıcı denetimleri görür).
  bool _touchStoppedAutoScroll = false;
  Timer? _pageTimer;

  /// Sayfa görünümünde yakınlaştırma (M2-07).
  final _zoom = TransformationController();
  bool _zoomed = false;

  late final WakeLock _wakeLock;
  bool _wakeLockOn = false;

  /// Tablet yatay tutulduğunda iki sayfa yan yana gösterilir.
  static bool _useTwoPages(Size size) =>
      size.shortestSide >= 600 && size.width > size.height;

  /// Ekran kenarında sistemin geri hareketine bırakılan şerit (M2-09).
  static const _edgeStripWidth = 24.0;

  /// Sayfa çevirme animasyonu (oklar ve otomatik kaydırma).
  static const _turnDuration = Duration(milliseconds: 250);

  /// [page] sayfasını gösteren kaydırma öğesinin sırası.
  int _itemOf(int page) => _twoPage ? (page - 1) ~/ 2 : page - 1;

  /// Okunan düzenin sayfa sayısı (M2-14: düzene göre değişebilir).
  int get _pageCount => ref.read(currentLayoutProvider).pageCount;

  int get _itemCount => _twoPage ? (_pageCount + 1) ~/ 2 : _pageCount;

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
    _wakeLock = ref.read(wakeLockProvider);
    _zoom.addListener(_onZoomChanged);
    ref.listenManual(readerSettingsProvider, (previous, next) {
      _syncWakeLock();
      if (next.textScaleLocked) _resetZoom();
      if (previous?.autoScrollSpeed != next.autoScrollSpeed) {
        _restartPageTimer();
      }
    });
    // M2-14, M2-15: düzen değişince aynı ayet yeni düzendeki sayfasında
    // açılır; okunan ayet ve kayıtlar değişmez.
    ref.listenManual(currentLayoutProvider, (previous, next) {
      if (previous?.id != next.id) _onLayoutChanged(next);
    });
    _syncWakeLock();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prefetchAround(widget.initialPage);
      _anchorToPage(widget.initialPage, keepIfOnPage: true);
    });
  }

  @override
  void dispose() {
    _pageTimer?.cancel();
    if (_wakeLockOn) _wakeLock.setEnabled(false).ignore();
    _zoom.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// Ekran, ayar açıksa ya da otomatik kaydırma sürerken açık kalır
  /// (M2-12); okuma ekranından çıkınca bırakılır.
  void _syncWakeLock() {
    final on = ref.read(readerSettingsProvider).keepScreenOn || _autoScrolling;
    if (on == _wakeLockOn) return;
    _wakeLockOn = on;
    _wakeLock.setEnabled(on).ignore();
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
    if (mode == ref.read(readerSettingsProvider).viewMode) return;
    if (mode == ReaderViewMode.page) {
      final anchor = ref.read(readerAnchorProvider);
      final page = await ref
          .read(quranRepositoryProvider)
          .pageOf(ref.read(currentLayoutProvider).id, anchor);
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
    _resetZoom();
    ref.read(selectedWordProvider.notifier).select(null);
    settings.setViewMode(mode);
    _restartPageTimer();
  }

  Future<void> _onLayoutChanged(MushafLayout layout) async {
    final anchor = ref.read(readerAnchorProvider);
    final result = await ref
        .read(quranRepositoryProvider)
        .pageOf(layout.id, anchor);
    if (!mounted) return;
    final page = (result.valueOrNull ?? 1).clamp(1, layout.pageCount);
    _resetZoom();
    ref.read(selectedWordProvider.notifier).select(null);
    setState(() {
      _page = page;
      _resetController(page);
      _jumpGeneration++;
    });
    _prefetchAround(page);
  }

  /// Git panelinden seçilen yere gider (M4-07). Konum hem sayfa hem ayet
  /// görünümünde aynı çapadan açılır (M2-15).
  Future<void> _goTo(JumpTarget target) async {
    final repo = ref.read(quranRepositoryProvider);
    final layoutId = ref.read(currentLayoutProvider).id;
    final AyahRef anchor;
    final int page;
    switch (target) {
      case AyahJump(:final ayah):
        final result = await repo.pageOf(layoutId, ayah);
        if (result.valueOrNull == null) return;
        (anchor, page) = (ayah, result.valueOrNull!);
      case PageJump(page: final p):
        final result = await repo.firstAyahOfPage(layoutId, p);
        if (result.valueOrNull == null) return;
        (anchor, page) = (result.valueOrNull!, p);
    }
    if (!mounted) return;
    ref.read(readerAnchorProvider.notifier).set(anchor);
    ref.read(selectedWordProvider.notifier).select(null);
    _resetZoom();
    setState(() {
      _page = page;
      _resetController(page);
      _jumpGeneration++;
    });
    _prefetchAround(page);
  }

  Future<void> _openGoTo() async {
    final target = await showGoToSheet(context, ref.read(readerAnchorProvider));
    if (target != null) await _goTo(target);
  }

  Future<void> _openSettings() =>
      showReaderSettingsSheet(context, onViewMode: _setViewMode);

  /// Önceki ve sonraki iki sayfanın verisini arka planda yükler.
  void _prefetchAround(int page) {
    for (final p in [page + 1, page - 1, page + 2, page - 2]) {
      if (p < 1 || p > _pageCount) continue;
      ref.read(mushafPageProvider(p).future).ignore();
    }
  }

  void _onPageChanged(int index) {
    final page = _twoPage ? index * 2 + 1 : index + 1;
    setState(() => _page = page);
    ref.read(selectedWordProvider.notifier).select(null);
    _resetZoom();
    _prefetchAround(page);
    _anchorToPage(page);
    _restartPageTimer();
  }

  /// Sayfa okları ve otomatik kaydırma: [delta] = +1 sonraki, −1 önceki.
  void _turnPage(int delta) {
    if (!_controller.hasClients) return;
    final current = _controller.page?.round() ?? _itemOf(_page);
    final target = current + delta;
    if (target < 0 || target >= _itemCount) return;
    _controller
        .animateToPage(target, duration: _turnDuration, curve: Curves.easeOut)
        .ignore();
  }

  // --- Çubuklar (M2-13) ---

  void _onContentPointerDown(PointerDownEvent _) {
    // M2-11: otomatik kaydırma dokununca durur.
    _touchStoppedAutoScroll = _autoScrolling;
    if (_autoScrolling) _stopAutoScroll();
  }

  void _onContentTap() {
    setState(() => _chromeVisible = _touchStoppedAutoScroll || !_chromeVisible);
    _touchStoppedAutoScroll = false;
  }

  // --- Otomatik kaydırma (M2-11) ---

  void _startAutoScroll() {
    // Okumaya başlayan kullanıcı için çubuklar kapanır; bir dokunuş hem
    // kaydırmayı durdurur hem çubukları geri getirir.
    setState(() {
      _autoScrolling = true;
      _chromeVisible = false;
    });
    _syncWakeLock();
    _restartPageTimer();
  }

  void _stopAutoScroll() {
    _pageTimer?.cancel();
    setState(() => _autoScrolling = false);
    _syncWakeLock();
  }

  /// Sayfa görünümünde otomatik kaydırma, ayarlanan sürede bir sonraki
  /// sayfaya geçmektir.
  void _restartPageTimer() {
    _pageTimer?.cancel();
    final settings = ref.read(readerSettingsProvider);
    if (!_autoScrolling || settings.viewMode != ReaderViewMode.page) return;
    _pageTimer = Timer(settings.autoScrollPageDuration, () {
      if (!mounted || !_autoScrolling) return;
      if (_itemOf(_page) >= _itemCount - 1) return _stopAutoScroll();
      _turnPage(1);
    });
  }

  // --- Yakınlaştırma (M2-07) ---

  void _onZoomChanged() {
    final zoomed = _zoom.value.getMaxScaleOnAxis() > 1.01;
    if (zoomed != _zoomed) setState(() => _zoomed = zoomed);
  }

  void _resetZoom() {
    if (_zoomed) _zoom.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(readerSettingsProvider);
    // Sayfa sayısı düzene bağlı; düzen değişince yeniden çizilir.
    ref.watch(currentLayoutProvider);
    final colors = context.palette.mushaf;
    final twoPage = _useTwoPages(MediaQuery.sizeOf(context));
    if (twoPage != _twoPage) {
      _twoPage = twoPage;
      _resetController(_page);
    }
    final selected = ref.watch(selectedWordProvider);
    final ayahView = settings.viewMode == ReaderViewMode.ayah;
    final l10n = context.l10n;

    final content = ayahView
        ? _buildAyahView(colors, settings)
        : _buildPageView(colors, settings);

    return Scaffold(
      backgroundColor: colors.background,
      // Seçilen kelime çubuğu metnin üstüne binmez, altında yer açar. Kelime
      // kartı (E-07, F1-06) gelince yerini o alır.
      bottomNavigationBar: selected == null
          ? null
          : _SelectedWordBar(word: selected),
      body: Stack(
        children: [
          Positioned.fill(
            child: Listener(
              onPointerDown: _onContentPointerDown,
              // Ekran okuyucuda içerik bir bölgedir; çubuklar onun eylemiyle
              // açılıp kapanır (M13-03).
              child: Semantics(
                label: l10n.readerContent,
                onTapHint: _chromeVisible
                    ? l10n.readerHideControls
                    : l10n.readerShowControls,
                onTap: _onContentTap,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  excludeFromSemantics: true,
                  onTap: _onContentTap,
                  child: content,
                ),
              ),
            ),
          ),
          // Çubuklar açıkken içeriğe ilk dokunuş (kelimede de) yalnızca
          // çubukları kapatır: mushaf sayfası kelimelerle dolu olduğundan
          // "boş alan" bulmak zordur. Kaydırma alttaki sayfaya geçer.
          if (_chromeVisible)
            Positioned.fill(
              child: GestureDetector(
                key: const Key('reader.dismissChrome'),
                behavior: HitTestBehavior.translucent,
                excludeFromSemantics: true,
                onTap: () => setState(() => _chromeVisible = false),
              ),
            ),
          if (!ayahView && !_zoomed) ..._edgeStrips(context),
          // Çubuklar açıkken oklar alt çubuğun iki ucundadır; aynı yerde.
          if (!ayahView && settings.pageArrows && !_chromeVisible)
            ..._cornerArrows(context),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _ChromeSlot(
              visible: _chromeVisible,
              child: _buildTopBar(ayahView),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ChromeSlot(
                  visible: _chromeVisible,
                  child: _buildBottomBar(
                    ayahView,
                    arrows: !ayahView && settings.pageArrows,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyahView(MushafColors colors, ReaderSettings settings) {
    final index = ref.watch(ayahIndexProvider).value;
    return ColoredBox(
      color: colors.background,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: index == null
                  ? const SizedBox.expand()
                  : AyahListView(
                      key: ValueKey('reader.ayahList.$_jumpGeneration'),
                      index: index,
                      colors: colors,
                      textScale: settings.textScale,
                      autoScrollSpeed: _autoScrolling
                          ? settings.autoScrollPixelsPerSecond
                          : null,
                      onAutoScrollEnd: _stopAutoScroll,
                    ),
            ),
            AyahInfoLine(colors: colors),
          ],
        ),
      ),
    );
  }

  Widget _buildPageView(MushafColors colors, ReaderSettings settings) {
    final arrowsInset = settings.pageArrows ? AppSpacing.minTapTarget : 0.0;
    final pages = PageView.builder(
      key: ValueKey('reader.pages.$_twoPage.${_controller.initialPage}'),
      controller: _controller,
      // Mushaf sağdan soladır: sonraki sayfa soldan gelir (arayüz dilinden
      // bağımsız).
      reverse: Directionality.of(context) == TextDirection.ltr,
      itemCount: _itemCount,
      // Yakınken parmak sayfayı kaydırır, çevirmez.
      physics: _zoomed ? const NeverScrollableScrollPhysics() : null,
      // Komşu sayfalar ekran dışında önceden çizilir; kaydırma anında
      // yalnızca hazır görüntü kayar (NF-PF02).
      allowImplicitScrolling: true,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) => _twoPage
          // Basılı mushaf gibi: tek sayfa sağda, çift sayfa solda.
          ? Row(
              key: ValueKey('reader.spread.$index'),
              textDirection: TextDirection.rtl,
              children: [
                for (final page in [index * 2 + 1, index * 2 + 2])
                  Expanded(
                    child: page > _pageCount
                        ? ColoredBox(color: colors.background)
                        : _PageSlot(
                            page: page,
                            colors: colors,
                            footerSideInset: arrowsInset,
                          ),
                  ),
              ],
            )
          : _PageSlot(
              page: index + 1,
              colors: colors,
              footerSideInset: arrowsInset,
            ),
    );
    return InteractiveViewer(
      key: const Key('reader.zoom'),
      transformationController: _zoom,
      maxScale: 3,
      panEnabled: _zoomed,
      // M2-07: yazı boyutu kilitliyken yakınlaştırma da kapalı.
      scaleEnabled: !settings.textScaleLocked,
      child: pages,
    );
  }

  /// Kenardan başlayan yatay kaydırmayı sayfa çevirmeden önce yakalayan
  /// şeritler: sistemin geri hareketiyle çakışmaz (M2-09). Şeritler yalnızca
  /// yatay sürüklemeyi alır; dokunuşlar alttaki sayfaya geçer.
  List<Widget> _edgeStrips(BuildContext context) {
    final insets = MediaQuery.systemGestureInsetsOf(context);
    Widget strip(double width) => SizedBox(
      width: width,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        excludeFromSemantics: true,
        onHorizontalDragStart: (_) {},
      ),
    );
    return [
      Positioned(
        key: const Key('reader.edge.left'),
        left: 0,
        top: 0,
        bottom: 0,
        child: strip(math.max(_edgeStripWidth, insets.left)),
      ),
      Positioned(
        key: const Key('reader.edge.right'),
        right: 0,
        top: 0,
        bottom: 0,
        child: strip(math.max(_edgeStripWidth, insets.right)),
      ),
    ];
  }

  /// Sayfa okları (M2-09): mushaf sağdan sola olduğu için sonraki sayfa
  /// solda, önceki sağdadır (arayüz dilinden bağımsız).
  Widget _nextArrow() => IconButton(
    key: const Key('reader.nextPage'),
    tooltip: context.l10n.readerNextPage,
    icon: const Icon(Icons.chevron_left),
    onPressed: () => _turnPage(1),
  );

  Widget _previousArrow() => IconButton(
    key: const Key('reader.previousPage'),
    tooltip: context.l10n.readerPreviousPage,
    icon: const Icon(Icons.chevron_right),
    onPressed: () => _turnPage(-1),
  );

  /// Çubuklar gizliyken oklar ekranın alt köşelerinde, sayfa altındaki
  /// bilgi satırının iki yanındadır (metnin üstüne binmez).
  List<Widget> _cornerArrows(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return [
      Positioned(left: 0, bottom: bottom, child: _nextArrow()),
      Positioned(right: 0, bottom: bottom, child: _previousArrow()),
    ];
  }

  Widget _buildTopBar(bool ayahView) {
    final l10n = context.l10n;
    final anchor = ref.watch(readerAnchorProvider);
    final juz = ref.watch(mushafPageProvider(_page)).value?.juz;
    final pageText = context.formatInt(_page);
    return AppBar(
      key: const Key('reader.topBar'),
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
          key: const Key('reader.settings'),
          tooltip: l10n.readerSettings,
          icon: const Icon(Icons.tune),
          onPressed: _openSettings,
        ),
      ],
    );
  }

  Widget _buildBottomBar(bool ayahView, {required bool arrows}) {
    final l10n = context.l10n;
    return Material(
      key: const Key('reader.bottomBar'),
      color: context.palette.surface,
      elevation: 2,
      child: SafeArea(
        top: false,
        child: Row(
          // Oklar fiziksel olarak solda ve sağda durur.
          textDirection: TextDirection.ltr,
          children: [
            if (arrows) _nextArrow(),
            Expanded(
              child: Row(
                textDirection: Directionality.of(context),
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    key: const Key('reader.viewMode'),
                    tooltip: ayahView
                        ? l10n.readerShowPageView
                        : l10n.readerShowAyahView,
                    icon: Icon(
                      ayahView ? Icons.menu_book : Icons.view_agenda_outlined,
                    ),
                    onPressed: () => _setViewMode(
                      ayahView ? ReaderViewMode.page : ReaderViewMode.ayah,
                    ),
                  ),
                  IconButton(
                    key: const Key('reader.autoScroll'),
                    tooltip: _autoScrolling
                        ? l10n.readerAutoScrollStop
                        : l10n.readerAutoScrollStart,
                    icon: Icon(
                      _autoScrolling
                          ? Icons.pause_circle_outline
                          : Icons.play_circle_outline,
                    ),
                    onPressed: _autoScrolling
                        ? _stopAutoScroll
                        : _startAutoScroll,
                  ),
                  IconButton(
                    key: const Key('reader.goTo'),
                    tooltip: l10n.readerGoTo,
                    icon: const Icon(Icons.manage_search),
                    onPressed: _openGoTo,
                  ),
                ],
              ),
            ),
            if (arrows) _previousArrow(),
          ],
        ),
      ),
    );
  }
}

bool _pageContains(MushafPage page, AyahRef ayah) {
  final refs = page.lines.expand((l) => l.glyphs).expand((g) => g.words);
  return refs.any((w) => w.surah == ayah.surah && w.ayah == ayah.ayah);
}

/// Çubuk yeri: görünürken çubuk, gizliyken hiçbir şey (ekran okuyucu ve
/// dokunuş için de yok). Geçiş kısa bir solmadır; sistemde "hareketi azalt"
/// açıksa anında olur.
class _ChromeSlot extends StatelessWidget {
  const _ChromeSlot({required this.visible, required this.child});

  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 150),
    child: visible ? child : const SizedBox(width: double.infinity),
  );
}

class _SelectedWordBar extends StatelessWidget {
  const _SelectedWordBar({required this.word});

  final WordRef word;

  @override
  Widget build(BuildContext context) {
    final colors = context.palette.mushaf;
    // Seçim değişince ekran okuyucu yeni kelimeyi duyurur.
    return Semantics(
      liveRegion: true,
      child: Material(
        color: Color.alphaBlend(colors.highlight, colors.background),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              context.l10n.readerSelectedWord(context.formatDigits(word)),
              key: const Key('reader.selectedWord'),
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.text),
            ),
          ),
        ),
      ),
    );
  }
}

/// Bir sayfanın verisini yükleyip çerçevesiyle çizer.
class _PageSlot extends ConsumerWidget {
  const _PageSlot({
    required this.page,
    required this.colors,
    required this.footerSideInset,
  });

  final int page;
  final MushafColors colors;
  final double footerSideInset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(mushafPageProvider(page));
    final surahs = ref.watch(surahByIdProvider);
    final basmala = ref.watch(basmalaTextProvider);

    final error = data.error ?? surahs.error ?? basmala.error;
    if (error != null) {
      return SafeArea(
        child: ErrorState(
          error: error,
          onRetry: () => ref
            ..invalidate(mushafPageProvider(page))
            ..invalidate(surahsProvider)
            ..invalidate(surahByIdProvider)
            ..invalidate(basmalaTextProvider),
        ),
      );
    }
    if (!data.hasValue || !surahs.hasValue || !basmala.hasValue) {
      return ColoredBox(color: colors.background);
    }
    return ColoredBox(
      color: colors.background,
      child: SafeArea(
        child: MushafPageFrame(
          page: data.requireValue,
          surahs: surahs.requireValue,
          colors: colors,
          footerSideInset: footerSideInset,
          child: MushafPageView(
            key: ValueKey('mushafPage.$page'),
            page: data.requireValue,
            surahs: surahs.requireValue,
            basmala: basmala.requireValue,
            colors: colors,
          ),
        ),
      ),
    );
  }
}
