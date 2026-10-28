import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/state_views.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/domain/quran_navigation.dart';
import '../application/reader_providers.dart';
import 'reader_page.dart';

/// Okuma rotasının girişi: `/read?ayah=2:255`, `/read?page=50` veya
/// parametresiz (son okunan yer). Bağlantı doğrulanır, okunan konum
/// ayarlanır ve okuma ekranı o ayetin sayfasında açılır (M4-07, M2-15).
/// Geçersiz bağlantıda hata durumu gösterilir.
class ReaderEntry extends ConsumerStatefulWidget {
  const ReaderEntry({this.ayah, this.page, super.key});

  /// `sure:ayet` biçiminde.
  final String? ayah;
  final String? page;

  @override
  ConsumerState<ReaderEntry> createState() => _ReaderEntryState();
}

class _ReaderEntryState extends ConsumerState<ReaderEntry> {
  int? _page;
  bool _invalid = false;

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<void> _resolve() async {
    final repo = ref.read(quranRepositoryProvider);
    int? page;
    try {
      final counts = await ref.read(ayahCountsProvider.future);
      final target = widget.ayah != null
          ? parseJump(
              widget.ayah!,
              ayahCounts: counts,
              pageCount: kDefaultPageCount,
            )
          : widget.page != null
          ? parseJump(
              widget.page!,
              ayahCounts: counts,
              pageCount: kDefaultPageCount,
            )
          : AyahJump(ref.read(readerAnchorProvider));
      switch (target) {
        case AyahJump(:final ayah):
          page = (await repo.pageOf(kDefaultLayoutId, ayah)).valueOrNull;
          if (page != null && mounted) {
            ref.read(readerAnchorProvider.notifier).set(ayah);
          }
        case PageJump(page: final p):
          page = p;
        case null:
          page = null;
      }
    } on Object {
      page = null;
    }
    if (!mounted) return;
    setState(() {
      _page = page;
      _invalid = page == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_invalid) {
      return Scaffold(
        appBar: AppBar(),
        body: ErrorState(message: context.l10n.linkInvalid),
      );
    }
    final page = _page;
    if (page == null) return const Scaffold(body: LoadingState());
    return ReaderPage(initialPage: page);
  }
}
