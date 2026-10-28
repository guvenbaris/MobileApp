// Basılı nüsha karşılaştırma paketi (F1-00, F0-05'ten devredilen doğrulama).
//
// Seçilen 7 mushaf sayfasını uygulamadaki gibi (gerçek veri + DigitalKhatt)
// PNG olarak çizer ve her satırın ilk/son kelimesini listeleyen bir kontrol
// çizelgesi yazar. Çıktı: `build/page_check/`.
//
// Normal `flutter test` çalışmasında atlanır. Çalıştırma (quran_app içinde):
//   PowerShell:  $env:PAGE_SHEET=1; flutter test test/manual/page_sheet_test.dart
//   Bash:        PAGE_SHEET=1 flutter test test/manual/page_sheet_test.dart
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/result/result.dart';
import 'package:quran_app/core/theme/app_theme.dart';
import 'package:quran_app/features/quran/application/quran_providers.dart';
import 'package:quran_app/features/quran/data/drift_quran_repository.dart';
import 'package:quran_app/features/quran/domain/mushaf_page.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';
import 'package:quran_app/features/reader/presentation/mushaf_page_view.dart';

import '../helpers/content_db.dart';
import '../helpers/localized_app.dart';

const _outDir = 'build/page_check';

/// Telefon ekranı (mantıksal piksel) ve çıktı ölçeği.
const _screen = Size(411, 860);
const _pixelRatio = 3.0;

T _value<T>(Result<T> r) => switch (r) {
  Ok(:final value) => value,
  Err(:final failure) => throw StateError('$failure'),
};

void main() {
  final enabled = Platform.environment['PAGE_SHEET'] == '1';

  testWidgets('basılı nüsha karşılaştırma paketi üretilir', skip: !enabled, (
    tester,
  ) async {
    final db = openTestContentDatabase();
    final repo = DriftQuranRepository(db);

    // Veritabanı ve font yüklemesi gerçek G/Ç'dir; runAsync içinde yapılır.
    final data = await tester.runAsync(() async {
      final font = FontLoader(kQuranFontFamily)
        ..addFont(rootBundle.load('assets/fonts/DigitalKhattV2.otf'));
      await font.load();

      final surahs = _value(await repo.getSurahs());
      Future<int> pageOf(int s, int a) async =>
          _value(await repo.pageOf(kDefaultLayoutId, AyahRef(s, a)));

      // Seçim: ilk iki sayfa ve düzenin özel durumlarını kapsayan 5 sayfa.
      final pages = <int, String>{
        1: 'Fatiha: ortalı satırlar, sure başlığı',
        2: 'Bakara başı: sure başlığı ve besmele',
        await pageOf(7, 206): 'İlk secde ayeti (7:206)',
        await pageOf(9, 1): 'Tevbe başı: besmelesiz sure',
        254: 'Tek düzen düzeltmesinin yapıldığı sayfa (Q-13, 13:37)',
        await pageOf(36, 1): 'Yasin başı',
        604: 'Son sayfa: üç kısa sure, ortalı satırlar',
      };
      final loaded = <int, MushafPage>{
        for (final p in pages.keys)
          p: _value(await repo.getMushafPage(kDefaultLayoutId, p)),
      };
      final first = loaded[1]!.lines.expand((l) => l.glyphs).take(4);
      final basmala = first.map((g) => g.digitalKhattText ?? '').join(' ');
      return (
        surahs: {for (final s in surahs) s.id: s},
        pages: pages,
        loaded: loaded,
        basmala: basmala,
      );
    });
    final (:surahs, :pages, :loaded, :basmala) = data!;

    Directory(_outDir).createSync(recursive: true);
    tester.view
      ..physicalSize = _screen * _pixelRatio
      ..devicePixelRatio = _pixelRatio;
    addTearDown(tester.view.reset);

    final sheet = StringBuffer()
      ..writeln('# Basılı nüsha karşılaştırması')
      ..writeln()
      ..writeln(
        'Düzen: Medine 1421H (QUL) · Font: DigitalKhatt · '
        'Üretim: ${DateTime.now().toIso8601String().substring(0, 16)}',
      )
      ..writeln()
      ..writeln(
        'Her sayfa için basılı Medine mushafını (1421H baskısı) aynı '
        'sayfada açın ve kontrol edin: (1) sayfanın ilk ve son kelimesi, '
        '(2) her satırın ilk ve son kelimesi, (3) sure başlığı ve besmele '
        'satırlarının yeri, (4) ortalı satırlar. Fark varsa satır '
        'numarasıyla not edin.',
      )
      ..writeln();

    for (final MapEntry(key: number, value: reason) in pages.entries) {
      final page = loaded[number]!;
      final boundary = GlobalKey();
      await tester.pumpWidget(
        ProviderScope(
          child: localizedApp(
            RepaintBoundary(
              key: boundary,
              // Uygulamadaki gibi Material altında (metin stili için).
              child: Material(
                child: MushafPageView(
                  page: page,
                  surahs: surahs,
                  basmala: basmala,
                  colors: AppPalette.light.mushaf,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final file = 'page_${number.toString().padLeft(3, '0')}.png';
      await tester.runAsync(() async {
        final render =
            boundary.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        final image = await render.toImage(pixelRatio: _pixelRatio);
        final png = await image.toByteData(format: ui.ImageByteFormat.png);
        File('$_outDir/$file').writeAsBytesSync(png!.buffer.asUint8List());
        image.dispose();
      });

      sheet
        ..writeln('## Sayfa $number: $reason')
        ..writeln()
        ..writeln('![Sayfa $number]($file)')
        ..writeln()
        ..writeln(
          'İlk ayet: ${page.firstAyah} · Cüz ${page.juz} · '
          'Hizb ${page.hizb}',
        )
        ..writeln()
        ..writeln('| Satır | Tür | İlk kelime | Son kelime | Basılı nüsha |')
        ..writeln('|---|---|---|---|---|');
      for (final line in page.lines) {
        final (kind, firstWord, lastWord) = switch (line.type) {
          LayoutLineType.surahName => (
            'sure başlığı',
            surahs[line.surah]?.nameArabic ?? '',
            '',
          ),
          LayoutLineType.basmala => ('besmele', '', ''),
          LayoutLineType.ayah => (
            line.isCentered ? 'ayet (ortalı)' : 'ayet',
            line.glyphs.first.digitalKhattText ?? '',
            line.glyphs.last.digitalKhattText ?? '',
          ),
        };
        sheet.writeln(
          '| ${line.number} | $kind | $firstWord | $lastWord | ☐ aynı |',
        );
      }
      sheet.writeln();
    }

    File('$_outDir/README.md').writeAsStringSync(sheet.toString());
    // ignore: avoid_print
    print('Yazıldı: $_outDir (${pages.length} sayfa)');
  });
}
