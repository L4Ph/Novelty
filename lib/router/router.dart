import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/screens/about_page.dart';
import 'package:novelty/screens/data_storage_page.dart';
import 'package:novelty/screens/download_manager_page.dart';
import 'package:novelty/screens/explore_page.dart';
import 'package:novelty/screens/history_page.dart';
import 'package:novelty/screens/library_page.dart';
import 'package:novelty/screens/more_page.dart';
import 'package:novelty/screens/novel_detail_page.dart';
import 'package:novelty/screens/novel_page.dart';
import 'package:novelty/screens/scaffold_page.dart';
import 'package:novelty/screens/settings/appearance_settings_page.dart';
import 'package:novelty/screens/settings/reader_settings_page.dart';
import 'package:novelty/utils/ncode_utils.dart';

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
                  path: 'appearance',
                  builder: (BuildContext context, GoRouterState state) {
                    return const AppearanceSettingsPage();
                  },
                ),
                GoRoute(
                  path: 'reader',
                  builder: (BuildContext context, GoRouterState state) {
                    return const ReaderSettingsPage();
                  },
                ),
                GoRoute(
                  path: 'data-storage',
                  builder: (BuildContext context, GoRouterState state) {
                    return const DataStoragePage();
                  },
                ),
                GoRoute(
                  path: 'about',
                  builder: (BuildContext context, GoRouterState state) {
                    return const AboutPage();
                  },
                ),
                GoRoute(
                  path: 'downloads',
                  builder: (BuildContext context, GoRouterState state) {
                    return const DownloadManagerPage();
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
        final ncode = state.pathParameters['ncode']!.toNormalizedNcode();
        return NovelDetailPage(ncode: ncode);
      },
      routes: [
        GoRoute(
          path: ':episode',
          builder: (BuildContext context, GoRouterState state) {
            final ncode = state.pathParameters['ncode']!.toNormalizedNcode();
            final episode =
                int.tryParse(state.pathParameters['episode'] ?? '1') ?? 1;
            final revised = state.uri.queryParameters['revised'];
            return NovelPage(
              ncode: ncode,
              episode: episode,
              revised: revised,
            );
          },
        ),
      ],
    ),
  ],
);
