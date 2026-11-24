import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tiny_router/tiny_router.dart';

/// A `Navigator` whose pages come from [stack].
///
/// Use one per nested stack (a tab, for example). Three things a hand-written
/// `Navigator.pages` keeps getting wrong are handled here: every page gets a
/// stable key, so a screen keeps its state across pushes; the entry is dropped
/// when its page is popped, so the stack and `Navigator` stay in sync; and the
/// system back is forwarded into this navigator through a
/// `NavigatorPopHandler`.
class RouteStackNavigator<D extends Object> extends StatefulWidget {
  /// Creates a navigator for [stack].
  ///
  /// [handlesSystemPop] must be false for stacks that are in the widget tree
  /// but not on screen (the inactive tabs of an `IndexedStack`), otherwise the
  /// hidden stack would consume the back gesture.
  const RouteStackNavigator({
    required this.stack,
    required this.builder,
    this.pageFactory = materialPageFactory,
    this.handlesSystemPop = true,
    super.key,
  });

  /// The stack to render, bottom to top.
  final RouteStack<D> stack;

  /// Builds the screen for one destination.
  final Widget Function(BuildContext context, D destination) builder;

  /// Builds the page that hosts the screen.
  final PageFactory pageFactory;

  /// Whether the system back should pop this navigator.
  final bool handlesSystemPop;

  @override
  State<RouteStackNavigator<D>> createState() => _RouteStackNavigatorState<D>();
}

class _RouteStackNavigatorState<D extends Object>
    extends State<RouteStackNavigator<D>> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    widget.stack.addListener(_onStackChanged);
  }

  @override
  void didUpdateWidget(RouteStackNavigator<D> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stack != widget.stack) {
      oldWidget.stack.removeListener(_onStackChanged);
      widget.stack.addListener(_onStackChanged);
    }
  }

  @override
  void dispose() {
    widget.stack.removeListener(_onStackChanged);
    super.dispose();
  }

  void _onStackChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator(
      key: _navigatorKey,
      pages: <Page<void>>[
        for (final (index, destination) in widget.stack.entries.indexed)
          widget.pageFactory(
            pageKeyFor(index, destination),
            widget.builder(context, destination),
          ),
      ],
      // Fires for imperative removals only, but also when a page is replaced,
      // where the entry is already gone; popping then would take the wrong one.
      onDidRemovePage: (page) {
        if (_isTopPage(page)) {
          widget.stack.pop();
        }
      },
    );

    return NavigatorPopHandler<void>(
      enabled: widget.handlesSystemPop,
      // A refused pop is announced to every handler of the route, the
      // disabled ones included, so a hidden tab would pop itself as well.
      //
      // Let the navigator decide rather than popping the stack here: a screen
      // can refuse with its own PopScope (the explore tab resets its search
      // that way), and only maybePop() asks it. When it agrees, the route goes
      // and onDidRemovePage takes the entry off the stack.
      onPopWithResult: (_) {
        if (widget.handlesSystemPop) {
          unawaited(_navigatorKey.currentState?.maybePop());
        }
      },
      child: navigator,
    );
  }

  bool _isTopPage(Page<Object?> page) {
    final top = widget.stack.top;
    if (top == null) {
      return false;
    }
    return page.key == pageKeyFor(widget.stack.length - 1, top);
  }
}
