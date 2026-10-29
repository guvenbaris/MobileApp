import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/app.dart';
import 'package:quran_app/core/config/flavor.dart';
import 'package:quran_app/core/config/flavor_provider.dart';
import 'package:quran_app/core/platform/wake_lock.dart';
import 'package:quran_app/core/routing/app_router.dart';
import 'package:quran_app/features/quran/application/layout_providers.dart';
import 'package:quran_app/features/quran/application/quran_providers.dart';
import 'package:quran_app/features/quran/domain/mushaf_layout.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';
import 'package:quran_app/features/reader/application/reader_providers.dart';
import 'package:quran_app/features/user_data/application/user_data_providers.dart';

import '../../helpers/fake_quran_repository.dart';
import '../../helpers/fake_wake_lock.dart';
import '../../helpers/localized_app.dart';

/// F1-03, KK M2-15: düzen değişince okuma aynı ayette kalır; sayfa
/// numarası yeni düzene göre değişir. Sahte depoda ikinci düzen sayfaları
/// ikişer birleştirir: Bakara 150, Medine'de 16., ikinci düzende 8. sayfa.
const _bakara150 = AyahRef(2, 150);
const _half = FakeQuranRepository.half;

Widget _app({String? layoutId}) => ProviderScope(
  overrides: [
    flavorProvider.overrideWithValue(Flavor.dev),
    quranRepositoryProvider.overrideWithValue(
      FakeQuranRepository(withPages: true, halfLayout: true),
    ),
    initialLayoutCatalogProvider.overrideWithValue(
      const LayoutCatalog(layouts: [kDefaultLayout, _half]),
    ),
    userDataSnapshotProvider.overrideWithValue(
      UserDataSnapshot(
        settings: {'app.language': 'tr', 'mushaf.layoutId': ?layoutId},
      ),
    ),
    wakeLockProvider.overrideWithValue(FakeWakeLock()),
  ],
  child: const QuranApp(),
);

ProviderContainer _container(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(QuranApp)));

Future<void> _open(
  WidgetTester tester,
  String location, {
  String? layoutId,
}) async {
  tester.view.devicePixelRatio = 2;
  tester.view.physicalSize = const Size(411, 914) * 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_app(layoutId: layoutId));
  await tester.pumpAndSettle();
  _container(tester).read(appRouterProvider).push(location).ignore();
  await tester.pumpAndSettle();
}

String _title(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const Key('reader.title'))).data!;

Future<void> _chooseLayout(WidgetTester tester, String id) async {
  await tester.tap(find.byKey(const Key('reader.settings')));
  await tester.pumpAndSettle();
  final option = find.byKey(Key('readerSettings.layout.$id'));
  await tester.ensureVisible(option);
  await tester.pumpAndSettle();
  await tester.tap(option);
  await tester.pumpAndSettle();
  await tester.tapAt(const Offset(200, 40)); // paneli kapat
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('düzen değişince aynı ayette kalınır, sayfa yeni düzenden', (
    tester,
  ) async {
    await _open(tester, '/read?ayah=2:150');
    expect(_title(tester), startsWith('Sayfa 16'));

    await _chooseLayout(tester, _half.id);
    expect(_container(tester).read(currentLayoutProvider), _half);
    expect(_container(tester).read(readerAnchorProvider), _bakara150);
    expect(_title(tester), startsWith('Sayfa 8'));
    // Sayfa ve sayfa altındaki numara yeni düzenden.
    expect(find.byKey(const Key('reader.pageFooter.8')), findsOneWidget);

    // Ayet görünümüne gidip dönmek de yeni düzende aynı sayfayı açar.
    await tester.tap(find.byKey(const Key('reader.viewMode')));
    await tester.pumpAndSettle();
    expect(_title(tester), 'Ayet 2:150');
    await tester.tap(find.byKey(const Key('reader.viewMode')));
    await tester.pumpAndSettle();
    expect(_title(tester), startsWith('Sayfa 8'));

    await _chooseLayout(tester, kDefaultLayout.id);
    expect(_container(tester).read(readerAnchorProvider), _bakara150);
    expect(_title(tester), startsWith('Sayfa 16'));
  });

  testWidgets('seçili düzen açılışta geçerli: dizin, Git paneli, bağlantı', (
    tester,
  ) async {
    await _open(tester, '/read?page=8', layoutId: _half.id);
    // /read?page=8 ikinci düzenin 8. sayfası: Medine 15. sayfanın ilk ayeti.
    expect(
      _container(tester).read(readerAnchorProvider),
      const AyahRef(2, 131),
    );
    expect(_title(tester), startsWith('Sayfa 8'));

    // Git paneli düzenin sayfa sayısını gösterir ve aşan sayfayı reddeder.
    await tester.tap(find.byKey(const Key('reader.goTo')));
    await tester.pumpAndSettle();
    expect(find.text('1–15'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('goTo.page')), '16');
    await tester.tap(find.byKey(const Key('goTo.pageGo')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('goTo.page')), findsOneWidget);
    await tester.tapAt(const Offset(200, 40));
    await tester.pumpAndSettle();

    // Kur'an dizinindeki sayfa ızgarası da düzenin sayfa sayısında.
    await tapBack(tester);
    await openTab(tester, 'quran');
    await tester.tap(find.byKey(const Key('quran.tab.page')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('quran.page.15')),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.byKey(const Key('quran.page.15')), findsOneWidget);
    expect(find.byKey(const Key('quran.page.16')), findsNothing);
  });

  testWidgets('seçili düzen cihazda yoksa yerleşik düzen açılır', (
    tester,
  ) async {
    await _open(tester, '/read?ayah=2:150', layoutId: 'silinmis_paket');
    expect(_container(tester).read(currentLayoutProvider), kDefaultLayout);
    expect(_title(tester), startsWith('Sayfa 16'));
  });
}
