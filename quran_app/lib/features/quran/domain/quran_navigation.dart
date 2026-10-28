import 'quran_models.dart';

/// Bir rubu'un (hizb çeyreğinin) başlangıcı; cüz ve hizb dizini bundan
/// türetilir (M4-01).
class QuarterStart {
  const QuarterStart({
    required this.juz,
    required this.hizb,
    required this.rub,
    required this.start,
    required this.page,
  });

  final int juz;
  final int hizb;

  /// Rubu' numarası (1–240).
  final int rub;

  /// Rubu'un ilk ayeti.
  final AyahRef start;

  /// Başlangıç ayetinin varsayılan düzendeki sayfası.
  final int page;

  /// Hizb içindeki çeyrek: 0 = hizb başı, 1 = ¼, 2 = ½, 3 = ¾.
  int get quarterInHizb => (rub - 1) % 4;
}

/// Okuma ekranında gidilecek yer (M4-01, M4-07).
sealed class JumpTarget {
  const JumpTarget();
}

class AyahJump extends JumpTarget {
  const AyahJump(this.ayah);

  final AyahRef ayah;

  @override
  bool operator ==(Object other) => other is AyahJump && other.ayah == ayah;

  @override
  int get hashCode => ayah.hashCode;

  @override
  String toString() => 'AyahJump($ayah)';
}

class PageJump extends JumpTarget {
  const PageJump(this.page);

  final int page;

  @override
  bool operator ==(Object other) => other is PageJump && other.page == page;

  @override
  int get hashCode => page.hashCode;

  @override
  String toString() => 'PageJump($page)';
}

const _easternDigits = '٠١٢٣٤٥٦٧٨٩';
final _ayahPattern = RegExp(r'^(\d{1,3})\s*[:.\s]\s*(\d{1,3})$');
final _pagePattern = RegExp(r'^\d{1,3}$');

/// Kullanıcının yazdığı konumu çözer: `2:255`, `2.255`, `2 255` (sure:ayet)
/// veya `50` (sayfa). Doğu Arap rakamları da kabul edilir. Sure ve ayet
/// numarası [ayahCounts]'a (sure → ayet sayısı), sayfa [pageCount]'a göre
/// denetlenir; geçersizse `null`.
JumpTarget? parseJump(
  String input, {
  required Map<int, int> ayahCounts,
  required int pageCount,
}) {
  final text = String.fromCharCodes(
    input.trim().runes.map((r) {
      final i = _easternDigits.indexOf(String.fromCharCode(r));
      return i < 0 ? r : 0x30 + i;
    }),
  );
  if (_ayahPattern.firstMatch(text) case final m?) {
    final surah = int.parse(m[1]!);
    final ayah = int.parse(m[2]!);
    final count = ayahCounts[surah];
    if (count == null || ayah < 1 || ayah > count) return null;
    return AyahJump(AyahRef(surah, ayah));
  }
  if (_pagePattern.hasMatch(text)) {
    final page = int.parse(text);
    return page >= 1 && page <= pageCount ? PageJump(page) : null;
  }
  return null;
}
