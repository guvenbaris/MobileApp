import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/state_views.dart';

/// Hafızlık sekmesi. Araçlar Faz 2'de gelir (E-17…E-20); sekme şimdiden
/// yerinde durur ki sonradan sekme düzeni değişmesin (Y-05, ET-7).
class MemorizePage extends StatelessWidget {
  const MemorizePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabMemorize)),
      body: EmptyState(
        icon: Icons.layers_outlined,
        title: l10n.memorizeSoonTitle,
        message: l10n.memorizeSoonMessage,
      ),
    );
  }
}
