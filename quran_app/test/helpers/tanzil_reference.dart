import 'dart:io';

import 'package:quran_app/features/quran/domain/quran_models.dart';

/// Tanzil referans verisi (`tool/content/sources/tanzil/`).
///
/// Uygulamaya girmez; yalnızca içerik veritabanını bağımsız bir kaynakla
/// karşılaştırmak için kullanılır (T-01, T-02).
class TanzilReference {
  TanzilReference._(this.text, this._xml);

  factory TanzilReference.load() {
    const dir = 'tool/content/sources/tanzil';
    final text = <AyahRef, String>{};
    for (final line in File('$dir/quran-uthmani.txt').readAsLinesSync()) {
      if (line.isEmpty || line.startsWith('#')) continue;
      final [surah, ayah, body] = line.split('|');
      text[AyahRef(int.parse(surah), int.parse(ayah))] = body.trimRight();
    }
    return TanzilReference._(
      text,
      File('$dir/quran-data.xml').readAsStringSync(),
    );
  }

  /// Ayet metinleri, dosyadaki haliyle (surelerin 1. ayetinde besmele dahil).
  final Map<AyahRef, String> text;
  final String _xml;

  /// Tanzil, Fatiha ve Tevbe dışındaki surelerin 1. ayetinin başına besmele
  /// ekler. Bilinen iki yazımı (95 ve 97. surelerde `بِّسْمِ`) ve ardındaki
  /// boşluğu çıkarır. Başka bir başlangıç bulunursa hata verir.
  String textWithoutBasmala(AyahRef ref) {
    final body = text[ref]!;
    if (ref.ayah != 1 || ref.surah == 1 || ref.surah == 9) return body;
    // Besmele Fatiha'nın 1. ayetidir; ikinci yazım ب harfine şedde ekler.
    final basmala = text[const AyahRef(1, 1)]!;
    final forms = [basmala, '${basmala[0]}ّ${basmala.substring(1)}'];
    for (final form in forms) {
      if (body.startsWith('$form ')) return body.substring(form.length + 1);
    }
    throw StateError('$ref besmeleyle başlamıyor');
  }

  /// Sure numarası → ayet sayısı.
  Map<int, int> get ayahCounts => {
    for (final m in RegExp(
      r'<sura index="(\d+)" ayas="(\d+)"',
    ).allMatches(_xml))
      int.parse(m[1]!): int.parse(m[2]!),
  };

  /// Cüz, rubu' (`quarter`) ve sayfa (`page`) başlangıçları: sıra → ayet.
  Map<int, AyahRef> starts(String tag) => {
    for (final m in RegExp(
      '<$tag index="(\\d+)" sura="(\\d+)" aya="(\\d+)"',
    ).allMatches(_xml))
      int.parse(m[1]!): AyahRef(int.parse(m[2]!), int.parse(m[3]!)),
  };

  /// Metninde verilen işareti taşıyan ayetler (ör. secde ۩, rubu' ۞).
  Set<AyahRef> ayahsWithMark(String mark) => {
    for (final MapEntry(:key, :value) in text.entries)
      if (value.contains(mark)) key,
  };
}
