import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/app.dart';
import 'package:quran_app/core/config/flavor.dart';

void main() {
  for (final flavor in Flavor.values) {
    testWidgets('uygulama ${flavor.name} ortamında açılır', (tester) async {
      await tester.pumpWidget(QuranApp(flavor: flavor));
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  }
}
