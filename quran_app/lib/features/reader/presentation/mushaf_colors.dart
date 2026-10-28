import 'package:flutter/painting.dart';

import '../application/reader_settings.dart';

/// Mushaf sayfasının renkleri (M2-08). F0-08'de tema sistemine taşınır;
/// kontrast oranları orada WCAG AA'ya göre doğrulanır (NF-E01).
class MushafColors {
  const MushafColors({
    required this.background,
    required this.text,
    required this.ornament,
    required this.highlight,
  });

  factory MushafColors.of(MushafTheme theme) => switch (theme) {
    MushafTheme.light => const MushafColors(
      background: Color(0xFFFFFFFF),
      text: Color(0xFF111111),
      ornament: Color(0xFF1F6F4A),
      highlight: Color(0x332E7D32),
    ),
    MushafTheme.sepia => const MushafColors(
      background: Color(0xFFF7EEDB),
      text: Color(0xFF2B2116),
      ornament: Color(0xFF8A5A1F),
      highlight: Color(0x40C08A2E),
    ),
    // Koyu modda metin alanı da koyudur (M2-08).
    MushafTheme.dark => const MushafColors(
      background: Color(0xFF121212),
      text: Color(0xFFE8E2D6),
      ornament: Color(0xFFC9A55C),
      highlight: Color(0x40C9A55C),
    ),
  };

  final Color background;
  final Color text;
  final Color ornament;
  final Color highlight;
}
