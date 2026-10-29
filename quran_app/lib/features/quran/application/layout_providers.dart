import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/result/result.dart';
import '../../user_data/application/user_data_providers.dart';
import '../../user_data/domain/user_data_repositories.dart';
import '../data/content_database.dart';
import '../data/layout_package_store.dart';
import '../domain/mushaf_layout.dart';

/// Cihazdaki düzenler ve kurulu paketlerin açık veritabanları (M2-14,
/// TK-13). Yerleşik düzen her zaman ilk sıradadır.
class LayoutCatalog {
  const LayoutCatalog({
    this.layouts = const [kDefaultLayout],
    this.databases = const {},
  });

  final List<MushafLayout> layouts;

  /// Paket düzenlerinin veritabanları: düzen kimliği → veritabanı.
  final Map<String, ContentDatabase> databases;

  MushafLayout? byId(String id) => layouts.where((l) => l.id == id).firstOrNull;
}

/// Açılışta okunan katalog; `bootstrap` içinde override edilir. Varsayılanı
/// yalnızca yerleşik düzendir (testler).
final initialLayoutCatalogProvider = Provider<LayoutCatalog>(
  (ref) => const LayoutCatalog(),
);

/// Paket klasörü ve dosya işlemleri; `bootstrap` içinde override edilir.
final layoutPackageStoreProvider = Provider<LayoutPackageStore>(
  (ref) => throw UnimplementedError(
    'layoutPackageStoreProvider bootstrap içinde override edilmeli',
  ),
);

class LayoutCatalogNotifier extends Notifier<LayoutCatalog> {
  @override
  LayoutCatalog build() => ref.read(initialLayoutCatalogProvider);

  /// Paket dosyasını doğrulayıp kurar, kaydeder ve kataloğa ekler. Aynı
  /// düzenin eski sürümü yerine geçer.
  Future<Result<MushafLayout>> install(File source) async {
    final store = ref.read(layoutPackageStoreProvider);
    final installed = await store.install(source);
    if (installed case Err(:final failure)) return Err(failure);
    final record = installed.valueOrNull!;
    final opened = await store.open(record);
    if (opened case Err(:final failure)) return Err(failure);
    final package = opened.valueOrNull!;
    await ref.read(installedPackageRepositoryProvider).save(record);

    final old = state.databases[record.packageId];
    state = LayoutCatalog(
      layouts: [
        for (final l in state.layouts)
          if (l.id != record.packageId) l,
        package.layout,
      ],
      databases: {...state.databases, record.packageId: package.database},
    );
    await old?.close();
    return Ok(package.layout);
  }

  /// Paketi kaldırır. Seçili düzense okuma yerleşik düzene döner; okunan
  /// ayet ve kayıtlar etkilenmez (M2-15).
  Future<void> remove(String layoutId) async {
    final layout = state.byId(layoutId);
    if (layout == null || layout.isBuiltIn) return;
    final repository = ref.read(installedPackageRepositoryProvider);
    final record = (await repository.list(kind: PackageKind.layout))
        .where((p) => p.packageId == layoutId)
        .firstOrNull;
    final db = state.databases[layoutId];
    state = LayoutCatalog(
      layouts: [
        for (final l in state.layouts)
          if (l.id != layoutId) l,
      ],
      databases: {...state.databases}..remove(layoutId),
    );
    await db?.close();
    if (record != null) {
      await ref.read(layoutPackageStoreProvider).delete(record);
      await repository.remove(layoutId);
    }
  }
}

final layoutCatalogProvider =
    NotifierProvider<LayoutCatalogNotifier, LayoutCatalog>(
      LayoutCatalogNotifier.new,
    );

/// Kullanıcının seçtiği düzen (M2-14); kalıcıdır (M13-02).
class LayoutSelectionNotifier extends Notifier<String> {
  static const key = 'mushaf.layoutId';

  @override
  String build() => switch (ref.read(userDataSnapshotProvider).settings[key]) {
    final String id => id,
    _ => kDefaultLayout.id,
  };

  void select(String layoutId) {
    state = layoutId;
    persistSetting(ref, key, layoutId);
  }
}

final layoutSelectionProvider =
    NotifierProvider<LayoutSelectionNotifier, String>(
      LayoutSelectionNotifier.new,
    );

/// Okumada kullanılan düzen: seçilen düzen cihazda yoksa (paket silinmiş,
/// içerikle uyumsuz) yerleşik düzen. Seçim kaydı silinmez; paket geri
/// gelirse yine o düzen açılır.
final currentLayoutProvider = Provider<MushafLayout>((ref) {
  final catalog = ref.watch(layoutCatalogProvider);
  return catalog.byId(ref.watch(layoutSelectionProvider)) ??
      catalog.byId(kDefaultLayout.id) ??
      kDefaultLayout;
});

/// Açılışta kurulu düzen paketlerini açar. Açılamayan paket (dosya yok,
/// içerik güncellenip uyumsuz kaldı) atlanır ve loglanır; kayıt korunur,
/// uygulama yerleşik düzenle çalışmaya devam eder.
Future<LayoutCatalog> loadLayoutCatalog({
  required ContentDatabase content,
  required LayoutPackageStore store,
  required InstalledPackageRepository packages,
  required AppLogger logger,
}) async {
  final layouts = <MushafLayout>[kDefaultLayout];
  final databases = <String, ContentDatabase>{};
  for (final record in await packages.list(kind: PackageKind.layout)) {
    switch (await store.open(record)) {
      case Ok(:final value):
        layouts.add(value.layout);
        databases[record.packageId] = value.database;
      case Err(:final failure):
        logger.warning('Düzen paketi açılamadı', error: failure);
    }
  }
  return LayoutCatalog(layouts: layouts, databases: databases);
}
