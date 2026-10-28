import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/flavor.dart';
import '../../../core/config/flavor_provider.dart';
import '../data/fake_auth_service.dart';
import '../domain/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  switch (ref.watch(flavorProvider)) {
    case Flavor.dev:
      final service = FakeAuthService();
      ref.onDispose(service.dispose);
      return service;
    case Flavor.prod:
      throw UnimplementedError(
        'Gerçek AuthService Faz 3\'te eklenecek (AK-03)',
      );
  }
});
