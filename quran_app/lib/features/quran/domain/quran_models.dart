/// Kur'an içeriğinin alan modelleri (salt okunur).
library;

enum RevelationPlace { makkah, madinah }

/// Mushaf sayfasındaki bir satırın türü.
enum LayoutLineType { ayah, surahName, basmala }

/// Düzenden bağımsız ayet konumu (M2-15). Sayfa numarası asla saklanmaz.
class AyahRef implements Comparable<AyahRef> {
  const AyahRef(this.surah, this.ayah);

  final int surah;
  final int ayah;

  @override
  int compareTo(AyahRef other) =>
      surah != other.surah ? surah - other.surah : ayah - other.ayah;

  @override
  bool operator ==(Object other) =>
      other is AyahRef && other.surah == surah && other.ayah == ayah;

  @override
  int get hashCode => Object.hash(surah, ayah);

  @override
  String toString() => '$surah:$ayah';
}

class Surah {
  const Surah({
    required this.id,
    required this.nameArabic,
    required this.nameTr,
    required this.nameEn,
    required this.nameSimple,
    required this.revelationPlace,
    required this.revelationOrder,
    required this.bismillahPre,
    required this.ayahCount,
  });

  final int id;
  final String nameArabic;

  /// Türkçe okunuş (ör. "Bakara").
  final String nameTr;

  /// İngilizce anlam (ör. "The Cow").
  final String nameEn;

  /// Latin harfli okunuş (ör. "Al-Baqarah").
  final String nameSimple;
  final RevelationPlace revelationPlace;
  final int revelationOrder;
  final bool bismillahPre;
  final int ayahCount;
}

class Ayah {
  const Ayah({
    required this.ref,
    required this.juz,
    required this.hizb,
    required this.rub,
    required this.textUthmani,
    required this.textQpcHafs,
    required this.textDigitalKhatt,
    this.sajdah,
  });

  final AyahRef ref;
  final int juz;
  final int hizb;

  /// Rubu' numarası (1–240).
  final int rub;

  /// Secde ayetiyse secde sıra numarası (1–14).
  final int? sajdah;
  final String textUthmani;

  /// KFGQPC Hafs metni: esas kelime bölünmesinin kaynağı.
  final String textQpcHafs;

  /// Ekranda gösterilen metin (DigitalKhatt fontuyla, ayet numarası dahil).
  final String textDigitalKhatt;
}
