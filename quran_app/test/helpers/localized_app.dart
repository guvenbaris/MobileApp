import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/l10n/l10n.dart';

/// Tek bir ekranı uygulamanın dil ayarlarıyla saran `MaterialApp`.
Widget localizedApp(Widget home, {Locale locale = const Locale('tr')}) =>
    MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: kSupportedLocales,
      home: home,
    );

/// Geri tuşuna basar. `tester.pageBack()` tuşu İngilizce "Back" ipucuyla
/// aradığı için Türkçe ve Arapça arayüzde bulamaz; bu yardımcı dilden
/// bağımsızdır.
Future<void> tapBack(WidgetTester tester) async {
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();
}
