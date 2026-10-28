import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';

// Metinler F0-07'de ARB dosyalarına taşınır.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        actions: [
          IconButton(
            key: const Key('home.settings'),
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Ayarlar',
            onPressed: () => context.go(AppRoutes.settings),
          ),
        ],
      ),
      body: Center(
        child: FilledButton(
          key: const Key('home.read'),
          onPressed: () => context.go(AppRoutes.reader),
          child: const Text('Okumaya başla'),
        ),
      ),
    );
  }
}
