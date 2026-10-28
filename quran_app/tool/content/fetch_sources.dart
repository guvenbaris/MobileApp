// Ham Kur'an verisini indirir (F0-03, F0-04):
// - Quran.com API v4 → sadeleştirilmiş JSON, `tool/content/sources/quran_com/`
//   (uygulamadaki içeriğin kaynağı)
// - Tanzil → dosyalar olduğu gibi, `tool/content/sources/tanzil/`
//   (yalnızca testlerde bağımsız referans; uygulamaya girmez)
//
// Bu betik yalnızca kaynak güncellenirken çalıştırılır; çıktısı depoya
// commit'lenir. Metin hiçbir şekilde değiştirilmez.
//
// Çalıştırma (quran_app klasöründe):
//   dart run tool/content/fetch_sources.dart            # ikisi birden
//   dart run tool/content/fetch_sources.dart tanzil     # yalnızca Tanzil
import 'dart:async';
import 'dart:convert';
import 'dart:io';

const _api = 'https://api.quran.com/api/v4';
const _outDir = 'tool/content/sources/quran_com';
const _pageCount = 604;

const _tanzilDir = 'tool/content/sources/tanzil';

/// Tanzil dosyaları. Metin: Osmanlı yazımı, tüm işaretler (vakf, secde ۩,
/// rubu' ۞) dahil; Quran.com `text_uthmani` alanının kaynağıyla aynı biçim.
const _tanzilFiles = {
  'quran-uthmani.txt':
      'https://tanzil.net/pub/download/index.php?marks=true&sajdah=true'
      '&rub=true&tatweel=true&quranType=uthmani&outType=txt-2&agree=true',
  'quran-data.xml': 'https://tanzil.net/res/text/metadata/quran-data.xml',
};

/// Ayetler, KFGQPC 1421H düzeninin (`mushaf=1`) sayfaları üzerinden
/// indirilir. Düzenin kendisi (satırlar) Quran.com'dan alınmaz: satır
/// verisinde hatalar bulundu; düzen kaynağı QUL'dür (VERI_KAYNAKLARI.md Q-13).
/// Kelime glifleri (`code_v2`) yalnızca QUL glifleriyle eşleme için köprüdür.
const _mushafParam = 1;

final _client = HttpClient()..connectionTimeout = const Duration(seconds: 30);

Future<void> main(List<String> args) async {
  final targets = args.isEmpty ? {'quran_com', 'tanzil'} : args.toSet();
  if (targets.contains('tanzil')) await _fetchTanzil();
  if (targets.contains('quran_com')) await _fetchQuranCom();
  _client.close();
}

/// Tanzil dosyalarını bayt bayt, değiştirmeden kaydeder (lisans gereği).
Future<void> _fetchTanzil() async {
  await Directory(_tanzilDir).create(recursive: true);
  for (final MapEntry(key: name, value: url) in _tanzilFiles.entries) {
    final request = await _client.getUrl(Uri.parse(url));
    final response = await request.close();
    if (response.statusCode != 200) {
      throw HttpException('HTTP ${response.statusCode}', uri: Uri.parse(url));
    }
    final bytes = await response.fold<List<int>>([], (a, b) => a..addAll(b));
    await File('$_tanzilDir/$name').writeAsBytes(bytes);
    stdout.writeln('Tanzil: $name (${bytes.length} bayt)');
  }
  await File('$_tanzilDir/manifest.json').writeAsString(
    '${const JsonEncoder.withIndent('  ').convert({'source': 'Tanzil Project (https://tanzil.net)', 'license': 'Creative Commons Attribution 3.0; değiştirilmeden kullanılır', 'fetchedAt': DateTime.now().toUtc().toIso8601String(), 'files': _tanzilFiles})}\n',
  );
}

Future<void> _fetchQuranCom() async {
  await Directory(_outDir).create(recursive: true);

  await _fetchChapters();
  await _fetchVerses();

  await _writeJson('manifest.json', {
    'source': 'Quran.com API v4',
    'url': _api,
    'fetchedAt': DateTime.now().toUtc().toIso8601String(),
    'mushafParam': _mushafParam,
  });
  stdout.writeln('Tamamlandı: $_outDir');
}

Future<void> _fetchChapters() async {
  final en = await _getJson('$_api/chapters?language=en');
  final tr = await _getJson('$_api/chapters?language=tr');
  final trById = {for (final c in tr['chapters'] as List) (c as Map)['id']: c};
  final chapters = [
    for (final c in (en['chapters'] as List).cast<Map<String, dynamic>>())
      {
        'id': c['id'],
        'nameArabic': c['name_arabic'],
        'nameSimple': c['name_simple'],
        'nameEn': (c['translated_name'] as Map)['name'],
        'nameTr': ((trById[c['id']] as Map)['translated_name'] as Map)['name'],
        'revelationPlace': c['revelation_place'],
        'revelationOrder': c['revelation_order'],
        'bismillahPre': c['bismillah_pre'],
        'versesCount': c['verses_count'],
      },
  ];
  await _writeJson('chapters.json', chapters);
  stdout.writeln('Sureler: ${chapters.length}');
}

/// 604 sayfayı indirip ayetleri `verses.json`'a yazar.
Future<void> _fetchVerses() async {
  final pages = List<List<Map<String, dynamic>>?>.filled(_pageCount, null);
  var next = 1;
  Future<void> worker() async {
    while (next <= _pageCount) {
      final page = next++;
      pages[page - 1] = await _fetchPage(page);
      if (page % 100 == 0) stdout.writeln('Sayfa $page/$_pageCount');
    }
  }

  await Future.wait([for (var i = 0; i < 4; i++) worker()]);

  final verses = [for (final p in pages) ...p!];
  verses.sort(
    (a, b) => (a['surah'] as int) != (b['surah'] as int)
        ? (a['surah'] as int) - (b['surah'] as int)
        : (a['ayah'] as int) - (b['ayah'] as int),
  );
  await _writeJson('verses.json', verses);
  stdout.writeln('Ayetler: ${verses.length}');
}

Future<List<Map<String, dynamic>>> _fetchPage(int page) async {
  final json = await _getJson(
    '$_api/verses/by_page/$page?mushaf=$_mushafParam&per_page=50&words=true'
    '&fields=text_uthmani,text_qpc_hafs'
    '&word_fields=text_uthmani,code_v2,position',
  );
  final pagination = json['pagination'] as Map;
  if (pagination['next_page'] != null) {
    throw StateError('Sayfa $page 50 ayetten uzun; sayfalama gerekli');
  }
  return [
    for (final v in (json['verses'] as List).cast<Map<String, dynamic>>())
      {
        'surah': int.parse((v['verse_key'] as String).split(':').first),
        'ayah': v['verse_number'],
        'juz': v['juz_number'],
        'hizb': v['hizb_number'],
        'rub': v['rub_el_hizb_number'],
        'sajdah': v['sajdah_number'],
        'textUthmani': v['text_uthmani'],
        'textQpcHafs': v['text_qpc_hafs'],
        // Quran.com/Corpus kelimesi: [sıra, tür (word/end), metin, QCF V2 glifi]
        'words': [
          for (final w in (v['words'] as List).cast<Map<String, dynamic>>())
            [
              w['position'],
              w['char_type_name'],
              w['text_uthmani'],
              w['code_v2'],
            ],
        ],
      },
  ];
}

Future<Map<String, dynamic>> _getJson(String url) async {
  for (var attempt = 1; ; attempt++) {
    try {
      final request = await _client.getUrl(Uri.parse(url));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode != 200) {
        throw HttpException('HTTP ${response.statusCode}', uri: Uri.parse(url));
      }
      return jsonDecode(body) as Map<String, dynamic>;
    } on Exception catch (e) {
      if (attempt >= 5) rethrow;
      stderr.writeln('Tekrar deneniyor ($attempt): $url — $e');
      await Future<void>.delayed(Duration(seconds: attempt * 2));
    }
  }
}

Future<void> _writeJson(String name, Object data) async {
  // Satır başına bir kayıt: dosya okunabilir ve git farkları küçük kalır.
  final encoded = data is List
      ? '[\n${data.map(jsonEncode).join(',\n')}\n]\n'
      : '${const JsonEncoder.withIndent('  ').convert(data)}\n';
  await File('$_outDir/$name').writeAsString(encoded);
}
