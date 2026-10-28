import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/database/user_database.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';
import 'package:quran_app/features/reader/application/reader_providers.dart';
import 'package:quran_app/features/reader/application/reader_settings.dart';
import 'package:quran_app/features/user_data/application/user_data_providers.dart';

/// Uygulama açılışını taklit eder: kayıtlı veriyi okuyup sağlayıcıları kurar.
Future<ProviderContainer> _openSession(UserDatabase db) async {
  final snapshot = await UserDataSnapshot.load(db);
  return ProviderContainer(
    overrides: [
      userDatabaseProvider.overrideWithValue(db),
      userDataSnapshotProvider.overrideWithValue(snapshot),
    ],
  );
}

void main() {
  late UserDatabase db;

  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = UserDatabase(NativeDatabase.memory());
    addTearDown(db.close);
  });

  test('ilk açılışta varsayılanlar ve yerel kullanıcı oluşur', () async {
    final session = await _openSession(db);
    addTearDown(session.dispose);
    final settings = session.read(readerSettingsProvider);
    expect(settings.viewMode, ReaderViewMode.page);
    expect(session.read(readerAnchorProvider), const AyahRef(1, 1));
    expect(session.read(userDataSnapshotProvider).localUserId, isNotNull);
  });

  test('ayarlar ve son okunan yer yeniden açılışta korunur (T-05)', () async {
    final first = await _openSession(db);
    final localUserId = first.read(userDataSnapshotProvider).localUserId;
    first.read(readerSettingsProvider.notifier)
      ..setViewMode(ReaderViewMode.ayah)
      ..setTextScale(1.75);
    first.read(readerAnchorProvider.notifier).set(const AyahRef(18, 45));
    // Sağlayıcıların kapanması bekleyen kaydı tamamlar (uygulama kapanışı).
    first.dispose();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    final second = await _openSession(db);
    addTearDown(second.dispose);
    final settings = second.read(readerSettingsProvider);
    expect(settings.viewMode, ReaderViewMode.ayah);
    expect(settings.textScale, 1.75);
    expect(second.read(readerAnchorProvider), const AyahRef(18, 45));
    expect(second.read(userDataSnapshotProvider).localUserId, localUserId);
  });

  test(
    'son okunan yer kısa bir beklemeden sonra kendiliğinden yazılır',
    () async {
      final session = await _openSession(db);
      addTearDown(session.dispose);
      final anchor = session.read(readerAnchorProvider.notifier)
        ..set(const AyahRef(2, 10))
        ..set(const AyahRef(2, 11))
        ..set(const AyahRef(2, 12));
      expect(anchor, isNotNull);
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      final rows = await db.select(db.readingPositions).get();
      expect(rows, hasLength(1));
      expect((rows.single.surah, rows.single.ayah), (2, 12));
    },
  );
}
