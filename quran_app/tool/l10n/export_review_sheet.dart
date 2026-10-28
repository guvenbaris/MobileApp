// Çeviri gözden geçirme tablosu (F1-00: Arapça metinlerin anadili Arapça
// biri tarafından gözden geçirilmesi).
//
// ARB dosyalarındaki tüm arayüz metinlerini Türkçe (şablon), İngilizce ve
// Arapça yan yana bir CSV'ye yazar; gözden geçiren kişi "Öneri" ve "Not"
// sütunlarını doldurur. Excel'de doğru açılsın diye UTF-8 BOM ile yazılır.
//
// Çalıştırma (quran_app içinde):
//   dart run tool/l10n/export_review_sheet.dart
// Çıktı: build/l10n_review.csv
import 'dart:convert';
import 'dart:io';

const _languages = ['tr', 'en', 'ar'];
const _output = 'build/l10n_review.csv';

void main() {
  final arb = {
    for (final code in _languages)
      code: jsonDecode(
        File('lib/l10n/app_$code.arb').readAsStringSync(),
      ) as Map<String, dynamic>,
  };
  final template = arb['tr']!;
  final keys = template.keys.where((k) => !k.startsWith('@')).toList();

  String cell(Object? value) =>
      '"${(value ?? '').toString().replaceAll('"', '""')}"';

  final rows = <String>[
    [
      'Anahtar',
      'Açıklama',
      'Türkçe',
      'English',
      'العربية',
      'Öneri (العربية)',
      'Not',
    ].map(cell).join(','),
    for (final key in keys)
      [
        key,
        (template['@$key'] as Map<String, dynamic>?)?['description'],
        for (final code in _languages) arb[code]![key],
        '',
        '',
      ].map(cell).join(','),
  ];

  final file = File(_output)..parent.createSync(recursive: true);
  // Excel UTF-8'i BOM ile tanır; satır sonu CRLF.
  file.writeAsBytesSync([0xEF, 0xBB, 0xBF, ...utf8.encode(rows.join('\r\n'))]);
  stdout.writeln('Yazıldı: $_output (${keys.length} metin)');
}
