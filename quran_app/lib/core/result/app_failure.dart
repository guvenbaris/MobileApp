/// Katmanlar arası taşınan hata türleri.
///
/// Mesajlar geliştirici içindir; kullanıcıya gösterilecek metin arayüz
/// katmanında hata türüne göre yerelleştirilir.
sealed class AppFailure implements Exception {
  const AppFailure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Ağ erişimi yok veya sunucuya ulaşılamadı.
final class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'Ağ hatası']);
}

/// Kimlik doğrulama başarısız (yanlış şifre, oturum süresi doldu vb.).
final class AuthFailure extends AppFailure {
  const AuthFailure(super.message);
}

/// İstenen kayıt bulunamadı.
final class NotFoundFailure extends AppFailure {
  const NotFoundFailure(super.message);
}

/// Kullanıcı işlemi iptal etti (ör. satın alma veya Google girişi penceresi kapatıldı).
final class CancelledFailure extends AppFailure {
  const CancelledFailure([super.message = 'İptal edildi']);
}

/// Beklenmeyen hata; asıl istisnayı ve yığın izini taşır.
final class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure(super.message, {this.error, this.stackTrace});

  final Object? error;
  final StackTrace? stackTrace;
}
