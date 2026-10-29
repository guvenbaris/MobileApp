import 'dart:io';

import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

import '../../../core/result/result.dart';
import '../../user_data/domain/user_data_repositories.dart';
import '../domain/mushaf_layout.dart';
import 'content_database.dart';

/// Kurulmuş ve açılmış bir düzen paketi.
class OpenedLayoutPackage {
  const OpenedLayoutPackage({
    required this.record,
    required this.layout,
    required this.database,
  });

  final InstalledPackage record;
  final MushafLayout layout;
  final ContentDatabase database;
}

/// İndirilebilir düzen paketlerinin dosyaları (TK-13, M2-14).
///
/// Paket, içerik veritabanıyla aynı şemada bir SQLite dosyasıdır; yalnızca
/// tek bir düzenin `mushaf_layouts`, `layout_*` satırlarını ve
/// `content_meta` içinde kimliğini taşır. Glifler esas kelimelere
/// `words.id` ile bağlıdır; bu yüzden paket ancak aynı kelime parmak izini
/// (`wordsHash`) taşıyan içerikle kullanılır. İçerik veritabanı salt okunur
/// kalır (MK-05); paket ayrı açılır.
class LayoutPackageStore {
  LayoutPackageStore(this._content, {required this.directory});

  /// Uygulamanın paket klasörü (ör. `<destek>/packages/layout`).
  final Directory directory;
  final ContentDatabase _content;

  /// [source] dosyasını doğrular ve paket klasörüne kopyalar. Aynı kimlikli
  /// eski sürüm varsa yenisi doğrulandıktan sonra silinir. Kaydı yazmak
  /// çağıranın işidir.
  Future<Result<InstalledPackage>> install(File source) async {
    final inspected = await _inspect(source);
    if (inspected case Err(:final failure)) return Err(failure);
    final (:id, :version, layout: _) = inspected.valueOrNull!;

    await directory.create(recursive: true);
    final fileName = '${id}_v$version.sqlite';
    final target = File(p.join(directory.path, fileName));
    final temp = File('${target.path}.tmp');
    try {
      await source.copy(temp.path);
      await temp.rename(target.path);
      await for (final old in directory.list()) {
        final name = p.basename(old.path);
        if (old is File && name.startsWith('${id}_v') && name != fileName) {
          await old.delete();
        }
      }
    } on FileSystemException catch (e, st) {
      if (temp.existsSync()) await temp.delete();
      return Err(
        UnexpectedFailure('Paket kopyalanamadı', error: e, stackTrace: st),
      );
    }
    return Ok(
      InstalledPackage(
        packageId: id,
        kind: PackageKind.layout,
        version: version,
        fileName: fileName,
        sizeBytes: await target.length(),
      ),
    );
  }

  /// Kurulu paketi salt okunur açar; dosya yoksa veya içerikle uyumsuzsa
  /// (ör. içerik güncellendi, kelimeler değişti) hata döner.
  Future<Result<OpenedLayoutPackage>> open(InstalledPackage record) async {
    final file = File(p.join(directory.path, record.fileName));
    final inspected = await _inspect(file);
    if (inspected case Err(:final failure)) return Err(failure);
    final info = inspected.valueOrNull!;
    if (info.id != record.packageId) {
      return Err(InvalidPackageFailure('Kayıt ve dosya farklı: ${info.id}'));
    }
    return Ok(
      OpenedLayoutPackage(
        record: record,
        layout: info.layout,
        database: _openReadOnly(file),
      ),
    );
  }

  /// Paket dosyasını siler (kayıt çağıranca silinir).
  Future<void> delete(InstalledPackage record) async {
    final file = File(p.join(directory.path, record.fileName));
    if (file.existsSync()) await file.delete();
  }

  static ContentDatabase _openReadOnly(File file) => ContentDatabase(
    NativeDatabase(file, setup: (db) => db.execute('PRAGMA query_only = ON')),
  );

  /// Paketin kimliğini ve düzenini okur; şemayı, türü ve içerikle uyumu
  /// denetler.
  Future<Result<({String id, int version, MushafLayout layout})>> _inspect(
    File file,
  ) async {
    if (!file.existsSync()) {
      return Err(InvalidPackageFailure('Paket dosyası yok: ${file.path}'));
    }
    final db = _openReadOnly(file);
    try {
      final meta = {
        for (final row in await db.select(db.contentMeta).get())
          row.key: row.value,
      };
      final contentMeta = await (_content.select(
        _content.contentMeta,
      )..where((m) => m.key.equals(ContentMetaKeys.wordsHash))).getSingle();

      final id = meta[ContentMetaKeys.packageId];
      final version = int.tryParse(meta[ContentMetaKeys.packageVersion] ?? '');
      if (meta[ContentMetaKeys.packageKind] != PackageKind.layout ||
          id == null ||
          id.isEmpty ||
          version == null) {
        return const Err(InvalidPackageFailure('Düzen paketi değil'));
      }
      if (id == kDefaultLayout.id) {
        return Err(InvalidPackageFailure('Yerleşik düzenin kimliği: $id'));
      }
      if (meta[ContentMetaKeys.wordsHash] != contentMeta.value) {
        return Err(
          InvalidPackageFailure('$id bu içerik sürümüyle uyumsuz (kelimeler)'),
        );
      }
      final rows = await db.select(db.mushafLayouts).get();
      if (rows.length != 1 || rows.single.id != id) {
        return Err(InvalidPackageFailure('$id: düzen kaydı yok'));
      }
      final row = rows.single;
      // Uygulamada yalnız bu font var; başka font isteyen düzen yanlış çizilir.
      if (row.fontPack != kDefaultLayout.fontPack) {
        return Err(
          InvalidPackageFailure('$id: desteklenmeyen font ${row.fontPack}'),
        );
      }
      final pageCount = await db
          .customSelect(
            'SELECT COUNT(*) AS c FROM layout_pages WHERE layout_id = ?1',
            variables: [Variable.withString(id)],
          )
          .getSingle();
      if (pageCount.read<int>('c') != row.pageCount) {
        return Err(InvalidPackageFailure('$id: sayfa sayısı tutmuyor'));
      }
      return Ok((
        id: id,
        version: version,
        layout: MushafLayout(
          id: row.id,
          name: row.name,
          pageCount: row.pageCount,
          linesPerPage: row.linesPerPage,
          fontPack: row.fontPack,
          version: row.version,
          isBuiltIn: false,
        ),
      ));
    } on Exception catch (e, st) {
      return Err(
        UnexpectedFailure(
          'Paket okunamadı: ${file.path}',
          error: e,
          stackTrace: st,
        ),
      );
    } finally {
      await db.close();
    }
  }
}
