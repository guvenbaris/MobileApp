// Renkli tecvid açıklamalarını (cpfair/quran-tajweed, CC BY 4.0) ekranda
// gösterilen DigitalKhatt glif metnine taşır (F1-04, M2-06).
//
// Açıklamalar Tanzil Osmanlı metninin (2017 kopyası) karakter konumlarıdır.
// İki metnin kodlaması farklıdır (Q-15) ama harf iskeleti aynıdır (T-01).
// Eşleme:
//   1. Her iki metinde her karakter bir "harf kümesine" (temel harf + ardından
//      gelen işaretler) atanır; temel harf `text_rules.dart` letterSkeleton ile
//      aynı tanımdır. Kümeler harf iskeleti üzerinden eşlenir;
//      iskelet farklıysa (yalnızca 12:39, 12:41) en uzun ortak altdizi.
//   2. Temel harf temel harfe; işaret, karşı kümede aynı kod noktalı işarete,
//      yoksa aynı sesin karşılığına (DigitalKhatt tenvini U+08F0–U+08F2 veya
//      iklâbda harekeyle yazar), o da yoksa kümenin temel harfine eşlenir.
//   3. Aynı karaktere düşen kurallardan önceliklisi kalır. Kuralı olan bir
//      harfin kuralsız harekeleri harfle aynı kuralı alır (basılı tecvidli
//      mushaflardaki gibi harf harekesiyle birlikte boyanır). Aynı kurallı
//      ardışık karakterler glif başına aralık olur.
// Hiçbir metin değiştirilmez; Tanzil metni yalnızca köprüdür, uygulamaya
// girmez (S9).
import 'package:quran_app/features/quran/domain/tajweed.dart';

typedef TajweedGlyphSpan = ({
  int glyphId,
  int start,
  int end,
  TajweedRule rule,
});

/// Eşleme sayaçları; üretici bunları yazar ve sınırları denetler.
class TajweedAlignmentStats {
  int annotations = 0;
  int mapped = 0;
  int unmapped = 0;
  int inBasmala = 0;
  int unknownRule = 0;
  int overlappingChars = 0;
  final skeletonMismatch = <String>[];
}

int _fold(int r) => switch (r) {
  0x0671 || 0x0623 || 0x0625 || 0x0622 => 0x0627,
  0x0649 || 0x0626 => 0x064A,
  0x0624 => 0x0648,
  _ => r,
};

/// Aynı sesi gösteren işaretler: üstün/ötre/esre tenvini (Tanzil U+064B–D),
/// DigitalKhatt'ın açık tenvini (U+08F0–2) ve tenvinin iklâbda yazıldığı
/// hareke; sükûn biçimleri.
const _equivalentMarks = [
  {0x064B, 0x08F0, 0x064E},
  {0x064C, 0x08F1, 0x064F},
  {0x064D, 0x08F2, 0x0650},
  {0x0652, 0x06E1},
];

/// Harf harekeleri: renkli harften renk alabilenler.
bool _isHaraka(int r) =>
    (r >= 0x064B && r <= 0x0652) || (r >= 0x08F0 && r <= 0x08F2) || r == 0x06E1;

bool _isBase(int r) {
  final c = _fold(r);
  return c >= 0x0622 && c <= 0x064A && c != 0x0640;
}

/// Bir metindeki karakterlerin küme numaraları (−1: ilk harften önce).
List<int> _clusters(List<int> runes) {
  var k = -1;
  return [
    for (final r in runes)
      if (_isBase(r)) ++k else k,
  ];
}

/// Tanzil kümesi → DigitalKhatt kümesi. İskeletler aynıysa birebir; değilse
/// en uzun ortak altdizi (eşleşmeyen harflerin kümesi eşlenmez).
Map<int, int> _clusterMap(List<int> a, List<int> b) {
  if (a.length == b.length && _listEquals(a, b)) {
    return {for (var i = 0; i < a.length; i++) i: i};
  }
  final n = a.length;
  final m = b.length;
  final dp = List.generate(n + 1, (_) => List<int>.filled(m + 1, 0));
  for (var i = n - 1; i >= 0; i--) {
    for (var j = m - 1; j >= 0; j--) {
      dp[i][j] = a[i] == b[j]
          ? dp[i + 1][j + 1] + 1
          : (dp[i + 1][j] > dp[i][j + 1] ? dp[i + 1][j] : dp[i][j + 1]);
    }
  }
  final map = <int, int>{};
  var i = 0;
  var j = 0;
  while (i < n && j < m) {
    if (a[i] == b[j]) {
      map[i++] = j++;
    } else if (dp[i + 1][j] >= dp[i][j + 1]) {
      i++;
    } else {
      j++;
    }
  }
  return map;
}

bool _listEquals(List<int> a, List<int> b) {
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// [tanzil]: `sure:ayet` → Tanzil (2017) ayet metni (surelerin 1. ayetinde
/// besmeleyle). [annotations]: `sure:ayet` → (başlangıç, bitiş, kural
/// kimliği). [glyphs]: `sure:ayet` → ayetin glifleri (ayet sonu hariç),
/// sırayla.
List<TajweedGlyphSpan> alignTajweed({
  required Map<String, String> tanzil,
  required Map<String, List<(int, int, String)>> annotations,
  required Map<String, List<(int, String)>> glyphs,
  required TajweedAlignmentStats stats,
}) {
  final basmala = tanzil['1:1']!;
  final basmalaForms = ['$basmala ', '${basmala[0]}ّ${basmala.substring(1)} '];
  final result = <TajweedGlyphSpan>[];

  for (final MapEntry(key: key, value: fullText) in tanzil.entries) {
    final ayahGlyphs = glyphs[key]!;
    final [surah, ayah] = key.split(':').map(int.parse).toList();
    var offset = 0;
    if (ayah == 1 && surah != 1 && surah != 9) {
      final form = basmalaForms.where(fullText.startsWith).firstOrNull;
      if (form == null) throw StateError('$key: besmele bulunamadı');
      offset = form.length;
    }
    // Arap harfleri BMP içindedir: kod noktası = UTF-16 konumu.
    final body = fullText.substring(offset).codeUnits;
    final tCluster = _clusters(body);

    // DigitalKhatt karakterleri: (glif, konum, küme, kod noktası).
    final dChars = <(int, int, int, int)>[];
    var k = -1;
    for (final (glyphId, text) in ayahGlyphs) {
      for (final (i, r) in text.codeUnits.indexed) {
        if (_isBase(r)) k++;
        dChars.add((glyphId, i, k, r));
      }
    }
    final tSkeleton = [
      for (final r in body)
        if (_isBase(r)) _fold(r),
    ];
    final dSkeleton = [
      for (final c in dChars)
        if (_isBase(c.$4)) _fold(c.$4),
    ];
    if (tSkeleton.length != dSkeleton.length ||
        !_listEquals(tSkeleton, dSkeleton)) {
      stats.skeletonMismatch.add(key);
    }
    final clusterMap = _clusterMap(tSkeleton, dSkeleton);

    // DigitalKhatt kümesi → karakterleri (temel harf ilk sırada).
    final dByCluster = <int, List<(int, int, int, int)>>{};
    for (final c in dChars) {
      if (c.$3 >= 0) dByCluster.putIfAbsent(c.$3, () => []).add(c);
    }

    /// Tanzil karakteri → DigitalKhatt (glif, konum); eşlenemezse null.
    (int, int)? mapChar(int i) {
      final tk = tCluster[i];
      if (tk < 0) return null;
      final dk = clusterMap[tk];
      if (dk == null) return null;
      final target = dByCluster[dk]!;
      final r = body[i];
      if (!_isBase(r)) {
        // Kümede aynı kod noktalı kaçıncı işaret?
        var nth = 0;
        for (var j = i - 1; j >= 0 && tCluster[j] == tk; j--) {
          if (body[j] == r) nth++;
        }
        final same = target.where((c) => c.$4 == r).toList();
        if (nth < same.length) return (same[nth].$1, same[nth].$2);
        final group = _equivalentMarks.where((g) => g.contains(r)).firstOrNull;
        if (group != null) {
          final similar = target.where(
            (c) => c.$4 != r && group.contains(c.$4),
          );
          if (similar.isNotEmpty) return (similar.first.$1, similar.first.$2);
        }
      }
      return (target.first.$1, target.first.$2);
    }

    // Karakter → kural (öncelikli olan).
    final ruleAt = <(int, int), TajweedRule>{};
    for (final (start, end, id)
        in annotations[key] ?? const <(int, int, String)>[]) {
      stats.annotations++;
      final rule = TajweedRule.fromSourceId(id);
      if (rule == null) {
        stats.unknownRule++;
        continue;
      }
      if (end <= offset) {
        stats.inBasmala++;
        continue;
      }
      final hits = <(int, int)>{};
      for (
        var i = (start - offset).clamp(0, body.length);
        i < (end - offset).clamp(0, body.length);
        i++
      ) {
        if (body[i] == 0x20) continue;
        final hit = mapChar(i);
        if (hit != null) hits.add(hit);
      }
      if (hits.isEmpty) {
        stats.unmapped++;
        continue;
      }
      stats.mapped++;
      for (final h in hits) {
        final prev = ruleAt[h];
        if (prev != null) stats.overlappingChars++;
        if (prev == null || rule.priority > prev.priority) ruleAt[h] = rule;
      }
    }

    // Kuralı olan harfin kuralsız harekeleri harfle aynı kuralı alır.
    for (final chars in dByCluster.values) {
      final baseRule = ruleAt[(chars.first.$1, chars.first.$2)];
      if (baseRule == null) continue;
      for (final c in chars.skip(1)) {
        if (_isHaraka(c.$4)) ruleAt.putIfAbsent((c.$1, c.$2), () => baseRule);
      }
    }

    // Glif başına ardışık aynı kurallı karakterler → aralık.
    for (final (glyphId, text) in ayahGlyphs) {
      int? runStart;
      TajweedRule? runRule;
      for (var i = 0; i <= text.length; i++) {
        final rule = i < text.length ? ruleAt[(glyphId, i)] : null;
        if (rule != runRule) {
          if (runRule != null) {
            result.add((
              glyphId: glyphId,
              start: runStart!,
              end: i,
              rule: runRule,
            ));
          }
          runStart = i;
          runRule = rule;
        }
      }
    }
  }
  return result;
}
