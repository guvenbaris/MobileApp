import 'dart:async';

import '../../../core/result/result.dart';
import '../domain/sync_service.dart';

/// Hiçbir şey göndermeyen, her turu başarılı sayan sahte senkron servisi.
class FakeSyncService implements SyncService {
  FakeSyncService({DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  final StreamController<SyncState> _changes = StreamController.broadcast();
  SyncState _state = SyncState.idle;
  DateTime? _lastSyncedAt;

  @override
  SyncState get state => _state;

  @override
  Stream<SyncState> stateChanges() => _changes.stream;

  @override
  DateTime? get lastSyncedAt => _lastSyncedAt;

  @override
  Future<Result<SyncReport>> syncNow() async {
    _setState(SyncState.syncing);
    final now = _clock().toUtc();
    _lastSyncedAt = now;
    _setState(SyncState.idle);
    return Ok(SyncReport(finishedAt: now));
  }

  Future<void> dispose() => _changes.close();

  void _setState(SyncState state) {
    _state = state;
    _changes.add(state);
  }
}
