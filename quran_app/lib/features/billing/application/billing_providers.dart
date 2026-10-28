import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/flavor.dart';
import '../../../core/config/flavor_provider.dart';
import '../data/fake_billing_service.dart';
import '../domain/billing_service.dart';

final billingServiceProvider = Provider<BillingService>((ref) {
  switch (ref.watch(flavorProvider)) {
    case Flavor.dev:
      final service = FakeBillingService();
      ref.onDispose(service.dispose);
      return service;
    case Flavor.prod:
      throw UnimplementedError(
        'Gerçek BillingService Faz 4\'te eklenecek (M11)',
      );
  }
});
