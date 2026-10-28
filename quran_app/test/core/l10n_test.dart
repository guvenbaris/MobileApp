import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/l10n/l10n.dart';

import '../helpers/localized_app.dart';

void main() {
  group('resolveAppLocale (M13-01)', () {
    test('seçilen dil cihaz dilinden önce gelir', () {
      expect(
        resolveAppLocale(AppLanguage.ar, const [Locale('tr', 'TR')]),
        const Locale('ar'),
      );
    });

    test('cihaz dili: desteklenen ilk dil, bölge kodu yok sayılır', () {
      expect(
        resolveAppLocale(AppLanguage.system, const [
          Locale('de', 'DE'),
          Locale('ar', 'SA'),
          Locale('en', 'US'),
        ]),
        const Locale('ar'),
      );
    });

    test('desteklenen cihaz dili yoksa İngilizce', () {
      expect(
        resolveAppLocale(AppLanguage.system, const [Locale('de')]),
        kFallbackLocale,
      );
      expect(resolveAppLocale(AppLanguage.system, null), kFallbackLocale);
    });
  });

  test('rakam çevirisi iki yönde de çalışır (NF-Y03)', () {
    expect(convertDigits('2:255', arabic: true), '٢:٢٥٥');
    expect(convertDigits('٢:٢٥٥', arabic: false), '2:255');
  });

  group('sayı biçimi (NF-Y03)', () {
    Future<String> format(
      WidgetTester tester,
      Locale locale,
      NumeralSystem numerals,
      int value,
    ) async {
      late String result;
      await tester.pumpWidget(
        NumeralScope(
          numerals: numerals,
          child: localizedApp(
            Builder(
              builder: (context) {
                result = context.formatInt(value);
                return const SizedBox();
              },
            ),
            locale: locale,
          ),
        ),
      );
      return result;
    }

    testWidgets('dile göre: Arapçada Doğu Arap rakamları', (tester) async {
      expect(
        await format(tester, const Locale('ar'), NumeralSystem.auto, 286),
        '٢٨٦',
      );
      expect(
        await format(tester, const Locale('tr'), NumeralSystem.auto, 286),
        '286',
      );
    });

    testWidgets('seçim dili geçersiz kılar', (tester) async {
      expect(
        await format(tester, const Locale('tr'), NumeralSystem.arabic, 604),
        '٦٠٤',
      );
      expect(
        await format(tester, const Locale('ar'), NumeralSystem.western, 604),
        '604',
      );
    });

    testWidgets('binlik ayıracı dile göre', (tester) async {
      expect(
        await format(tester, const Locale('tr'), NumeralSystem.auto, 6236),
        '6.236',
      );
      expect(
        await format(tester, const Locale('en'), NumeralSystem.auto, 6236),
        '6,236',
      );
    });
  });
}
