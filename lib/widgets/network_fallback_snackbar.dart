import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/providers/network_fallback_event_provider.dart';
import 'package:novelty/utils/settings_provider.dart';

/// ネットワークフォールバックイベントを購読し、スナックバーで通知するラッパー。
///
/// キャッシュフォールバックが発生した際に、表示中のデータが最新でない可能性を
/// ユーザーに伝える。永続的なヘッダーは表示しない。
class NetworkFallbackSnackbar extends ConsumerWidget {
  /// コンストラクタ。
  const NetworkFallbackSnackbar({required this.child, super.key});

  /// ラップする子ウィジェット。
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(networkFallbackEventProvider, (_, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            action: SnackBarAction(
              label: 'オフラインモードをオン',
              onPressed: () {
                unawaited(
                  ref
                      .read(settingsProvider.notifier)
                      .setIsOfflineMode(isOfflineMode: true),
                );
              },
            ),
          ),
        );
        // イベントを消費して重複表示を防ぐ
        ref.read(networkFallbackEventProvider.notifier).clear();
      }
    });

    return child;
  }
}
