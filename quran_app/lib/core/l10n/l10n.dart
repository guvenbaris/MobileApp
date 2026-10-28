import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../l10n/generated/app_localizations.dart';
import 'app_language.dart';

export '../../l10n/generated/app_localizations.dart';
export 'app_language.dart';

/// Seçili rakam sistemini alt ağaca taşır. Uygulamada `QuranApp` koyar;
/// yoksa (ör. tek ekranlı widget testleri) [NumeralSystem.auto] geçerlidir.
class NumeralScope extends InheritedWidget {
  const NumeralScope({required this.numerals, required super.child, super.key});

  final NumeralSystem numerals;

  static NumeralSystem of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NumeralScope>()?.numerals ??
      NumeralSystem.auto;

  @override
  bool updateShouldNotify(NumeralScope oldWidget) =>
      numerals != oldWidget.numerals;
}

const _western = '0123456789';
const _arabic = '٠١٢٣٤٥٦٧٨٩';

/// Metindeki rakamları [arabic] ise Doğu Arap, değilse Batı rakamına çevirir.
String convertDigits(String text, {required bool arabic}) {
  final from = arabic ? _western : _arabic;
  final to = arabic ? _arabic : _western;
  final buffer = StringBuffer();
  for (final rune in text.runes) {
    final char = String.fromCharCode(rune);
    final i = from.indexOf(char);
    buffer.write(i < 0 ? char : to[i]);
  }
  return buffer.toString();
}

extension L10nContext on BuildContext {
  /// Seçili dildeki arayüz metinleri (NF-Y01).
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Doğu Arap rakamları mı kullanılıyor (NF-Y03).
  bool get usesArabicDigits => switch (NumeralScope.of(this)) {
    NumeralSystem.arabic => true,
    NumeralSystem.western => false,
    NumeralSystem.auto => Localizations.localeOf(this).languageCode == 'ar',
  };

  /// Tamsayıyı dilin biçiminde ve seçili rakamlarla yazar.
  String formatInt(int value) {
    final locale = Localizations.localeOf(this).toLanguageTag();
    return convertDigits(
      NumberFormat.decimalPattern(locale).format(value),
      arabic: usesArabicDigits,
    );
  }

  /// Rakam içeren konum metnini (ör. `2:255`) seçili rakamlarla yazar.
  String formatDigits(Object value) =>
      convertDigits('$value', arabic: usesArabicDigits);
}
