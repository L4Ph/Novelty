import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldPage extends StatelessWidget {
  const ScaffoldPage({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'ライブラリ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'ランキング',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '履歴',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '検索',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'もっと',
          ),
        ],
        currentIndex: _calculateSelectedIndex(context),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (int idx) => _onItemTapped(idx, context),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/ranking')) {
      return 1;
    }
    if (location.startsWith('/history')) {
      return 2;
    }
    if (location.startsWith('/search')) {
      return 3;
    }
    if (location.startsWith('/more')) {
      return 4;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/ranking');
        break;
      case 2:
        context.go('/history');
        break;
      case 3:
        context.go('/search');
        break;
      case 4:
        context.go('/more');
        break;
    }
  }
}