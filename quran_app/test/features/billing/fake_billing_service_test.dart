import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/result/result.dart';
import 'package:quran_app/features/billing/data/fake_billing_service.dart';
import 'package:quran_app/features/billing/domain/billing_service.dart';

void main() {
  final now = DateTime.utc(2026, 10, 28);
  late FakeBillingService billing;

  setUp(() => billing = FakeBillingService(clock: () => now));
  tearDown(() => billing.dispose());

  test('başlangıçta erişim yoktur', () {
    expect(billing.entitlement.isActive, isFalse);
  });

  test('aylık satın alma 30 günlük erişim verir', () async {
    final result = await billing.purchase('monthly');
    expect(result.valueOrNull?.expiresAt, now.add(const Duration(days: 30)));
    expect(billing.entitlement.isActive, isTrue);
  });

  test('ömür boyu satın almanın bitiş tarihi yoktur', () async {
    final result = await billing.purchase('lifetime');
    expect(result.valueOrNull?.isActive, isTrue);
    expect(result.valueOrNull?.expiresAt, isNull);
  });

  test('olmayan ürün NotFoundFailure döndürür', () async {
    final result = await billing.purchase('yok');
    expect(result, isA<Err<Entitlement>>());
  });
}
