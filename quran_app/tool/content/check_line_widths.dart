// Mushaf düzenini sayfa fontlarıyla doğrular (F0-04, Q-13).
//
// QCF sayfa fontlarında iki yana yaslı her satır aynı genişliğe gelecek
// şekilde tasarlanmıştır. Bir kelime yanlış satıra yazılmışsa o satır ve
// komşusu belirgin biçimde uzar/kısalır. Bu araç her satırdaki gliflerin
// genişliğini toplar ve sayfanın ortancasından sapan satırları listeler.
//
// Fontlar depoda değildir (208 MB). QUL'den indirilen 604 TTF'nin bulunduğu
// klasörle çalıştırılır (quran_app klasöründe):
//   dart run tool/content/check_line_widths.dart <font_klasörü> [eşik_yüzde]
// Çıkış kodu: sapan satır varsa 1.
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:quran_app/features/quran/data/content_database.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    stderr.writeln('Kullanım: check_line_widths.dart <font_klasörü> [eşik]');
    exit(64);
  }
  final fontDir = args[0];
  final threshold = args.length > 1 ? double.parse(args[1]) : 3.0;

  final db = ContentDatabase(NativeDatabase(File(kContentAssetPath)));
  try {
    final layout = await db.select(db.mushafLayouts).getSingle();
    final glyphs = {
      for (final g in await db.select(db.layoutGlyphs).get()) g.id: g.glyph,
    };
    final lines =
        await (db.select(db.layoutLines)
              ..where((l) => l.type.equalsValue(LayoutLineType.ayah))
              ..orderBy([
                (l) => OrderingTerm(expression: l.page),
                (l) => OrderingTerm(expression: l.line),
              ]))
            .get();

    final flagged = <String>[];
    final deviations = <double>[];
    for (var page = 1; page <= layout.pageCount; page++) {
      final font = _TrueTypeFont(File('$fontDir/p$page.ttf').readAsBytesSync());
      final widths = <int, int>{};
      final justified = <int>[];
      for (final l in lines.where((l) => l.page == page)) {
        var width = 0;
        for (var id = l.firstGlyphId!; id <= l.lastGlyphId!; id++) {
          for (final rune in glyphs[id]!.runes) {
            if (rune == 0x20) continue;
            final advance = font.advanceOf(rune);
            if (advance == null) {
              flagged.add(
                's.$page satır ${l.line}: fontta glif yok U+'
                '${rune.toRadixString(16)}',
              );
              continue;
            }
            width += advance;
          }
        }
        widths[l.line] = width;
        if (!l.isCentered) justified.add(l.line);
      }
      if (justified.isEmpty) continue;
      final sorted = [for (final l in justified) widths[l]!]..sort();
      final median = sorted[sorted.length ~/ 2];
      for (final line in justified) {
        final deviation = (widths[line]! - median) / median * 100;
        deviations.add(deviation.abs());
        if (deviation.abs() > threshold) {
          flagged.add('s.$page satır $line: ${deviation.toStringAsFixed(1)}%');
        }
      }
    }

    deviations.sort();
    String pct(double p) =>
        deviations[(deviations.length * p).floor().clamp(
              0,
              deviations.length - 1,
            )]
            .toStringAsFixed(2);
    stdout
      ..writeln('${deviations.length} iki yana yaslı satır ölçüldü')
      ..writeln(
        'Sapma: ortanca %${pct(.5)}, %99: %${pct(.99)}, '
        'en büyük: %${deviations.last.toStringAsFixed(2)}',
      )
      ..writeln('Eşiği (%$threshold) aşan: ${flagged.length}');
    flagged.forEach(stdout.writeln);
    exitCode = flagged.isEmpty ? 0 : 1;
  } finally {
    await db.close();
  }
}

/// Yalnızca `cmap` ve `hmtx` tablolarını okuyan küçük TrueType okuyucu.
class _TrueTypeFont {
  _TrueTypeFont(Uint8List bytes) : _data = ByteData.sublistView(bytes) {
    final numTables = _data.getUint16(4);
    for (var i = 0; i < numTables; i++) {
      final record = 12 + i * 16;
      final tag = String.fromCharCodes(bytes.sublist(record, record + 4));
      _tables[tag] = _data.getUint32(record + 8);
    }
    _numberOfHMetrics = _data.getUint16(_tables['hhea']! + 34);
    _readCmap();
  }

  final ByteData _data;
  final Map<String, int> _tables = {};
  final Map<int, int> _glyphOf = {};
  late final int _numberOfHMetrics;

  int? advanceOf(int codePoint) {
    final glyph = _glyphOf[codePoint];
    if (glyph == null) return null;
    final index = glyph < _numberOfHMetrics ? glyph : _numberOfHMetrics - 1;
    return _data.getUint16(_tables['hmtx']! + index * 4);
  }

  void _readCmap() {
    final cmap = _tables['cmap']!;
    final count = _data.getUint16(cmap + 2);
    for (var i = 0; i < count; i++) {
      final offset = cmap + _data.getUint32(cmap + 4 + i * 8 + 4);
      switch (_data.getUint16(offset)) {
        case 4:
          _readFormat4(offset);
        case 12:
          _readFormat12(offset);
      }
    }
  }

  void _readFormat4(int offset) {
    final segX2 = _data.getUint16(offset + 6);
    final ends = offset + 14;
    final starts = ends + segX2 + 2;
    final deltas = starts + segX2;
    final rangeOffsets = deltas + segX2;
    for (var s = 0; s < segX2 ~/ 2; s++) {
      final end = _data.getUint16(ends + s * 2);
      final start = _data.getUint16(starts + s * 2);
      final delta = _data.getInt16(deltas + s * 2);
      final rangeOffset = _data.getUint16(rangeOffsets + s * 2);
      for (var c = start; c <= end && c != 0xFFFF; c++) {
        int glyph;
        if (rangeOffset == 0) {
          glyph = (c + delta) & 0xFFFF;
        } else {
          final address = rangeOffsets + s * 2 + rangeOffset + (c - start) * 2;
          glyph = _data.getUint16(address);
          if (glyph != 0) glyph = (glyph + delta) & 0xFFFF;
        }
        if (glyph != 0) _glyphOf.putIfAbsent(c, () => glyph);
      }
    }
  }

  void _readFormat12(int offset) {
    final groups = _data.getUint32(offset + 12);
    for (var g = 0; g < groups; g++) {
      final group = offset + 16 + g * 12;
      final start = _data.getUint32(group);
      final end = _data.getUint32(group + 4);
      final startGlyph = _data.getUint32(group + 8);
      for (var c = start; c <= end; c++) {
        _glyphOf.putIfAbsent(c, () => startGlyph + c - start);
      }
    }
  }
}
