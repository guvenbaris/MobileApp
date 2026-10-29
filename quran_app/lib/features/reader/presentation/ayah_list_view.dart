import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../quran/domain/quran_models.dart';
import '../../quran/presentation/quarter_l10n.dart';
import '../../quran/presentation/surah_l10n.dart';
import '../application/reader_providers.dart';
import '../application/reader_settings.dart';
import 'mushaf_mark.dart';
import 'tajweed_text.dart';

/// Ayet ayet görünüm (M2-01). Tüm Kur'an tek listededir; açılışta okunan
/// konumdaki ayete gider, kaydırıldıkça en üstteki ayeti konum olarak
/// kaydeder (M2-15).
class AyahListView extends ConsumerStatefulWidget {
  const AyahListView({
    required this.index,
    required this.colors,
    required this.textScale,
    this.autoScrollSpeed,
    this.onAutoScrollEnd,
    super.key,
  });

  final AyahIndex index;
  final MushafColors colors;

  /// Yazı boyutu çarpanı (M2-07).
  final double textScale;

  /// Otomatik kaydırma hızı (piksel/saniye); `null` ise durur (M2-11).
  final double? autoScrollSpeed;

  /// Otomatik kaydırma Kur'an'ın sonuna ulaştı.
  final VoidCallback? onAutoScrollEnd;

  @override
  ConsumerState<AyahListView> createState() => _AyahListViewState();
}

class _AyahListViewState extends ConsumerState<AyahListView> {
  /// Otomatik kaydırma bu sürelik doğrusal adımlarla ilerler; durdurulunca
  /// en geç bu kadar sonra değil, hemen durur (bkz. [_stopAutoScroll]).
  static const _autoScrollStep = Duration(milliseconds: 500);

  final _positions = ItemPositionsListener.create();
  final _offsets = ScrollOffsetController();
  late final int _initialIndex = widget.index.indexOf(
    ref.read(readerAnchorProvider),
  );
  bool _autoScrolling = false;

  @override
  void initState() {
    super.initState();
    _positions.itemPositions.addListener(_onScroll);
    if (widget.autoScrollSpeed != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _runAutoScroll());
    }
  }

  @override
  void didUpdateWidget(AyahListView old) {
    super.didUpdateWidget(old);
    if (widget.autoScrollSpeed != null && old.autoScrollSpeed == null) {
      _runAutoScroll();
    } else if (widget.autoScrollSpeed == null && old.autoScrollSpeed != null) {
      _stopAutoScroll();
    }
  }

  @override
  void dispose() {
    _positions.itemPositions.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final visible = _positions.itemPositions.value.where(
      (p) => p.itemTrailingEdge > 0,
    );
    if (visible.isEmpty) return;
    final top = visible.reduce((a, b) => a.index < b.index ? a : b);
    ref.read(readerAnchorProvider.notifier).set(widget.index.refAt(top.index));
  }

  bool get _atEnd => _positions.itemPositions.value.any(
    (p) => p.index == widget.index.length - 1 && p.itemTrailingEdge <= 1,
  );

  Future<void> _runAutoScroll() async {
    if (_autoScrolling) return;
    _autoScrolling = true;
    try {
      while (mounted && widget.autoScrollSpeed != null) {
        if (_atEnd) {
          widget.onAutoScrollEnd?.call();
          return;
        }
        final seconds = _autoScrollStep.inMilliseconds / 1000;
        await _offsets.animateScroll(
          offset: widget.autoScrollSpeed! * seconds,
          duration: _autoScrollStep,
        );
      }
    } finally {
      _autoScrolling = false;
    }
  }

  /// Süren kaydırma adımını keser: yerinde sıfır süreli kaydırma, devam
  /// eden animasyonu sonlandırır.
  void _stopAutoScroll() {
    if (!_autoScrolling) return;
    _offsets.animateScroll(offset: 0, duration: Duration.zero).ignore();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: widget.colors.background,
      child: ScrollablePositionedList.builder(
        key: const Key('reader.ayahList'),
        itemCount: widget.index.length,
        initialScrollIndex: _initialIndex,
        itemPositionsListener: _positions,
        scrollOffsetController: _offsets,
        itemBuilder: (context, i) => _AyahTile(
          ayahRef: widget.index.refAt(i),
          colors: widget.colors,
          textScale: widget.textScale,
        ),
      ),
    );
  }
}

/// Ayet görünümünde her zaman görünen ince bilgi satırı: okunan ayetin cüzü,
/// hizbi ve sayfası (M2-04).
class AyahInfoLine extends ConsumerWidget {
  const AyahInfoLine({required this.colors, super.key});

  final MushafColors colors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(anchorLocationProvider).value;
    final l10n = context.l10n;
    return ColoredBox(
      color: colors.background,
      child: SizedBox(
        height: 28,
        child: location == null
            ? null
            : Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    [
                      l10n.readerJuzHizb(
                        context.formatInt(location.juz),
                        context.formatInt(location.hizb),
                      ),
                      l10n.readerPageTitle(context.formatInt(location.page)),
                    ].join(' · '),
                    key: const Key('reader.ayahInfo'),
                    style: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(color: colors.ornament),
                  ),
                ),
              ),
      ),
    );
  }
}

class _AyahTile extends ConsumerWidget {
  const _AyahTile({
    required this.ayahRef,
    required this.colors,
    required this.textScale,
  });

  final AyahRef ayahRef;
  final MushafColors colors;
  final double textScale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ayahs = ref.watch(surahAyahsProvider(ayahRef.surah)).value;
    final surah = ref.watch(surahByIdProvider).value?[ayahRef.surah];
    if (ayahs == null || surah == null) {
      return SizedBox(height: 80 * textScale);
    }
    final ayah = ayahs[ayahRef.ayah - 1];
    final quarter = ref.watch(quarterStartByAyahProvider).value?[ayahRef];
    final tajweed = ref.watch(readerSettingsProvider.select((s) => s.tajweed));
    final l10n = context.l10n;
    final markStyle = TextStyle(fontSize: 12, color: colors.ornament);
    // Sure başlığı mushaftaki gibi Arapçadır; arayüz dilindeki ad eklenir.
    final localName = surah.localizedName(context);
    return Padding(
      key: Key('reader.ayah.$ayahRef'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (ayahRef.ayah == 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                [
                  'سُورَةُ ${surah.nameArabic}', // l10n-ignore: mushaf metni
                  if (localName != surah.nameArabic) localName,
                ].join(' · '),
                textAlign: TextAlign.center,
                style: AppTypography.quran(
                  fontSize: AppTypography.quranHeaderSize * textScale,
                  color: colors.ornament,
                ),
              ),
            ),
          // M2-05: rubu' başı, basılı nüshanın kenarındaki hizb notu gibi.
          if (quarter != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: MushafMarkText(
                [(MushafMark.quarter, quarter.label(context))],
                key: Key('reader.quarter.$ayahRef'),
                style: markStyle,
              ),
            ),
          Text.rich(
            tajweed
                ? tajweedTextSpan(
                    ayah.textDigitalKhatt,
                    ayah.tajweed,
                    colors.tajweed,
                  )
                : TextSpan(text: ayah.textDigitalKhatt),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.justify,
            style: AppTypography.quran(
              fontSize: AppTypography.quranAyahSize * textScale,
              height: 1.9,
              color: colors.text,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                context.formatDigits(ayahRef),
                // Ekran okuyucu: "Ayet 2:255" (M13-03).
                semanticsLabel: l10n.readerAyahTitle(
                  context.formatDigits(ayahRef),
                ),
                style: markStyle,
              ),
              if (ayah.sajdah != null) ...[
                const SizedBox(width: AppSpacing.sm),
                MushafMarkText(
                  [(MushafMark.sajdah, l10n.readerSajdah)],
                  key: Key('reader.sajdah.$ayahRef'),
                  style: markStyle,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
