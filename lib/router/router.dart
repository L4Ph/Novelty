import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/screens/about_page.dart';
import 'package:novelty/screens/explore_page.dart';
import 'package:novelty/screens/history_page.dart';
import 'package:novelty/screens/library_page.dart';
import 'package:novelty/screens/more_page.dart';
import 'package:novelty/screens/novel_detail_page.dart';
import 'package:novelty/screens/novel_page.dart';
import 'package:novelty/screens/scaffold_page.dart';
import 'package:novelty/screens/settings_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// ルーティングの設定。
/// GoRouterを使用して、アプリのナビゲーションを管理
final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldPage(child: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const LibraryPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/explore',
              builder: (context, state) => const ExplorePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/more',
              builder: (context, state) => const MorePage(),
              routes: [
                GoRoute(
                  path: 'settings',
                  builder: (BuildContext context, GoRouterState state) {
                    return const SettingsPage();
                  },
                ),
                GoRoute(
                  path: 'about',
                  builder: (BuildContext context, GoRouterState state) {
                    return const AboutPage();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/novel/:ncode',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        final ncode = state.pathParameters['ncode']!;
        return NovelDetailPage(ncode: ncode);
      },
      routes: [
        GoRoute(
          path: ':episode',
          builder: (BuildContext context, GoRouterState state) {
            final ncode = state.pathParameters['ncode']!;
            final episode =
                int.tryParse(state.pathParameters['episode'] ?? '1') ?? 1;
            return NovelPage(ncode: ncode, episode: episode);
          },
        ),
      ],
    ),
  ],
);
