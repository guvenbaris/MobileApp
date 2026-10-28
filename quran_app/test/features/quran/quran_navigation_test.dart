import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';
import 'package:quran_app/features/quran/domain/quran_navigation.dart';

void main() {
  const counts = {1: 7, 2: 286, 114: 6};
  JumpTarget? parse(String s) =>
      parseJump(s, ayahCounts: counts, pageCount: 604);

  group('parseJump (M4-01)', () {
    test('sure:ayet biçimleri', () {
      const target = AyahJump(AyahRef(2, 255));
      expect(parse('2:255'), target);
      expect(parse(' 2 : 255 '), target);
      expect(parse('2.255'), target);
      expect(parse('2 255'), target);
    });

    test('Doğu Arap rakamları', () {
      expect(parse('٢:٢٥٥'), const AyahJump(AyahRef(2, 255)));
      expect(parse('٥٠'), const PageJump(50));
    });

    test('sayfa numarası', () {
      expect(parse('1'), const PageJump(1));
      expect(parse('604'), const PageJump(604));
    });

    test('geçersiz girdiler null', () {
      for (final input in [
        '',
        'abc',
        '2:0',
        '2:287', // Bakara 286 ayet
        '115:1', // 114 sure
        '0',
        '605',
        '2:255:3',
        '-1',
      ]) {
        expect(parse(input), isNull, reason: input);
      }
    });
  });

  test('QuarterStart: hizb içindeki çeyrek', () {
    QuarterStart q(int rub) => QuarterStart(
      juz: 1,
      hizb: 1,
      rub: rub,
      start: const AyahRef(1, 1),
      page: 1,
    );
    expect([q(1), q(2), q(3), q(4), q(5)].map((e) => e.quarterInHizb), [
      0,
      1,
      2,
      3,
      0,
    ]);
  });
}
