import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

    if (!isOfflineMode) {
      return child;
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Material(
          color: colorScheme.errorContainer,
          child: InkWell(
            onTap: () {
              if (context.mounted) {
                context.go('/more');
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
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
