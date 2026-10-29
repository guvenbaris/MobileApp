import 'quran_models.dart';
import 'quran_navigation.dart';
import 'tajweed.dart';

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
  const PageGlyph({
    required this.glyph,
    required this.words,
    this.digitalKhattText,
    this.tajweed = const [],
  });

  /// QCF V2 sayfa fontundaki karakter kodu.
  final String glyph;

  /// Aynı birimin DigitalKhatt yazılışı.
  final String? digitalKhattText;

  /// Genellikle tek kelime; düzenin bölünmesi farklıysa birden fazla.
  final List<WordRef> words;

  /// Renkli tecvid aralıkları, [digitalKhattText] içinde (M2-06).
  final List<TajweedSpan> tajweed;
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
    this.linesPerPage = 15,
    this.sajdahAyahs = const [],
    this.quarterStarts = const [],
  });

  final String layoutId;
  final int number;

  /// Sayfanın ilk ayeti; sayfadan konuma dönüşüm için (M2-15).
  final AyahRef firstAyah;

  /// Sayfanın ilk ayetinin cüz ve hizbi (M2-04).
  final int juz;
  final int hizb;
  final List<MushafLine> lines;

  /// Düzenin sayfa başına satır sayısı (Medine 15; IndoPak 13/16). Kısa
  /// sayfalar (ör. Fatiha) daha az satır taşır ama aynı satır yüksekliğiyle
  /// çizilir.
  final int linesPerPage;

  /// Bu sayfada başlayan secde ayetleri (M2-05). Yalnızca 14 secde sayılır
  /// (Hanefi, Q-8); 22:77'deki ۩ işareti metinde görünür ama burada yoktur.
  final List<AyahRef> sajdahAyahs;

  /// Bu sayfada başlayan rubu'lar (M2-05: ۞ işareti ve hizb bilgisi).
  final List<QuarterStart> quarterStarts;
}
