import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../quran/domain/quran_models.dart';
import '../application/reader_providers.dart';
import 'mushaf_colors.dart';
import 'mushaf_page_view.dart';

/// Ayet ayet görünüm (M2-01). Tüm Kur'an tek listededir; açılışta okunan
/// konumdaki ayete gider, kaydırıldıkça en üstteki ayeti konum olarak
/// kaydeder (M2-15).
class AyahListView extends ConsumerStatefulWidget {
  const AyahListView({
    required this.index,
    required this.colors,
    required this.textScale,
    super.key,
  });

  final AyahIndex index;
  final MushafColors colors;

  /// Yazı boyutu çarpanı (M2-07).
  final double textScale;

  @override
  ConsumerState<AyahListView> createState() => _AyahListViewState();
}

class _AyahListViewState extends ConsumerState<AyahListView> {
  final _positions = ItemPositionsListener.create();
  late final int _initialIndex = widget.index.indexOf(
    ref.read(readerAnchorProvider),
  );

  @override
  void initState() {
    super.initState();
    _positions.itemPositions.addListener(_onScroll);
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

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: widget.colors.background,
      child: ScrollablePositionedList.builder(
        key: const Key('reader.ayahList'),
        itemCount: widget.index.length,
        initialScrollIndex: _initialIndex,
        itemPositionsListener: _positions,
        itemBuilder: (context, i) => _AyahTile(
          ayahRef: widget.index.refAt(i),
          colors: widget.colors,
          textScale: widget.textScale,
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
                'سُورَةُ ${surah.nameArabic} · ${surah.nameTr}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: kQuranFontFamily,
                  fontSize: 22 * textScale,
                  wordSpacing: 22 * textScale * kQuranWordSpacing,
                  color: colors.ornament,
                ),
              ),
            ),
          Text(
            ayah.textDigitalKhatt,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: kQuranFontFamily,
              fontSize: 26 * textScale,
              height: 1.9,
              wordSpacing: 26 * textScale * kQuranWordSpacing,
              color: colors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$ayahRef',
            style: TextStyle(fontSize: 12, color: colors.ornament),
          ),
        ],
      ),
    );
  }
}
