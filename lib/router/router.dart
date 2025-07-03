import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/screens/history_page.dart';
import 'package:novelty/screens/library_page.dart';
import 'package:novelty/screens/more_page.dart';
import 'package:novelty/screens/novel_page.dart';
import 'package:novelty/screens/ranking_page.dart';
import 'package:novelty/screens/scaffold_page.dart';
import 'package:novelty/screens/search_page.dart';
import 'package:novelty/screens/settings_page.dart';
import 'package:novelty/screens/toc_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
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
              routes: [
                GoRoute(
                  path: 'novel/:ncode',
                  builder: (BuildContext context, GoRouterState state) {
                    final ncode = state.pathParameters['ncode']!;
                    final episode =
                        int.tryParse(state.uri.queryParameters['episode'] ?? '1') ?? 1;
                    return NovelPage(ncode: ncode, episode: episode);
                  },
                ),
                GoRoute(
                  path: 'toc/:ncode',
                  builder: (BuildContext context, GoRouterState state) {
                    final ncode = state.pathParameters['ncode']!;
                    return TocPage(ncode: ncode);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/ranking',
              builder: (context, state) => const RankingPage(),
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
              path: '/search',
              builder: (context, state) => const SearchPage(),
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
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
