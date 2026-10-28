// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/database/user_database.dart';

import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = UserDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  // T-04 temeli: migration sonrası mevcut kullanıcı verisinin hiçbiri
  // kaybolmaz ve değişmez (NF-G02). Her yeni şema sürümünde bu test bir önceki
  // sürümden yeni sürüme doğru genişletilir.
  test('v1 → v2: profiller ve ayarlar eksiksiz korunur', () async {
    const created = '2026-10-28T09:00:00.000Z';
    const updated = '2026-10-28T10:30:00.000Z';
    final oldUserProfilesData = <v1.UserProfilesData>[
      const v1.UserProfilesData(
        id: '6f1c2a3e-0000-4000-8000-000000000001',
        createdAt: created,
        updatedAt: created,
      ),
      // Hesaba bağlanmış ve sonra yumuşak silinmiş profil.
      const v1.UserProfilesData(
        id: '6f1c2a3e-0000-4000-8000-000000000002',
        createdAt: created,
        updatedAt: updated,
        deletedAt: updated,
        accountId: 'account-42',
      ),
    ];
    final expectedNewUserProfilesData = [
      for (final p in oldUserProfilesData)
        v2.UserProfilesData(
          id: p.id,
          createdAt: p.createdAt,
          updatedAt: p.updatedAt,
          deletedAt: p.deletedAt,
          accountId: p.accountId,
        ),
    ];

    final oldSettingsData = <v1.SettingsData>[
      const v1.SettingsData(
        id: '6f1c2a3e-0000-4000-8000-000000000101',
        createdAt: created,
        updatedAt: updated,
        key: 'reader.theme',
        value: '"dark"',
      ),
      const v1.SettingsData(
        id: '6f1c2a3e-0000-4000-8000-000000000102',
        createdAt: created,
        updatedAt: created,
        key: 'reader.textScale',
        value: '1.75',
      ),
    ];
    final expectedNewSettingsData = [
      for (final s in oldSettingsData)
        v2.SettingsData(
          id: s.id,
          createdAt: s.createdAt,
          updatedAt: s.updatedAt,
          deletedAt: s.deletedAt,
          key: s.key,
          value: s.value,
        ),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: UserDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.userProfiles, oldUserProfilesData);
        batch.insertAll(oldDb.settings, oldSettingsData);
      },
      validateItems: (newDb) async {
        expect(
          await newDb.select(newDb.userProfiles).get(),
          expectedNewUserProfilesData,
        );
        expect(
          await newDb.select(newDb.settings).get(),
          expectedNewSettingsData,
        );
        // Yeni tablo boş başlar.
        expect(await newDb.select(newDb.readingPositions).get(), isEmpty);
      },
    );
  });
}
