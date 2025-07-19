import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// "もっと"ページのウィジェット。
class MorePage extends StatelessWidget {
  /// コンストラクタ。
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('もっと')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('設定'),
            onTap: () {
              context.go('/more/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('データとストレージ'),
            onTap: () {
              context.go('/more/data-storage');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('このアプリについて'),
            onTap: () {
              context.go('/more/about');
            },
          ),
        ],
      ),
    );
  }
}
