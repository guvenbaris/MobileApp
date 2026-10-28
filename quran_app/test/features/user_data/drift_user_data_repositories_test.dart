import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/database/user_database.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';
import 'package:quran_app/features/user_data/data/drift_user_data_repositories.dart';
import 'package:quran_app/features/user_data/domain/user_data_repositories.dart';

void main() {
  late UserDatabase db;

  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = UserDatabase(NativeDatabase.memory());
    addTearDown(db.close);
  });

  group('yerel kullanıcı (MK-09)', () {
    test('ilk çağrıda UUID ile oluşur, sonra hep aynı kimlik döner', () async {
      final repo = DriftUserProfileRepository(db);
      final first = await repo.ensureLocalUserId();
      expect(
        first,
        matches(RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab]')),
      );
      expect(await repo.ensureLocalUserId(), first);
      expect(await db.select(db.userProfiles).get(), hasLength(1));
    });
  });

  group('ayarlar', () {
    test('JSON değerler yazılıp aynen okunur', () async {
      final repo = DriftSettingsRepository(db);
      await repo.save('reader.theme', 'dark');
      await repo.save('reader.textScale', 1.75);
      await repo.save('flags', {
        'a': true,
        'list': <int>[1, 2],
      });
      expect(await repo.loadAll(), {
        'reader.theme': 'dark',
        'reader.textScale': 1.75,
        'flags': {
          'a': true,
          'list': [1, 2],
        },
      });
    });

    test('güncelleme aynı kaydı değiştirir; createdAt korunur', () async {
      final repo = DriftSettingsRepository(db);
      await repo.save('reader.theme', 'light');
      final before = await db.select(db.settings).getSingle();
      await Future<void>.delayed(const Duration(milliseconds: 5));
      await repo.save('reader.theme', 'sepia');
      final after = await db.select(db.settings).getSingle();

      expect(after.id, before.id);
      expect(after.value, '"sepia"');
      expect(after.createdAt, before.createdAt);
      expect(after.updatedAt.isAfter(before.updatedAt), isTrue);
      expect(after.updatedAt.isUtc, isTrue);
    });
  });

  group('okuma konumu (M2-15)', () {
    test('son okunan yer sure:ayet olarak yazılır ve güncellenir', () async {
      final repo = DriftReadingPositionRepository(db);
      expect(await repo.load(ReadingPositionKind.lastRead), isNull);

      await repo.save(ReadingPositionKind.lastRead, const AyahRef(18, 45));
      expect(
        await repo.load(ReadingPositionKind.lastRead),
        const AyahRef(18, 45),
      );

      await repo.save(ReadingPositionKind.lastRead, const AyahRef(2, 255));
      expect(
        await repo.load(ReadingPositionKind.lastRead),
        const AyahRef(2, 255),
      );
      expect(await db.select(db.readingPositions).get(), hasLength(1));
    });
  });
}
