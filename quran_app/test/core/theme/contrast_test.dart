import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/theme/app_theme.dart';

/// WCAG 2.1 kontrast oranı: (L1 + 0.05) / (L2 + 0.05).
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

/// NF-E01: her temada renk çiftleri WCAG 2.1 AA'yı karşılar.
/// Metin ≥ 4.5:1; metin olmayan arayüz öğeleri (kenarlık, simge) ≥ 3:1.
void main() {
  const text = 4.5;
  const nonText = 3.0;

  for (final id in AppThemeId.values) {
    final p = AppPalette.of(id);
    final m = p.mushaf;
    // Seçili kelime: yarı saydam vurgu sayfa rengine biner.
    final selected = Color.alphaBlend(m.highlight, m.background);

    final pairs = <String, (Color, Color, double)>{
      'metin / arka plan': (p.onSurface, p.background, text),
      'metin / yüzey': (p.onSurface, p.surface, text),
      'ikincil metin / arka plan': (p.onSurfaceMuted, p.background, text),
      'ikincil metin / yüzey': (p.onSurfaceMuted, p.surface, text),
      'vurgu metni / arka plan': (p.primary, p.background, text),
      'vurgu metni / yüzey': (p.primary, p.surface, text),
      'düğme metni / düğme': (p.onPrimary, p.primary, text),
      'kap metni / kap': (p.onPrimaryContainer, p.primaryContainer, text),
      'hata / yüzey': (p.error, p.surface, text),
      'hata düğmesi metni / hata': (p.onError, p.error, text),
      'kenarlık / arka plan': (p.outline, p.background, nonText),
      'mushaf metni / sayfa': (m.text, m.background, text),
      'mushaf süsü / sayfa': (m.ornament, m.background, text),
      'seçili kelime / vurgu': (m.text, selected, text),
    };

    group('${id.name} teması', () {
      pairs.forEach((name, pair) {
        final (fg, bg, min) = pair;
        test('$name ≥ $min:1', () {
          final ratio = contrast(fg, bg);
          expect(
            ratio,
            greaterThanOrEqualTo(min),
            reason: '${id.name}: $name = ${ratio.toStringAsFixed(2)}:1',
          );
        });
      });
    });
  }

  test('koyu temada mushaf sayfası da koyudur (M2-08)', () {
    expect(
      AppPalette.dark.mushaf.background.computeLuminance(),
      lessThan(0.05),
    );
    expect(AppPalette.dark.brightness, Brightness.dark);
  });

  test('kontrast hesabı bilinen değerleri verir', () {
    expect(
      contrast(const Color(0xFF000000), const Color(0xFFFFFFFF)),
      closeTo(21, 0.01),
    );
    expect(
      contrast(const Color(0xFF777777), const Color(0xFFFFFFFF)),
      closeTo(4.48, 0.01),
    );
  });
}
