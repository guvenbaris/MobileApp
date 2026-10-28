import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/result/result.dart';

void main() {
  test('Ok değeri taşır', () {
    const Result<int> result = Ok(42);
    expect(result.isOk, isTrue);
    expect(result.valueOrNull, 42);
    expect(result.fold((v) => 'ok $v', (f) => 'err'), 'ok 42');
  });

  test('Err hatayı taşır', () {
    const Result<int> result = Err(NotFoundFailure('yok'));
    expect(result.isOk, isFalse);
    expect(result.valueOrNull, isNull);
    expect(
      result.fold((v) => null, (f) => f),
      isA<NotFoundFailure>().having((f) => f.message, 'message', 'yok'),
    );
  });
}
