import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/flavor_provider.dart';
import 'core/routing/app_router.dart';

class QuranApp extends ConsumerWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: ref.watch(flavorProvider).isDev,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
