import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_page.dart';
import '../../features/reader/presentation/reader_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: AppRoutes.reader.substring(1),
            builder: (context, state) => const ReaderPage(),
          ),
          GoRoute(
            path: AppRoutes.settings.substring(1),
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
