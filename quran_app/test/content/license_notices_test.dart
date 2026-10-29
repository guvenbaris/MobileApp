import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/quran/data/content_licenses.dart';

import '../helpers/content_db.dart';

/// Uygulamayla dağıtılan içeriğin lisans yükümlülükleri (VERI_KAYNAKLARI.md).
/// Bu testler bir notun veya lisans dosyasının yanlışlıkla kaldırılmasını
/// yakalar.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Tanzil metni uygulamaya girmez: içerik veritabanında Tanzil kökenli alan yok', () async {
    // Faz 1 S9: Tanzil yalnızca test referansıdır. Tanzil metni dağıtılsaydı
    // telif notu ve atıf yükümlülükleri doğardı (VERI_KAYNAKLARI §4).
    final db = openTestContentDatabase();
    final columns = await db
        .customSelect("SELECT name FROM pragma_table_info('ayahs')")
        .map((r) => r.read<String>('name'))
        .get();
    expect(columns, isNot(contains('text_uthmani')));
    expect(columns, containsAll(['text_qpc_hafs', 'text_digital_khatt']));
    final meta = await db.select(db.contentMeta).get();
    expect(meta.map((m) => m.value).join(), isNot(contains('Tanzil')));
  });

  test(
    'DigitalKhatt fontu OFL lisansını ve telif notunu kendi içinde taşır',
    () {
      final bytes = File('assets/fonts/DigitalKhattV2.otf').readAsBytesSync();
      // `name` tablosu dizeleri UTF-16BE'dir.
      bool has(String s) {
        final needle = [
          for (final unit in s.codeUnits) ...[unit >> 8, unit & 0xFF],
        ];
        for (var i = 0; i + needle.length <= bytes.length; i++) {
          var ok = true;
          for (var j = 0; j < needle.length && ok; j++) {
            ok = bytes[i + j] == needle[j];
          }
          if (ok) return true;
        }
        return false;
      }

      expect(has('SIL Open Font License, Version 1.1'), isTrue);
      expect(has('Amine Anane'), isTrue);
      expect(has('Tarteel Inc.'), isTrue);
    },
  );

  test('OFL lisans dosyası uygulama paketine giriyor', () {
    final ofl = File(kQuranFontLicenseAsset).readAsStringSync();
    expect(ofl, contains('SIL OPEN FONT LICENSE Version 1.1'));
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(pubspec, contains('- $kQuranFontLicenseAsset'));
  });

  test('lisans sayfasına font lisansı eklenir', () async {
    // Testte varlık paketi yok; lisans dosyası diskten verilir.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (message) async {
          final key = utf8.decode(message!.buffer.asUint8List());
          final file = File(Uri.decodeFull(key));
          return file.existsSync()
              ? ByteData.sublistView(file.readAsBytesSync())
              : null;
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', null),
    );

    registerContentLicenses();
    final entries = await LicenseRegistry.licenses.toList();
    final font = entries.firstWhere(
      (e) => e.packages.contains('DigitalKhatt New Madina'),
    );
    expect(
      font.paragraphs.map((p) => p.text).join(' '),
      contains('SIL OPEN FONT LICENSE'),
    );

    // CC BY 4.0: eser sahibi, lisans bağlantısı ve değişiklik notu.
    final tajweed = entries
        .firstWhere((e) => e.packages.contains('cpfair/quran-tajweed'))
        .paragraphs
        .map((p) => p.text)
        .join(' ');
    expect(tajweed, contains('Colin Pfair'));
    expect(tajweed, contains('creativecommons.org/licenses/by/4.0'));
    expect(tajweed, contains('Changes:'));
  });

  test('uygulama içi atıfta tecvid kaynağı ve lisansı (3 dil)', () {
    for (final lang in ['tr', 'ar', 'en']) {
      final arb = File('lib/l10n/app_$lang.arb').readAsStringSync();
      expect(arb, contains('cpfair/quran-tajweed'), reason: lang);
      expect(
        arb,
        contains('creativecommons.org/licenses/by/4.0'),
        reason: lang,
      );
    }
  });
}
