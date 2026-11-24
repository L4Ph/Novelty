import 'package:flutter/material.dart';
import 'package:novelty/router/app_router.dart';
import 'package:novelty/router/destinations.dart';
import 'package:novelty/router/screens.dart';
import 'package:tiny_router_flutter/tiny_router_flutter.dart';

/// The app shell: the tab bar and one navigator per tab.
///
/// It is the bottom page of the root navigator, so screens pushed with
/// [AppRouter.pushOverlay] cover it — tab bar included.
class ScaffoldPage extends StatelessWidget {
  /// Const constructor.
  const ScaffoldPage({super.key});

  static const _items = <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.book), label: 'ライブラリ'),
    BottomNavigationBarItem(icon: Icon(Icons.explore), label: '見つける'),
    BottomNavigationBarItem(icon: Icon(Icons.history), label: '履歴'),
    BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'もっと'),
  ];

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: appRouter,
    builder: (context, _) {
      final selected = appRouter.selected;
      return Scaffold(
        body: IndexedStack(
          index: selected.index,
          children: <Widget>[
            for (final tab in AppTab.values)
              RouteStackNavigator<NovelDestination>(
                stack: appRouter.stackOf(tab),
                // Only the visible tab may take the system back.
                handlesSystemPop: tab == selected,
                builder: (context, destination) => screenFor(destination),
              ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _items,
          currentIndex: selected.index,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          onTap: (index) => appRouter.select(AppTab.values[index]),
          type: BottomNavigationBarType.fixed,
        ),
      );
    },
  );
}
