import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Scaffoldのウィジェット。
class ScaffoldPage extends StatelessWidget {
  /// コンストラクタ。
  const ScaffoldPage({required this.child, super.key});

  /// 子ウィジェット。
  /// Scaffoldのbodyとして表示されるウィジェット。
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'ライブラリ'),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: '見つける',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: '履歴'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'もっと'),
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
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/explore')) {
      return 1;
    }
    if (location.startsWith('/history')) {
      return 2;
    }
    if (location.startsWith('/more')) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/explore');
      case 2:
        context.go('/history');
      case 3:
        context.go('/more');
    }
  }
}
