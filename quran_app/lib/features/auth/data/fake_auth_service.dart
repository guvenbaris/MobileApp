import 'dart:async';

import '../../../core/result/result.dart';
import '../domain/auth_service.dart';

/// Bellekte çalışan sahte hesap servisi (dev ortamı ve testler).
class FakeAuthService implements AuthService {
  final Map<String, String> _passwords = {};
  final StreamController<AuthUser?> _changes = StreamController.broadcast();
  AuthUser? _current;
  int _nextId = 1;

  @override
  AuthUser? get currentUser => _current;

  @override
  Stream<AuthUser?> authStateChanges() async* {
    yield _current;
    yield* _changes.stream;
  }

  @override
  Future<Result<AuthUser>> registerWithEmail({
    required String email,
    required String password,
  }) async {
    if (_passwords.containsKey(email)) {
      return const Err(AuthFailure('Bu e-posta zaten kayıtlı'));
    }
    _passwords[email] = password;
    return Ok(_signIn(email: email, method: AuthMethod.emailPassword));
  }

  @override
  Future<Result<AuthUser>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (_passwords[email] != password) {
      return const Err(AuthFailure('E-posta veya şifre hatalı'));
    }
    return Ok(_signIn(email: email, method: AuthMethod.emailPassword));
  }

  @override
  Future<Result<AuthUser>> signInWithGoogle() async =>
      Ok(_signIn(email: 'google.user@example.com', method: AuthMethod.google));

  @override
  Future<Result<AuthUser>> signInWithApple() async =>
      Ok(_signIn(email: 'apple.user@example.com', method: AuthMethod.apple));

  @override
  Future<Result<void>> sendPasswordReset(String email) async => okVoid;

  @override
  Future<Result<void>> signOut() async {
    _setCurrent(null);
    return okVoid;
  }

  @override
  Future<Result<void>> deleteAccount() async {
    final user = _current;
    if (user == null) return const Err(AuthFailure('Oturum açık değil'));
    _passwords.remove(user.email);
    _setCurrent(null);
    return okVoid;
  }

  Future<void> dispose() => _changes.close();

  AuthUser _signIn({required String email, required AuthMethod method}) {
    final user = AuthUser(
      id: 'fake-user-${_nextId++}',
      email: email,
      methods: {method},
    );
    _setCurrent(user);
    return user;
  }

  void _setCurrent(AuthUser? user) {
    _current = user;
    _changes.add(user);
  }
}
