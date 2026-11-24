import 'package:flutter/material.dart';
import 'package:novelty/router/destinations.dart';
import 'package:novelty/router/screens.dart';
import 'package:novelty/screens/scaffold_page.dart';
import 'package:tiny_router/tiny_router.dart';

/// The app's tabs. Each owns a navigation stack of its own.
enum AppTab {
  /// Library.
  library,

  /// Explore.
  explore,

  /// History.
  history,

  /// "More".
  more,
}

/// The app's navigation state.
///
/// Two layers, because the shell has two: a stack per tab, and one stack of
/// screens that cover the tabs. Which layer a screen goes to is decided by the
/// caller (`push` keeps the tab bar, `pushOverlay` hides it), not by the
/// screen.
class AppRouter extends ChangeNotifier {
  /// Creates the router at the library tab.
  AppRouter() {
    for (final tab in AppTab.values) {
      stackOf(tab).addListener(notifyListeners);
    }
    overlays.addListener(notifyListeners);
  }

  static const AppTab _initialTab = AppTab.library;
  static final Map<AppTab, NovelDestination> _roots =
      <AppTab, NovelDestination>{
        AppTab.library: const LibraryDest(),
        AppTab.explore: const ExploreDest(),
        AppTab.history: const HistoryDest(),
        AppTab.more: const MoreDest(),
      };

  final _branches = <AppTab, RouteStack<NovelDestination>>{
    for (final tab in AppTab.values)
      tab: RouteStack<NovelDestination>([_roots[tab]!]),
  };

  /// Screens that cover the whole shell, including the tab bar.
  final overlays = RouteStack<NovelDestination>();

  AppTab _selected = _initialTab;

  /// The tab currently shown.
  AppTab get selected => _selected;

  /// The stack of [tab].
  RouteStack<NovelDestination> stackOf(AppTab tab) => _branches[tab]!;

  /// Pushes [destination] inside the current tab, keeping the tab bar.
  void push(NovelDestination destination) =>
      stackOf(_selected).push(destination);

  /// Pushes [destination] over the shell, hiding the tab bar.
  void pushOverlay(NovelDestination destination) => overlays.push(destination);

  /// Pops the topmost screen, overlays first. Returns false when there is
  /// nothing left to pop.
  bool pop() => overlays.pop() || stackOf(_selected).pop();

  /// Selects [tab]. Selecting the current tab again returns it to its root,
  /// which is what a second tap on a tab bar item is expected to do.
  void select(AppTab tab) {
    if (tab == _selected) {
      stackOf(tab).popToRoot();
      return;
    }
    _selected = tab;
    notifyListeners();
  }

  /// Returns to the state the app starts in.
  ///
  /// Used after a database import, where the screens on the stacks belong to
  /// the database that was just replaced.
  void reset() {
    for (final stack in _branches.values) {
      stack.clear();
    }
    overlays.clear();
    if (_selected != _initialTab) {
      _selected = _initialTab;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    for (final stack in _branches.values) {
      stack.removeListener(notifyListeners);
    }
    overlays.removeListener(notifyListeners);
    super.dispose();
  }
}

/// The app's router.
final appRouter = AppRouter();

/// The router configuration handed to `MaterialApp.router`.
///
/// No route information provider or parser is wired: this app builds its
/// screens from state, so it has no URL to parse. Deep links would be added by
/// supplying a parser, without touching the router itself.
final appRouterConfig = _AppRouterConfig();

class _AppRouterConfig extends RouterConfig<Object> {
  _AppRouterConfig()
    : super(
        routerDelegate: RouteStackDelegate<NovelDestination>(
          stack: appRouter.overlays,
          rootBuilder: (context) => const ScaffoldPage(),
          builder: (context, destination) => screenFor(destination),
        ),
        // Without this, Router registers no pop callback and the system back
        // never reaches the delegate: every press would leave the app.
        backButtonDispatcher: RootBackButtonDispatcher(),
      );
}
