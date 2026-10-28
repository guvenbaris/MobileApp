import '../../../core/result/result.dart';

enum SyncState { idle, syncing, failed, disabled }

/// Bir senkron turunun özeti.
class SyncReport {
  const SyncReport({
    required this.finishedAt,
    this.pushed = 0,
    this.pulled = 0,
  });

  final DateTime finishedAt;
  final int pushed;
  final int pulled;
}

/// Kullanıcı verisinin cihazlar arası senkronu (M1-06, M1-07).
///
/// Yerel veritabanı tek doğru kaynaktır (MK-01); bu servis yalnızca
/// yerel değişiklikleri sunucuyla eşitler.
abstract interface class SyncService {
  SyncState get state;

  Stream<SyncState> stateChanges();

  DateTime? get lastSyncedAt;

  Future<Result<SyncReport>> syncNow();
}
