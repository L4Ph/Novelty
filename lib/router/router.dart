import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/screens/about_page.dart';
import 'package:novelty/screens/author_novels_page.dart';
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

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// ルーティングの設定。
/// go_router_builder で生成された型安全なルートを使用する。
final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: $appRoutes,
  errorBuilder: (context, state) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          'ページを表示できませんでした: ${state.error ?? ''}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  },
);

/// シェル（下部ナビゲーション）を構成するルート。
@TypedStatefulShellRoute<AppShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<LibraryBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<LibraryRoute>(path: '/'),
      ],
    ),
    TypedStatefulShellBranch<ExploreBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ExploreRoute>(path: '/explore'),
      ],
    ),
    TypedStatefulShellBranch<HistoryBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<HistoryRoute>(path: '/history'),
      ],
    ),
    TypedStatefulShellBranch<MoreBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<MoreRoute>(
          path: '/more',
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<AppearanceSettingsRoute>(path: 'appearance'),
            TypedGoRoute<ReaderSettingsRoute>(path: 'reader'),
            TypedGoRoute<DataStorageRoute>(path: 'data-storage'),
            TypedGoRoute<AboutRoute>(path: 'about'),
            TypedGoRoute<DownloadsRoute>(path: 'downloads'),
          ],
        ),
      ],
    ),
  ],
)
/// アプリ全体のシェル（下部ナビゲーション）を構成するルートデータ。
class AppShellRouteData extends StatefulShellRouteData {
  /// コンストラクタ。
  const AppShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return ScaffoldPage(child: navigationShell);
  }
}

/// ライブラリタブのシェルブランチ。
class LibraryBranchData extends StatefulShellBranchData {
  /// コンストラクタ。
  const LibraryBranchData();

  /// ライブラリブランチのナビゲーターキー。
  static final GlobalKey<NavigatorState> $navigatorKey = _shellNavigatorKey;
}

/// 探索タブのシェルブランチ。
class ExploreBranchData extends StatefulShellBranchData {
  /// コンストラクタ。
  const ExploreBranchData();
}

/// 履歴タブのシェルブランチ。
class HistoryBranchData extends StatefulShellBranchData {
  /// コンストラクタ。
  const HistoryBranchData();
}

/// "もっと"タブのシェルブランチ。
class MoreBranchData extends StatefulShellBranchData {
  /// コンストラクタ。
  const MoreBranchData();
}

/// ライブラリ画面のルート。
class LibraryRoute extends GoRouteData with $LibraryRoute {
  /// コンストラクタ。
  const LibraryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LibraryPage();
  }
}

/// 探索画面のルート。
class ExploreRoute extends GoRouteData with $ExploreRoute {
  /// コンストラクタ。
  const ExploreRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ExplorePage();
  }
}

/// 履歴画面のルート。
class HistoryRoute extends GoRouteData with $HistoryRoute {
  /// コンストラクタ。
  const HistoryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HistoryPage();
  }
}

/// "もっと"画面のルート。
class MoreRoute extends GoRouteData with $MoreRoute {
  /// コンストラクタ。
  const MoreRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MorePage();
  }
}

/// 外観設定画面のルート。
class AppearanceSettingsRoute extends GoRouteData
    with $AppearanceSettingsRoute {
  /// コンストラクタ。
  const AppearanceSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AppearanceSettingsPage();
  }
}

/// 読書設定画面のルート。
class ReaderSettingsRoute extends GoRouteData with $ReaderSettingsRoute {
  /// コンストラクタ。
  const ReaderSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ReaderSettingsPage();
  }
}

/// データ保存画面のルート。
class DataStorageRoute extends GoRouteData with $DataStorageRoute {
  /// コンストラクタ。
  const DataStorageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DataStoragePage();
  }
}

/// アプリ情報画面のルート。
class AboutRoute extends GoRouteData with $AboutRoute {
  /// コンストラクタ。
  const AboutRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AboutPage();
  }
}

/// ダウンロード管理画面のルート。
class DownloadsRoute extends GoRouteData with $DownloadsRoute {
  /// コンストラクタ。
  const DownloadsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DownloadManagerPage();
  }
}

/// 小説詳細画面のルート。
@TypedGoRoute<NovelDetailRoute>(
  path: '/novel/:ncode',
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<NovelEpisodeRoute>(path: ':episode'),
  ],
)
class NovelDetailRoute extends GoRouteData with $NovelDetailRoute {
  /// コンストラクタ。
  const NovelDetailRoute({required this.ncode});

  /// ルートの親ナビゲーターキー。
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  /// 小説のNコード。
  final String ncode;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NovelDetailPage(ncode: ncode.toNormalizedNcode());
  }
}

/// エピソード閲覧画面のルート。
class NovelEpisodeRoute extends GoRouteData with $NovelEpisodeRoute {
  /// コンストラクタ。
  const NovelEpisodeRoute({
    required this.ncode,
    required this.episode,
    this.revised,
  });

  /// 小説のNコード。
  final String ncode;

  /// エピソード番号。
  final int episode;

  /// 改稿版フラグ（クエリパラメータ）。
  final String? revised;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NovelPage(
      ncode: ncode.toNormalizedNcode(),
      episode: episode,
      revised: revised,
    );
  }
}

/// 作者の作品一覧画面のルート。
@TypedGoRoute<AuthorNovelsRoute>(
  path: '/author/:userId',
)
class AuthorNovelsRoute extends GoRouteData with $AuthorNovelsRoute {
  /// コンストラクタ。
  const AuthorNovelsRoute({required this.userId});

  /// ルートの親ナビゲーターキー。
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  /// 作者ID。
  final int userId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AuthorNovelsPage(userId: userId);
  }
}
