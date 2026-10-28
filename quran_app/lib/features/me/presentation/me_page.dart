import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/app_list_item.dart';

/// Ben sekmesi (`Ekran_Tasarimi.md` §3.1). Faz 1'de ayarlar ve lisanslar;
/// okuma ilerlemeleri (E-16) ve indirmeler (E-13) Faz 1 içinde, istatistik,
/// zikir ve hesap sonraki fazlarda eklenir.
class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabMe)),
      body: ListView(
        children: [
          AppListItem(
            key: const Key('me.settings'),
            leading: const Icon(Icons.settings_outlined),
            title: l10n.settingsTitle,
            onTap: () => context.push(AppRoutes.settings),
          ),
          AppListItem(
            key: const Key('me.licenses'),
            leading: const Icon(Icons.description_outlined),
            title: l10n.settingsLicenses,
            subtitle: l10n.settingsLicensesSubtitle,
            onTap: () => showLicensePage(
              context: context,
              applicationName: l10n.appTitle,
              applicationLegalese: l10n.aboutLegalese,
            ),
          ),
        ],
      ),
    );
  }
}
