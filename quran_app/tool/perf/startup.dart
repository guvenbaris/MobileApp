// Soğuk açılış ölçümü (F1-00, NF-PF01: orta segment cihazda ≤ 2 sn).
//
// Uygulamayı profile derlemesiyle `--trace-startup` seçeneğiyle birkaç kez
// açar. Flutter her seferinde `build/start_up_info.json` yazar: motorun
// başlamasından ilk karenin ekrana çizilmesine kadar geçen süre. Uygulama
// ilk karede ana sayfayı gösterir. İçerik ve kullanıcı veritabanının
// açılması bu süreye dahildir (bootstrap ilk kareden önce bekler).
//
// İlk ölçüm kurulumdan sonraki ilk açılıştır (içerik veritabanı cihaza
// kopyalanır); sonrakiler normal açılıştır. Bu yüzden ikisi ayrı raporlanır.
//
// Çalıştırma (quran_app içinde, telefon USB ile bağlı ve hata ayıklama açık):
//   dart run tool/perf/startup.dart [cihaz_kimliği] [tekrar_sayısı]
// Cihaz kimliği: `flutter devices` çıktısındaki ikinci sütun.
import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final device = args.isNotEmpty ? args[0] : null;
  final runs = args.length > 1 ? int.parse(args[1]) : 4;
  final results = <Map<String, dynamic>>[];
  final info = File('build/start_up_info.json');

  for (var i = 1; i <= runs; i++) {
    if (info.existsSync()) info.deleteSync();
    stdout.writeln('Ölçüm $i/$runs …');
    final process = await Process.start('flutter', [
      'run',
      '--profile',
      '--trace-startup',
      '--flavor',
      'dev',
      '-t',
      'lib/main_dev.dart',
      if (device != null) ...['-d', device],
    ], runInShell: true);
    process.stdout.transform(utf8.decoder).listen((_) {});
    process.stderr.transform(utf8.decoder).listen(stderr.write);
    final code = await process.exitCode;
    if (code != 0 || !info.existsSync()) {
      stderr.writeln('flutter run başarısız (çıkış kodu $code)');
      exit(1);
    }
    results.add(jsonDecode(info.readAsStringSync()) as Map<String, dynamic>);
  }

  double firstFrameMs(Map<String, dynamic> r) =>
      (r['timeToFirstFrameMicros'] as num) / 1000;
  final first = firstFrameMs(results.first);
  final rest = results.skip(1).map(firstFrameMs).toList()..sort();

  stdout
    ..writeln('')
    ..writeln('=== Soğuk açılış (motor başlangıcı → ilk kare) ===')
    ..writeln('Hedef: ≤ 2000 ms (NF-PF01)')
    ..writeln(
      '1. ölçüm (kurulumdan sonra ilk açılışsa veritabanı kopyalama dahil): '
      '${first.toStringAsFixed(0)} ms',
    );
  if (rest.isNotEmpty) {
    stdout.writeln(
      'Sonraki ${rest.length} ölçüm: ortanca '
      '${rest[rest.length ~/ 2].toStringAsFixed(0)} ms, en uzun '
      '${rest.last.toStringAsFixed(0)} ms',
    );
  }
  final out = File('build/perf_startup.json');
  await out.writeAsString(
    const JsonEncoder.withIndent('  ').convert({'runs': results}),
  );
  stdout.writeln('Ayrıntı: ${out.path}');
}
