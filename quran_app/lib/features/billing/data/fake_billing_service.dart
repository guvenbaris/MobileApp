import 'dart:async';

import '../../../core/result/result.dart';
import '../domain/billing_service.dart';

/// Her satın almayı başarılı sayan sahte mağaza.
class FakeBillingService implements BillingService {
  FakeBillingService({DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  static const List<BillingProduct> _products = [
    BillingProduct(
      id: 'monthly',
      kind: BillingProductKind.monthly,
      priceLabel: '₺99,99',
    ),
    BillingProduct(
      id: 'yearly',
      kind: BillingProductKind.yearly,
      priceLabel: '₺799,99',
    ),
    BillingProduct(
      id: 'lifetime',
      kind: BillingProductKind.lifetime,
      priceLabel: '₺1.999,99',
    ),
  ];

  final DateTime Function() _clock;
  final StreamController<Entitlement> _changes = StreamController.broadcast();
  Entitlement _entitlement = Entitlement.none;

  @override
  Entitlement get entitlement => _entitlement;

  @override
  Stream<Entitlement> entitlementChanges() => _changes.stream;

  @override
  Future<Result<List<BillingProduct>>> getProducts() async =>
      const Ok(_products);

  @override
  Future<Result<Entitlement>> purchase(String productId) async {
    final product = _products.where((p) => p.id == productId).firstOrNull;
    if (product == null) {
      return Err(NotFoundFailure('Ürün bulunamadı: $productId'));
    }
    final now = _clock().toUtc();
    _entitlement = Entitlement(
      isActive: true,
      productId: product.id,
      expiresAt: switch (product.kind) {
        BillingProductKind.monthly => now.add(const Duration(days: 30)),
        BillingProductKind.yearly ||
        BillingProductKind.family => now.add(const Duration(days: 365)),
        BillingProductKind.lifetime => null,
      },
    );
    _changes.add(_entitlement);
    return Ok(_entitlement);
  }

  @override
  Future<Result<Entitlement>> restorePurchases() async => Ok(_entitlement);

  Future<void> dispose() => _changes.close();
}
