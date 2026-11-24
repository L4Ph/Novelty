import 'package:flutter/material.dart';
import 'package:tiny_router/tiny_router.dart';
import 'package:tiny_router_flutter/src/page_factory.dart';

/// A [RouterDelegate] whose page list is [rootBuilder] followed by [stack].
///
/// The root page is the app's shell — the widget that stays put (typically tabs
/// and their own navigators) while [stack] pushes screens over it. Popping
/// those screens, by gesture or by the back button, removes them from [stack].
class RouteStackDelegate<D extends Object> extends RouterDelegate<List<D>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<D>> {
  /// Creates a delegate for [stack], with [rootBuilder] as the bottom page.
  RouteStackDelegate({
    required this.stack,
    required this.rootBuilder,
    required this.builder,
    this.pageFactory = materialPageFactory,
  }) {
    stack.addListener(notifyListeners);
  }

  /// The stack of screens shown over the root page.
  final RouteStack<D> stack;

  /// Builds the root page: the screen that is always underneath.
  final WidgetBuilder rootBuilder;

  /// Builds the screen for one destination.
  final Widget Function(BuildContext context, D destination) builder;

  /// Builds the page that hosts a screen.
  final PageFactory pageFactory;

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  List<D> get currentConfiguration => stack.entries;

  @override
  Future<void> setNewRoutePath(List<D> configuration) async {
    stack.clear();
    configuration.forEach(stack.push);
  }

  @override
  Widget build(BuildContext context) => Navigator(
    key: navigatorKey,
    pages: <Page<void>>[
      pageFactory(const ValueKey<String>('root'), rootBuilder(context)),
      for (final (index, destination) in stack.entries.indexed)
        pageFactory(
          pageKeyFor(index, destination),
          builder(context, destination),
        ),
    ],
    onDidRemovePage: (_) => stack.pop(),
  );

  @override
  void dispose() {
    stack.removeListener(notifyListeners);
    super.dispose();
  }
}
