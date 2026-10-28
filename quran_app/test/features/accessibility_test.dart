import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/app.dart';
import 'package:quran_app/core/config/flavor.dart';
import 'package:quran_app/core/config/flavor_provider.dart';
import 'package:quran_app/features/quran/application/quran_providers.dart';
import 'package:quran_app/features/user_data/application/user_data_providers.dart';

import '../helpers/fake_quran_repository.dart';
import '../helpers/localized_app.dart';

/// F0-11 (M13-03, NF-E02): iskelet ekranlarda her dokunulabilir öğenin bir
/// adı var; başlıklar, durumlar ve sayılar ekran okuyucuya anlamlı okunur.
Widget _app(String language) => ProviderScope(
  overrides: [
    flavorProvider.overrideWithValue(Flavor.dev),
    quranRepositoryProvider.overrideWithValue(FakeQuranRepository()),
    userDataSnapshotProvider.overrideWithValue(
      UserDataSnapshot(settings: {'app.language': language}),
    ),
  ],
  child: const QuranApp(),
);

Future<void> _go(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
}

/// Sağdan sola gömme ve kapatma işaretleri.
final _rle = String.fromCharCode(0x202B);
final _pdf = String.fromCharCode(0x202C);
final _newline = String.fromCharCode(0x0A);

void main() {
  for (final language in ['tr', 'ar', 'en']) {
    testWidgets('$language: tüm dokunulabilir öğeler etiketli', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_app(language));
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

      await _go(tester, 'today.settings');
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await _go(tester, 'today.continue');
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });
  }

  testWidgets('F1-01 ekranları: etiket, dokunma alanı ve kontrast kuralları', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_app('tr'));
    await tester.pumpAndSettle();

    Future<void> check(String where) async {
      for (final guideline in [
        labeledTapTargetGuideline,
        androidTapTargetGuideline,
        iOSTapTargetGuideline,
        textContrastGuideline,
      ]) {
        await expectLater(tester, meetsGuideline(guideline), reason: where);
      }
    }

    await check('Bugün');
    await openTab(tester, 'quran');
    await check('Kuran · Sure');
    for (final tab in ['juz', 'page']) {
      await tester.tap(find.byKey(Key('quran.tab.$tab')));
      await tester.pumpAndSettle();
      await check('Kuran · $tab');
    }
    await openTab(tester, 'memorize');
    await check('Hafızlık');
    await openTab(tester, 'me');
    await check('Ben');

    await openTab(tester, 'quran');
    await tester.tap(find.byKey(const Key('quran.tab.surah')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('quran.surah.1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('reader.goTo')));
    await tester.pumpAndSettle();
    await expectLater(
      tester,
      meetsGuideline(labeledTapTargetGuideline),
      reason: 'Git paneli',
    );
    await expectLater(
      tester,
      meetsGuideline(androidTapTargetGuideline),
      reason: 'Git paneli',
    );
    handle.dispose();
  });

  testWidgets('ana sayfa: sure satırı numarasıyla birlikte okunur', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_app('tr'));
    await tester.pumpAndSettle();
    await openTab(tester, 'quran');
    expect(
      tester.getSemantics(find.byKey(const Key('quran.surah.2'))),
      isSemantics(
        // Arapça ad sağdan sola yön işaretleriyle (U+202B…U+202C) okunur.
        label: [
          '2. sure',
          'Bakara',
          'Medenî · 286 ayet',
          '$_rle${'البقرة'}$_pdf',
        ].join(_newline),
        hasTapAction: true,
      ),
    );
    // Simge düğmesinin adı ipucundan (tooltip) gelir; TalkBack okur.
    await openTab(tester, 'today');
    expect(
      tester.getSemantics(find.byKey(const Key('today.settings'))),
      isSemantics(tooltip: 'Ayarlar', isButton: true, hasTapAction: true),
    );
    handle.dispose();
  });

  testWidgets('ayarlar: bölüm adları başlık olarak işaretli', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_app('tr'));
    await tester.pumpAndSettle();
    await _go(tester, 'today.settings');
    for (final title in ['Tema', 'Dil', 'Rakamlar', 'Hakkında']) {
      await tester.scrollUntilVisible(
        find.text(title),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      expect(
        tester.getSemantics(find.text(title)),
        isSemantics(label: title, isHeader: true),
        reason: title,
      );
    }
    handle.dispose();
  });

  testWidgets('okuma: hata durumu canlı bölge olarak duyurulur', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_app('tr'));
    await tester.pumpAndSettle();
    await _go(tester, 'today.continue');
    // Sahte depo sayfa vermez; hata durumu görünür.
    final title = find.text('Bir sorun oluştu').first;
    expect(tester.getSemantics(title), isSemantics(isHeader: true));
    expect(
      find.byWidgetPredicate(
        (w) => w is Semantics && (w.properties.liveRegion ?? false),
      ),
      findsWidgets,
    );
    handle.dispose();
  });

  testWidgets('ayarlar: lisans sayfası açılır', (tester) async {
    await tester.pumpWidget(_app('tr'));
    await tester.pumpAndSettle();
    await _go(tester, 'today.settings');
    await tester.scrollUntilVisible(
      find.byKey(const Key('settings.licenses')),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.byKey(const Key('settings.licenses')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('settings.licenses')));
    // Lisans listesi arka planda yüklenir; pumpAndSettle yerine süreli pump.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(LicensePage), findsOneWidget);
    expect(find.textContaining('DigitalKhatt'), findsWidgets);
  });
}
