import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/l10n/app_language.dart';

/// M13-01: seçilen dilde tüm arayüz o dildedir; eksik çeviri olmaz.
void main() {
  Map<String, Object?> read(String code) =>
      jsonDecode(File('lib/l10n/app_$code.arb').readAsStringSync())
          as Map<String, Object?>;
  Set<String> messageKeys(Map<String, Object?> arb) =>
      arb.keys.where((k) => !k.startsWith('@')).toSet();

  final template = read('tr');

  for (final locale in kSupportedLocales) {
    final code = locale.languageCode;
    test('$code: anahtarlar şablonla (tr) aynı ve boş metin yok', () {
      final arb = read(code);
      expect(arb['@@locale'], code);
      expect(messageKeys(arb), messageKeys(template));
      for (final key in messageKeys(arb)) {
        final value = arb[key];
        expect(
          value is String && value.trim().isNotEmpty,
          isTrue,
          reason: '$code.$key',
        );
      }
    });
  }
}
