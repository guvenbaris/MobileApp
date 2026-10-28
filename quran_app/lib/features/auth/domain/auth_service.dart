import '../../../core/result/result.dart';

/// Hesaba bağlı giriş yöntemleri (M1-02, M1-03).
enum AuthMethod { emailPassword, google, apple }

/// Giriş yapmış hesap. Hesapsız kullanım `localUserId` ile yürür (MK-09),
/// bu sınıf yalnızca isteğe bağlı hesabı temsil eder.
class AuthUser {
  const AuthUser({required this.id, required this.methods, this.email});

  final String id;
  final String? email;
  final Set<AuthMethod> methods;
}

/// Hesap işlemleri (M1). Sunucu gelene kadar sahte uygulama kullanılır (MK-06).
abstract interface class AuthService {
  /// Oturum açık değilse `null`.
  AuthUser? get currentUser;

  /// Oturum değişikliklerini yayınlar; dinlemeye başlayınca güncel durumu verir.
  Stream<AuthUser?> authStateChanges();

  Future<Result<AuthUser>> registerWithEmail({
    required String email,
    required String password,
  });

  Future<Result<AuthUser>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Result<AuthUser>> signInWithGoogle();

  Future<Result<AuthUser>> signInWithApple();

  /// M1-04
  Future<Result<void>> sendPasswordReset(String email);

  Future<Result<void>> signOut();

  /// M1-10
  Future<Result<void>> deleteAccount();
}
