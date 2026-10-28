import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/result/result.dart';
import 'package:quran_app/features/auth/data/fake_auth_service.dart';
import 'package:quran_app/features/auth/domain/auth_service.dart';

void main() {
  late FakeAuthService auth;

  setUp(() => auth = FakeAuthService());
  tearDown(() => auth.dispose());

  test('kayıt olan kullanıcı oturum açmış olur', () async {
    final result = await auth.registerWithEmail(
      email: 'a@example.com',
      password: 'secret',
    );
    expect(result.valueOrNull?.email, 'a@example.com');
    expect(auth.currentUser?.methods, {AuthMethod.emailPassword});
  });

  test('yanlış şifre AuthFailure döndürür', () async {
    await auth.registerWithEmail(email: 'a@example.com', password: 'secret');
    await auth.signOut();

    final result = await auth.signInWithEmail(
      email: 'a@example.com',
      password: 'wrong',
    );
    expect(result, isA<Err<AuthUser>>());
    expect(auth.currentUser, isNull);
  });

  test('oturum değişiklikleri yayınlanır', () async {
    final states = <AuthUser?>[];
    final sub = auth.authStateChanges().listen(states.add);
    await pumpEventQueue();

    await auth.signInWithApple();
    await auth.signOut();
    await pumpEventQueue();
    await sub.cancel();

    expect(states.map((u) => u?.methods.single), [
      null,
      AuthMethod.apple,
      null,
    ]);
  });
}
