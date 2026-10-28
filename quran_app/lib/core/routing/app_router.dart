import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/me/presentation/me_page.dart';
import '../../features/memorize/presentation/memorize_page.dart';
import '../../features/quran/presentation/quran_index_page.dart';
import '../../features/reader/presentation/reader_entry.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/today/presentation/today_page.dart';
import '../widgets/app_shell.dart';
import 'app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.today,
    routes: [
      // Alt sekmeler; her sekme kendi geçmişini korur (TK-16).
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.today,
                builder: (context, state) => const TodayPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.quran,
                builder: (context, state) => const QuranIndexPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.memorize,
                builder: (context, state) => const MemorizePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.me,
                builder: (context, state) => const MePage(),
              ),
            ],
          ),
        ],
      ),
      // Tam ekran: sekme çubuğunun üstünde açılır.
      GoRoute(
        path: AppRoutes.reader,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ReaderEntry(
          ayah: state.uri.queryParameters['ayah'],
          page: state.uri.queryParameters['page'],
        ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
