import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/domain/quran_models.dart';

// Metinler F0-07'de ARB dosyalarına taşınır.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahs = ref.watch(surahsProvider);
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
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('home.read'),
        onPressed: () => context.go(AppRoutes.reader),
        label: const Text('Okumaya başla'),
      ),
      body: switch (surahs) {
        AsyncData(:final value) => ListView.builder(
          key: const Key('home.surahList'),
          itemCount: value.length,
          itemBuilder: (context, i) {
            final surah = value[i];
            return ListTile(
              key: Key('home.surah.${surah.id}'),
              onTap: () => _openSurah(context, ref, surah.id),
              leading: Text('${surah.id}'),
              title: Text(surah.nameTr),
              subtitle: Text('${surah.ayahCount} ayet'),
              trailing: Text(
                surah.nameArabic,
                textDirection: TextDirection.rtl,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          },
        ),
        AsyncError(:final error) => Center(child: Text('$error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Future<void> _openSurah(
    BuildContext context,
    WidgetRef ref,
    int surah,
  ) async {
    final page = await ref
        .read(quranRepositoryProvider)
        .pageOf(kDefaultLayoutId, AyahRef(surah, 1));
    if (!context.mounted) return;
    context.go(AppRoutes.readerAt(page.valueOrNull ?? 1));
  }
}
