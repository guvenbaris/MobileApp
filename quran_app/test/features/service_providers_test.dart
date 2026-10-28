import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/config/flavor.dart';
import 'package:quran_app/core/crash/crash_reporter.dart';
import 'package:quran_app/core/result/result.dart';
import 'package:quran_app/features/auth/application/auth_providers.dart';
import 'package:quran_app/features/auth/data/fake_auth_service.dart';
import 'package:quran_app/features/auth/domain/auth_service.dart';
import 'package:quran_app/features/billing/application/billing_providers.dart';
import 'package:quran_app/features/billing/data/fake_billing_service.dart';
import 'package:quran_app/features/lessons/application/lesson_providers.dart';
import 'package:quran_app/features/lessons/data/fake_lesson_repository.dart';
import 'package:quran_app/features/sync/application/sync_providers.dart';
import 'package:quran_app/features/sync/data/fake_sync_service.dart';

import '../helpers/test_container.dart';

/// Gerçek bir sunucu uygulamasını temsil eden test sınıfı.
class _ServerAuthService extends FakeAuthService {}

void main() {
  test('dev ortamında tüm servisler Fake uygulamalara çözülür (MK-06)', () {
    final container = createContainer();
    expect(container.read(authServiceProvider), isA<FakeAuthService>());
    expect(container.read(syncServiceProvider), isA<FakeSyncService>());
    expect(
      container.read(lessonRepositoryProvider),
      isA<FakeLessonRepository>(),
    );
    expect(container.read(billingServiceProvider), isA<FakeBillingService>());
    expect(container.read(crashReporterProvider), isA<FakeCrashReporter>());
  });

  test('prod ortamında henüz yazılmamış servisler açıkça hata verir', () {
    final container = createContainer(flavor: Flavor.prod);
    for (final provider in <ProviderListenable<Object>>[
      authServiceProvider,
      syncServiceProvider,
      lessonRepositoryProvider,
      billingServiceProvider,
    ]) {
      expect(() => container.read<Object>(provider), throwsA(anything));
    }
  });

  test('servis tek satırlık sağlayıcı değişikliğiyle değiştirilir', () async {
    final container = createContainer(
      overrides: [
        // Gerçek uygulamaya geçiş yalnızca bu satırdır.
        authServiceProvider.overrideWith((ref) => _ServerAuthService()),
      ],
    );

    final AuthService auth = container.read(authServiceProvider);
    expect(auth, isA<_ServerAuthService>());

    final result = await auth.signInWithGoogle();
    expect(result, isA<Ok<AuthUser>>());
  });
}
