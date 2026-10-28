import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/theme/app_theme.dart';
import 'package:quran_app/core/widgets/app_button.dart';
import 'package:quran_app/core/widgets/app_list_item.dart';
import 'package:quran_app/core/widgets/state_views.dart';

import '../../helpers/localized_app.dart';

Widget _host(Widget child, {AppThemeId theme = AppThemeId.light}) =>
    localizedApp(
      Scaffold(body: child),
      theme: buildAppTheme(AppPalette.of(theme)),
    );

void main() {
  testWidgets('düğmeler en az 48×48 (NF-E03)', (tester) async {
    await tester.pumpWidget(
      _host(
        Column(
          children: [
            AppButton(label: 'A', onPressed: () {}),
            AppButton.secondary(label: 'B', onPressed: () {}, icon: Icons.add),
            AppButton.text(label: 'C', onPressed: () {}),
          ],
        ),
      ),
    );
    for (final label in ['A', 'B', 'C']) {
      final size = tester.getSize(
        find.ancestor(
          of: find.text(label),
          matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
        ),
      );
      expect(size.width, greaterThanOrEqualTo(AppSpacing.minTapTarget));
      expect(size.height, greaterThanOrEqualTo(AppSpacing.minTapTarget));
    }
  });

  testWidgets('hata durumu genel metni ve "Tekrar dene"yi gösterir', (
    tester,
  ) async {
    var retried = 0;
    await tester.pumpWidget(
      _host(ErrorState(error: StateError('x'), onRetry: () => retried++)),
    );
    expect(find.text('Bir sorun oluştu'), findsOneWidget);
    expect(find.text('İçerik yüklenemedi.'), findsOneWidget);
    await tester.tap(find.byKey(const Key('errorState.retry')));
    expect(retried, 1);
  });

  testWidgets('hata durumu: yeniden deneme yoksa düğme yok', (tester) async {
    await tester.pumpWidget(_host(const ErrorState(message: 'Özel mesaj')));
    expect(find.text('Özel mesaj'), findsOneWidget);
    expect(find.byKey(const Key('errorState.retry')), findsNothing);
  });

  testWidgets('boş durum başlık, açıklama ve eylem gösterir', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _host(
        EmptyState(
          icon: Icons.bookmark_border,
          title: 'Başlık',
          message: 'Açıklama',
          actionLabel: 'Eylem',
          onAction: () => tapped = true,
        ),
      ),
    );
    expect(find.text('Başlık'), findsOneWidget);
    expect(find.text('Açıklama'), findsOneWidget);
    await tester.tap(find.text('Eylem'));
    expect(tapped, isTrue);
  });

  for (final id in AppThemeId.values) {
    testWidgets('${id.name}: bileşenler kontrast ve dokunma kurallarına uyar', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          ListView(
            children: [
              const AppSectionHeader('Bölüm'),
              AppListItem(title: 'Satır', subtitle: 'Alt satır', onTap: () {}),
              AppButton(label: 'Ana', onPressed: () {}),
              AppButton.secondary(label: 'İkincil', onPressed: () {}),
              SizedBox(height: 360, child: ErrorState(onRetry: () {})),
            ],
          ),
          theme: id,
        ),
      );
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });
  }
}
