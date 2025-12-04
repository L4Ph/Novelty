import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/providers/connectivity_provider.dart';

/// Scaffoldのウィジェット。
class ScaffoldPage extends ConsumerWidget {
  /// コンストラクタ。
  const ScaffoldPage({required this.child, super.key});

  /// 子ウィジェット。
  /// Scaffoldのbodyとして表示されるウィジェット。
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline = ref.watch(isOfflineProvider);

    // オフラインになった時に、現在「見つける」タブにいたらライブラリに遷移させる
    ref.listen(isOfflineProvider, (previous, next) {
      if (next) {
        final location = GoRouterState.of(context).uri.toString();
        if (location.startsWith('/explore')) {
          context.go('/');
        }
      }
    });

    final items = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.book), label: 'ライブラリ'),
      if (!isOffline)
        const BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: '見つける',
        ),
      const BottomNavigationBarItem(icon: Icon(Icons.history), label: '履歴'),
      const BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'もっと'),
    ];

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: _calculateSelectedIndex(context, isOffline),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (int idx) => _onItemTapped(idx, context, isOffline),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context, bool isOffline) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/explore')) {
      return isOffline ? 0 : 1;
    }
    if (location.startsWith('/history')) {
      return isOffline ? 1 : 2;
    }
    if (location.startsWith('/more')) {
      return isOffline ? 2 : 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context, bool isOffline) {
    if (isOffline) {
      switch (index) {
        case 0:
          context.go('/');
        case 1:
          context.go('/history');
        case 2:
          context.go('/more');
      }
    } else {
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
}
