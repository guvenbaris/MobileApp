import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/database/user_database.dart';
import 'package:quran_app/core/logging/app_logger.dart';
import 'package:quran_app/core/result/result.dart';
import 'package:quran_app/features/quran/application/layout_providers.dart';
import 'package:quran_app/features/quran/application/quran_providers.dart';
import 'package:quran_app/features/quran/data/content_database.dart';
import 'package:quran_app/features/quran/data/drift_quran_repository.dart';
import 'package:quran_app/features/quran/data/layout_package_inbox.dart';
import 'package:quran_app/features/quran/data/layout_package_store.dart';
import 'package:quran_app/features/quran/domain/mushaf_layout.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';
import 'package:quran_app/features/user_data/application/user_data_providers.dart';
import 'package:quran_app/features/user_data/data/drift_user_data_repositories.dart';
import 'package:quran_app/features/user_data/domain/user_data_repositories.dart';

import '../../helpers/content_db.dart';
import '../../helpers/layout_package.dart';

/// F1-03: indirilebilir düzen paketleri (TK-13) ve düzen değişince konumun
/// korunması (M2-14, M2-15). Gerçek içerik veritabanı ve ondan türetilen
/// "birleşik sayfalar" test düzeniyle (302 sayfa).
void main() {
  late ContentDatabase content;
  late Directory temp;
  late LayoutPackageStore store;

  setUp(() {
    content = openTestContentDatabase();
    temp = Directory.systemTemp.createTempSync('layout_pkg_');
    addTearDown(() => temp.deleteSync(recursive: true));
    store = LayoutPackageStore(
      content,
      directory: Directory('${temp.path}/packages/layout'),
    );
  });

  Directory source() => Directory('${temp.path}/source')..createSync();

  Future<OpenedLayoutPackage> installAndOpen() async {
    final file = await buildMergedLayoutPackage(content, source());
    final record = (await store.install(file)).valueOrNull!;
    final opened = (await store.open(record)).valueOrNull!;
    addTearDown(opened.database.close);
    return opened;
  }

  group('paket deposu', () {
    test('geçerli paket kurulur ve açılır', () async {
      final file = await buildMergedLayoutPackage(content, source());
      final result = await store.install(file);
      final record = result.valueOrNull!;
      expect(record.packageId, 'test_merged');
      expect(record.kind, PackageKind.layout);
      expect(record.fileName, 'test_merged_v1.sqlite');
      expect(
        File('${store.directory.path}/${record.fileName}').existsSync(),
        isTrue,
      );

      final opened = (await store.open(record)).valueOrNull!;
      addTearDown(opened.database.close);
      expect(opened.layout.pageCount, 302);
      expect(opened.layout.linesPerPage, 30);
      expect(opened.layout.isBuiltIn, isFalse);
    });

    test('yeni sürüm eskisinin yerine geçer', () async {
      await store.install(await buildMergedLayoutPackage(content, source()));
      final v2 = await store.install(
        await buildMergedLayoutPackage(content, source(), version: 2),
      );
      expect(v2.valueOrNull!.version, 2);
      final files = store.directory.listSync().map(
        (f) => f.uri.pathSegments.last,
      );
      expect(files, ['test_merged_v2.sqlite']);
    });

    final invalid = <String, Future<File> Function(ContentDatabase, Directory)>{
      'başka içerikle üretilmiş (kelime parmak izi farklı)': (c, d) =>
          buildMergedLayoutPackage(c, d, wordsHash: 'baska'),
      'düzen paketi değil': (c, d) =>
          buildMergedLayoutPackage(c, d, kind: 'translation'),
      'yerleşik düzenin kimliğini taşıyor': (c, d) =>
          buildMergedLayoutPackage(c, d, id: kDefaultLayout.id),
      'kimlik ile düzen kaydı farklı': (c, d) =>
          buildMergedLayoutPackage(c, d, layoutId: 'baska_duzen'),
      'desteklenmeyen font': (c, d) =>
          buildMergedLayoutPackage(c, d, fontPack: 'qcf_v2'),
    };
    for (final MapEntry(key: reason, value: build) in invalid.entries) {
      test('reddedilir: $reason', () async {
        final result = await store.install(await build(content, source()));
        expect(result, isA<Err<InstalledPackage>>());
        expect(
          (result as Err<InstalledPackage>).failure,
          isA<InvalidPackageFailure>(),
        );
        expect(
          store.directory.existsSync() && store.directory.listSync().isNotEmpty,
          isFalse,
        );
      });
    }

    test('dosyası silinmiş kayıt açılmaz', () async {
      final file = await buildMergedLayoutPackage(content, source());
      final record = (await store.install(file)).valueOrNull!;
      await store.delete(record);
      expect(await store.open(record), isA<Err<OpenedLayoutPackage>>());
    });
  });

  group('depo: paketteki düzen (M2-14)', () {
    late DriftQuranRepository repo;
    const merged = 'test_merged';

    setUp(() async {
      final opened = await installAndOpen();
      repo = DriftQuranRepository(
        content,
        layoutDatabases: {merged: opened.database},
      );
    });

    test('düzen listesinde yerleşik ve paket düzeni', () async {
      final layouts = (await repo.getLayouts()).valueOrNull!;
      expect(layouts.map((l) => (l.id, l.isBuiltIn)), [
        (kDefaultLayout.id, true),
        (merged, false),
      ]);
    });

    test('KK M2-15: Kehf 45 iki düzende farklı sayfada, aynı ayet', () async {
      const kehf45 = AyahRef(18, 45);
      final medina = (await repo.pageOf(
        kDefaultLayout.id,
        kehf45,
      )).valueOrNull!;
      final other = (await repo.pageOf(merged, kehf45)).valueOrNull!;
      expect(medina, 298);
      expect(other, 149);
      // Sayfadan konuma dönüş de tutarlı: birleşik 149. sayfa, Medine 297'nin
      // ilk ayetiyle başlar.
      expect(
        (await repo.firstAyahOfPage(merged, 149)).valueOrNull,
        (await repo.firstAyahOfPage(kDefaultLayout.id, 297)).valueOrNull,
      );
    });

    test('sayfa çizim verisi paketten, metin içerikten', () async {
      final page = (await repo.getMushafPage(merged, 149)).valueOrNull!;
      expect(page.layoutId, merged);
      expect(page.lines, hasLength(30));
      final words = page.lines.expand((l) => l.words).map((w) => w.ref.ayahRef);
      expect(words, contains(const AyahRef(18, 45)));
      expect(
        page.lines.expand((l) => l.glyphs).first.digitalKhattText,
        isNotEmpty,
      );
    });

    test('rubu\' başları paket düzeninin sayfalarıyla', () async {
      final medina = (await repo.quarterStarts(kDefaultLayout.id)).valueOrNull!;
      final other = (await repo.quarterStarts(merged)).valueOrNull!;
      expect(other, hasLength(240));
      for (final (i, q) in other.indexed) {
        expect(q.start, medina[i].start);
        expect(q.page, (medina[i].page + 1) ~/ 2, reason: 'rubu\' ${q.rub}');
      }
    });
  });

  group('katalog ve seçim', () {
    late UserDatabase userDb;

    setUp(() {
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      userDb = UserDatabase(NativeDatabase.memory());
      addTearDown(userDb.close);
    });

    ProviderContainer container({
      LayoutCatalog catalog = const LayoutCatalog(),
      Map<String, Object?> settings = const {},
    }) {
      final c = ProviderContainer(
        overrides: [
          contentDatabaseProvider.overrideWithValue(content),
          userDatabaseProvider.overrideWithValue(userDb),
          userDataSnapshotProvider.overrideWithValue(
            UserDataSnapshot(settings: settings),
          ),
          layoutPackageStoreProvider.overrideWithValue(store),
          initialLayoutCatalogProvider.overrideWithValue(catalog),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    test(
      'kurulan düzen seçilebilir; kaldırılınca yerleşik düzene dönülür',
      () async {
        final c = container();
        expect(c.read(currentLayoutProvider), kDefaultLayout);

        final file = await buildMergedLayoutPackage(content, source());
        final installed = await c
            .read(layoutCatalogProvider.notifier)
            .install(file);
        expect(installed.valueOrNull!.id, 'test_merged');
        expect(
          (await DriftInstalledPackageRepository(
            userDb,
          ).list()).single.packageId,
          'test_merged',
        );

        c.read(layoutSelectionProvider.notifier).select('test_merged');
        expect(c.read(currentLayoutProvider).id, 'test_merged');
        // Okuma sayfası seçilen düzenden okunur.
        final page = await c
            .read(quranRepositoryProvider)
            .pageOf(c.read(currentLayoutProvider).id, const AyahRef(18, 45));
        expect(page.valueOrNull, 149);

        await c.read(layoutCatalogProvider.notifier).remove('test_merged');
        expect(c.read(currentLayoutProvider), kDefaultLayout);
        // Seçim kaydı korunur; paket yeniden kurulursa o düzen açılır.
        expect(c.read(layoutSelectionProvider), 'test_merged');
        expect(await DriftInstalledPackageRepository(userDb).list(), isEmpty);
        expect(store.directory.listSync(), isEmpty);
      },
    );

    test('seçim yeniden açılışta korunur (M13-02)', () async {
      final first = container();
      first.read(layoutSelectionProvider.notifier).select('test_merged');
      first.dispose();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      final snapshot = await UserDataSnapshot.load(userDb);
      final second = container(settings: snapshot.settings);
      expect(second.read(layoutSelectionProvider), 'test_merged');
      // Paket yokken yerleşik düzen.
      expect(second.read(currentLayoutProvider), kDefaultLayout);
    });

    test('açılışta uyumsuz paket atlanır, kaydı korunur', () async {
      final packages = DriftInstalledPackageRepository(userDb);
      final good = (await store.install(
        await buildMergedLayoutPackage(content, source()),
      )).valueOrNull!;
      await packages.save(good);
      // Kaydı bozuk bir dosyaya işaret eden ikinci paket.
      await packages.save(
        const InstalledPackage(
          packageId: 'kayip',
          kind: PackageKind.layout,
          version: 1,
          fileName: 'kayip_v1.sqlite',
          sizeBytes: 0,
        ),
      );
      final catalog = await loadLayoutCatalog(
        content: content,
        store: store,
        packages: packages,
        logger: const ConsoleAppLogger(minLevel: LogLevel.error),
      );
      addTearDown(() async {
        for (final db in catalog.databases.values) {
          await db.close();
        }
      });
      expect(catalog.layouts.map((l) => l.id), [
        kDefaultLayout.id,
        'test_merged',
      ]);
      expect(
        (await packages.list()).map((p) => p.packageId),
        containsAll(['kayip', 'test_merged']),
      );
    });

    test(
      'geliştirme gelen kutusu: paket kurulur, dosya kutudan silinir',
      () async {
        final inbox = source();
        await buildMergedLayoutPackage(content, inbox);
        File('${inbox.path}/not.txt').writeAsStringSync('paket değil');
        final packages = MemoryInstalledPackageRepository();
        await installLayoutPackagesFromInbox(
          inbox: inbox,
          store: store,
          packages: packages,
          logger: const ConsoleAppLogger(minLevel: LogLevel.error),
        );
        expect(packages.records.keys, ['test_merged']);
        expect(inbox.listSync().map((f) => f.uri.pathSegments.last), [
          'not.txt',
        ]);
      },
    );
  });
}
