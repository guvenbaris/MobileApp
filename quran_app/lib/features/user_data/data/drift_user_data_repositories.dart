import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/user_database.dart';
import '../../quran/domain/quran_models.dart';
import '../domain/user_data_repositories.dart';

DateTime _nowUtc() => DateTime.now().toUtc();

class DriftUserProfileRepository implements UserProfileRepository {
  const DriftUserProfileRepository(this._db);

  final UserDatabase _db;

  @override
  Future<String> ensureLocalUserId() => _db.transaction(() async {
    final existing =
        await (_db.select(_db.userProfiles)
              ..where((p) => p.deletedAt.isNull())
              ..orderBy([(p) => OrderingTerm(expression: p.createdAt)])
              ..limit(1))
            .getSingleOrNull();
    if (existing != null) return existing.id;
    final created = await _db
        .into(_db.userProfiles)
        .insertReturning(UserProfilesCompanion.insert());
    return created.id;
  });
}

class DriftSettingsRepository implements SettingsRepository {
  const DriftSettingsRepository(this._db);

  final UserDatabase _db;

  @override
  Future<Map<String, Object?>> loadAll() async {
    final rows = await (_db.select(
      _db.settings,
    )..where((s) => s.deletedAt.isNull())).get();
    return {for (final r in rows) r.key: jsonDecode(r.value)};
  }

  @override
  Future<void> save(String key, Object? value) async {
    final now = _nowUtc();
    await _db
        .into(_db.settings)
        .insert(
          SettingsCompanion.insert(key: key, value: jsonEncode(value)),
          onConflict: DoUpdate(
            (_) => SettingsCompanion(
              value: Value(jsonEncode(value)),
              updatedAt: Value(now),
              deletedAt: const Value(null),
            ),
            target: [_db.settings.key],
          ),
        );
  }
}

class DriftReadingPositionRepository implements ReadingPositionRepository {
  const DriftReadingPositionRepository(this._db);

  final UserDatabase _db;

  @override
  Future<AyahRef?> load(String kind) async {
    final row =
        await (_db.select(_db.readingPositions)
              ..where((r) => r.kind.equals(kind) & r.deletedAt.isNull()))
            .getSingleOrNull();
    return row == null ? null : AyahRef(row.surah, row.ayah);
  }

  @override
  Future<void> save(String kind, AyahRef position, {int? word}) async {
    await _db
        .into(_db.readingPositions)
        .insert(
          ReadingPositionsCompanion.insert(
            kind: kind,
            surah: position.surah,
            ayah: position.ayah,
            word: Value(word),
          ),
          onConflict: DoUpdate(
            (_) => ReadingPositionsCompanion(
              surah: Value(position.surah),
              ayah: Value(position.ayah),
              word: Value(word),
              updatedAt: Value(_nowUtc()),
              deletedAt: const Value(null),
            ),
            target: [_db.readingPositions.kind],
          ),
        );
  }
}

class DriftInstalledPackageRepository implements InstalledPackageRepository {
  const DriftInstalledPackageRepository(this._db);

  final UserDatabase _db;

  @override
  Future<List<InstalledPackage>> list({String? kind}) async {
    final rows =
        await (_db.select(_db.installedPackages)
              ..where(
                (p) =>
                    p.deletedAt.isNull() &
                    (kind == null ? const Constant(true) : p.kind.equals(kind)),
              )
              ..orderBy([(p) => OrderingTerm(expression: p.packageId)]))
            .get();
    return [
      for (final r in rows)
        InstalledPackage(
          packageId: r.packageId,
          kind: r.kind,
          version: r.version,
          fileName: r.fileName,
          sizeBytes: r.sizeBytes,
        ),
    ];
  }

  @override
  Future<void> save(InstalledPackage package) async {
    await _db
        .into(_db.installedPackages)
        .insert(
          InstalledPackagesCompanion.insert(
            packageId: package.packageId,
            kind: package.kind,
            version: package.version,
            fileName: package.fileName,
            sizeBytes: package.sizeBytes,
          ),
          onConflict: DoUpdate(
            (_) => InstalledPackagesCompanion(
              kind: Value(package.kind),
              version: Value(package.version),
              fileName: Value(package.fileName),
              sizeBytes: Value(package.sizeBytes),
              updatedAt: Value(_nowUtc()),
              deletedAt: const Value(null),
            ),
            target: [_db.installedPackages.packageId],
          ),
        );
  }

  @override
  Future<void> remove(String packageId) async {
    final now = _nowUtc();
    await (_db.update(
      _db.installedPackages,
    )..where((p) => p.packageId.equals(packageId))).write(
      InstalledPackagesCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }
}
