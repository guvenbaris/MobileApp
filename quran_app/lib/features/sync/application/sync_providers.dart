import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/flavor.dart';
import '../../../core/config/flavor_provider.dart';
import '../data/fake_sync_service.dart';
import '../domain/sync_service.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  switch (ref.watch(flavorProvider)) {
    case Flavor.dev:
      final service = FakeSyncService();
      ref.onDispose(service.dispose);
      return service;
    case Flavor.prod:
      throw UnimplementedError(
        'Gerçek SyncService Faz 3\'te eklenecek (AK-03)',
      );
  }
});
