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

  test(
    'Tanzil telif notu içerik veritabanında, kaynak dosyadaki haliyle',
    () async {
      final db = openTestContentDatabase();
      final notice = await db.metaValue('notice.tanzil');
      final source = File('tool/content/sources/tanzil/quran-uthmani.txt')
          .readAsLinesSync()
          .skipWhile((l) => !l.startsWith('#'))
          .join('\n');
      expect(notice, source.trimRight());
      expect(notice, contains('Copyright (C)'));
      expect(notice, contains('Tanzil Project'));
      expect(notice, contains('CHANGING IT IS NOT ALLOWED'));
    },
  );

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

  test('lisans sayfasına font ve Tanzil lisansı eklenir', () async {
    final db = openTestContentDatabase();
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

    registerContentLicenses(db);
    final entries = await LicenseRegistry.licenses.toList();
    final packages = entries.expand((e) => e.packages).toSet();
    expect(
      packages,
      containsAll(['DigitalKhatt New Madina', 'Tanzil Quran Text']),
    );
    final tanzil = entries.firstWhere(
      (e) => e.packages.contains('Tanzil Quran Text'),
    );
    expect(
      tanzil.paragraphs.map((p) => p.text).join('\n'),
      contains('Tanzil Project'),
    );
  });
}
