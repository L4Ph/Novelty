import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/providers/network_fallback_event_provider.dart';
import 'package:novelty/router/router.dart';
import 'package:novelty/utils/settings_provider.dart';

/// オフラインモードON時に全画面の上部に表示する帯。
class OfflineModeBanner extends ConsumerWidget {
  /// コンストラクタ。
  const OfflineModeBanner({required this.child, super.key});

  /// 帯の下に表示する子ウィジェット。
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOfflineMode = ref.watch(isOfflineModeProvider);

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

    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // オフラインモード時のみバナーを表示（常にColumnで囲んで構造を安定化）
        if (isOfflineMode)
          Material(
            color: colorScheme.errorContainer,
            child: InkWell(
              onTap: () {
                if (context.mounted) {
                  const MoreRoute().go(context);
                }
              },
              child: SizedBox(
                height: 28,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.cloud_off,
                        size: 16,
                        color: colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'オフラインモード',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: colorScheme.onErrorContainer,
                                fontWeight: FontWeight.w600,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.settings,
                        size: 16,
                        color: colorScheme.onErrorContainer,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        Expanded(child: child),
      ],
    );
  }
}
