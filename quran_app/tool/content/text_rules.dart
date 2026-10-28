// Kur'an metinlerini farklı kaynaklar/kodlamalar arasında karşılaştırma
// kuralları (F0-04, F0-05). Yalnızca karşılaştırma içindir; saklanan metni
// değiştirmez.

/// Harf iskeleti: yalnızca temel Arap harfleri. Hareke, işaret, tatvîl ve tek
/// başına hemze atılır; elif, ye ve vav aileleri tek harfe katlanır.
///
/// Ayrık yazılmış hemze (ör. elif + U+0654) ile birleşik yazılmış hemze
/// (U+0623) aynı iskeleti verir; bu yüzden Unicode normalizasyonu gerekmez.
String letterSkeleton(String text) {
  final out = StringBuffer();
  for (final rune in text.runes) {
    final c = switch (rune) {
      0x0671 || 0x0623 || 0x0625 || 0x0622 => 0x0627,
      0x0649 || 0x0626 => 0x064A,
      0x0624 => 0x0648,
      _ => rune,
    };
    if (c >= 0x0622 && c <= 0x064A && c != 0x0640) out.writeCharCode(c);
  }
  return out.toString();
}

/// Vakf (durak) işaretleri: ۖ ۗ ۘ ۙ ۚ ۛ (U+06D6–U+06DB), metindeki sırasıyla.
String waqfMarks(String text) =>
    String.fromCharCodes(text.runes.where((r) => r >= 0x06D6 && r <= 0x06DB));
