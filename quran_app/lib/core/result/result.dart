import 'app_failure.dart';

export 'app_failure.dart';

/// Başarısız olabilecek işlemlerin dönüş tipi.
///
/// Beklenen hatalar istisna fırlatılarak değil `Err` ile döndürülür;
/// çağıran taraf `switch` ile iki durumu da ele almak zorundadır.
sealed class Result<T> {
  const Result();

  bool get isOk => this is Ok<T>;

  /// Başarılıysa değeri, değilse `null` döndürür.
  T? get valueOrNull => switch (this) {
    Ok(:final value) => value,
    Err() => null,
  };

  R fold<R>(R Function(T value) onOk, R Function(AppFailure failure) onErr) =>
      switch (this) {
        Ok(:final value) => onOk(value),
        Err(:final failure) => onErr(failure),
      };
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);

  final AppFailure failure;
}

/// `Result<void>` için başarılı sonuç.
const Result<void> okVoid = Ok<void>(null);
