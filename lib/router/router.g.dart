// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $appShellRouteData,
  $novelDetailRoute,
  $authorNovelsRoute,
];

RouteBase get $appShellRouteData => StatefulShellRouteData.$route(
  factory: $AppShellRouteDataExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      navigatorKey: LibraryBranchData.$navigatorKey,
      routes: [
        GoRouteData.$route(
          path: '/',
          hasOverriddenOnExit: false,
          factory: $LibraryRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/explore',
          hasOverriddenOnExit: false,
          factory: $ExploreRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/history',
          hasOverriddenOnExit: false,
          factory: $HistoryRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/more',
          hasOverriddenOnExit: false,
          factory: $MoreRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'appearance',
              hasOverriddenOnExit: false,
              factory: $AppearanceSettingsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'reader',
              hasOverriddenOnExit: false,
              factory: $ReaderSettingsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'data-storage',
              hasOverriddenOnExit: false,
              factory: $DataStorageRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'about',
              hasOverriddenOnExit: false,
              factory: $AboutRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'downloads',
              hasOverriddenOnExit: false,
              factory: $DownloadsRoute._fromState,
            ),
          ],
        ),
      ],
    ),
  ],
);

extension $AppShellRouteDataExtension on AppShellRouteData {
  static AppShellRouteData _fromState(GoRouterState state) =>
      const AppShellRouteData();
}

mixin $LibraryRoute on GoRouteData {
  static LibraryRoute _fromState(GoRouterState state) => const LibraryRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ExploreRoute on GoRouteData {
  static ExploreRoute _fromState(GoRouterState state) => const ExploreRoute();

  @override
  String get location => GoRouteData.$location('/explore');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $HistoryRoute on GoRouteData {
  static HistoryRoute _fromState(GoRouterState state) => const HistoryRoute();

  @override
  String get location => GoRouteData.$location('/history');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MoreRoute on GoRouteData {
  static MoreRoute _fromState(GoRouterState state) => const MoreRoute();

  @override
  String get location => GoRouteData.$location('/more');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AppearanceSettingsRoute on GoRouteData {
  static AppearanceSettingsRoute _fromState(GoRouterState state) =>
      const AppearanceSettingsRoute();

  @override
  String get location => GoRouteData.$location('/more/appearance');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ReaderSettingsRoute on GoRouteData {
  static ReaderSettingsRoute _fromState(GoRouterState state) =>
      const ReaderSettingsRoute();

  @override
  String get location => GoRouteData.$location('/more/reader');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DataStorageRoute on GoRouteData {
  static DataStorageRoute _fromState(GoRouterState state) =>
      const DataStorageRoute();

  @override
  String get location => GoRouteData.$location('/more/data-storage');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AboutRoute on GoRouteData {
  static AboutRoute _fromState(GoRouterState state) => const AboutRoute();

  @override
  String get location => GoRouteData.$location('/more/about');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DownloadsRoute on GoRouteData {
  static DownloadsRoute _fromState(GoRouterState state) =>
      const DownloadsRoute();

  @override
  String get location => GoRouteData.$location('/more/downloads');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $novelDetailRoute => GoRouteData.$route(
  path: '/novel/:source/:workId',
  hasOverriddenOnExit: false,
  parentNavigatorKey: NovelDetailRoute.$parentNavigatorKey,
  factory: $NovelDetailRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: ':episode',
      hasOverriddenOnExit: false,
      factory: $NovelEpisodeRoute._fromState,
    ),
  ],
);

mixin $NovelDetailRoute on GoRouteData {
  static NovelDetailRoute _fromState(GoRouterState state) => NovelDetailRoute(
    source: state.pathParameters['source']!,
    workId: state.pathParameters['workId']!,
  );

  NovelDetailRoute get _self => this as NovelDetailRoute;

  @override
  String get location => GoRouteData.$location(
    '/novel/${Uri.encodeComponent(_self.source)}/${Uri.encodeComponent(_self.workId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $NovelEpisodeRoute on GoRouteData {
  static NovelEpisodeRoute _fromState(GoRouterState state) => NovelEpisodeRoute(
    source: state.pathParameters['source']!,
    workId: state.pathParameters['workId']!,
    episode: int.parse(state.pathParameters['episode']!),
    revised: state.uri.queryParameters['revised'],
  );

  NovelEpisodeRoute get _self => this as NovelEpisodeRoute;

  @override
  String get location => GoRouteData.$location(
    '/novel/${Uri.encodeComponent(_self.source)}/${Uri.encodeComponent(_self.workId)}/${Uri.encodeComponent(_self.episode.toString())}',
    queryParams: {if (_self.revised != null) 'revised': _self.revised},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $authorNovelsRoute => GoRouteData.$route(
  path: '/author/:userId',
  hasOverriddenOnExit: false,
  parentNavigatorKey: AuthorNovelsRoute.$parentNavigatorKey,
  factory: $AuthorNovelsRoute._fromState,
);

mixin $AuthorNovelsRoute on GoRouteData {
  static AuthorNovelsRoute _fromState(GoRouterState state) =>
      AuthorNovelsRoute(userId: int.parse(state.pathParameters['userId']!));

  AuthorNovelsRoute get _self => this as AuthorNovelsRoute;

  @override
  String get location => GoRouteData.$location(
    '/author/${Uri.encodeComponent(_self.userId.toString())}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
