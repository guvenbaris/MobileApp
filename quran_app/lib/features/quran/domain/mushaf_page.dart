import 'quran_models.dart';

/// Düzenden bağımsız kelime konumu: sure:ayet:kelime (M2-15).
///
/// Kelime sırası esas (KFGQPC) bölünmeye göredir; ayet sonu işareti ayetin
/// son sırasıdır.
class WordRef {
  const WordRef(this.surah, this.ayah, this.position);

  final int surah;
  final int ayah;
  final int position;

  AyahRef get ayahRef => AyahRef(surah, ayah);

  @override
  bool operator ==(Object other) =>
      other is WordRef &&
      other.surah == surah &&
      other.ayah == ayah &&
      other.position == position;

  @override
  int get hashCode => Object.hash(surah, ayah, position);

  @override
  String toString() => '$surah:$ayah:$position';
}

class PageWord {
  const PageWord({
    required this.ref,
    required this.text,
    required this.isAyahEnd,
  });

  final WordRef ref;

  /// KFGQPC yazılışı; tek Kur'an fontuyla çizilir.
  final String text;

  /// Ayet sonu (numara) işareti mi.
  final bool isAyahEnd;
}

/// Sayfa fontundaki bir glif birimi ve kapsadığı kelimeler.
class PageGlyph {
  const PageGlyph({required this.glyph, required this.words});

  final String glyph;

  /// Genellikle tek kelime; düzenin bölünmesi farklıysa birden fazla.
  final List<WordRef> words;
}

class MushafLine {
  const MushafLine({
    required this.number,
    required this.type,
    required this.isCentered,
    required this.words,
    required this.glyphs,
    this.surah,
  });

  final int number;
  final LayoutLineType type;

  /// Ortalı mı (değilse iki yana yaslı).
  final bool isCentered;

  /// Sure başlığı ve besmele satırlarında sure numarası.
  final int? surah;

  /// Ayet satırlarında satırdaki kelimeler (okuma sırasıyla).
  final List<PageWord> words;

  /// Ayet satırlarında satırdaki glifler (okuma sırasıyla).
  final List<PageGlyph> glyphs;
}

class MushafPage {
  const MushafPage({
    required this.layoutId,
    required this.number,
    required this.firstAyah,
    required this.juz,
    required this.hizb,
    required this.lines,
  });

  final String layoutId;
  final int number;

  /// Sayfanın ilk ayeti; sayfadan konuma dönüşüm için (M2-15).
  final AyahRef firstAyah;

  /// Sayfanın ilk ayetinin cüz ve hizbi (M2-04).
  final int juz;
  final int hizb;
  final List<MushafLine> lines;
}
