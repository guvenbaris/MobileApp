import '../../../core/result/result.dart';

/// M11-02
enum BillingProductKind { monthly, yearly, lifetime, family }

class BillingProduct {
  const BillingProduct({
    required this.id,
    required this.kind,
    required this.priceLabel,
  });

  final String id;
  final BillingProductKind kind;

  /// Mağazanın yerel para birimiyle biçimlendirdiği fiyat (M11-03).
  final String priceLabel;
}

/// Kullanıcının ders erişim hakkı (M11-08: tek abonelik tüm dersleri açar).
class Entitlement {
  const Entitlement({required this.isActive, this.productId, this.expiresAt});

  static const none = Entitlement(isActive: false);

  final bool isActive;
  final String? productId;

  /// Ömür boyu üründe `null`.
  final DateTime? expiresAt;
}

/// Mağaza içi satın alma (M11, v1.1). Ödeme yalnızca mağazalar üzerinden (M11-01).
abstract interface class BillingService {
  Entitlement get entitlement;

  Stream<Entitlement> entitlementChanges();

  Future<Result<List<BillingProduct>>> getProducts();

  Future<Result<Entitlement>> purchase(String productId);

  /// M11-09
  Future<Result<Entitlement>> restorePurchases();
}
