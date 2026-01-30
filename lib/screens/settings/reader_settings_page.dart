import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/utils/settings_provider.dart';

/// 閲覧設定ページ
class ReaderSettingsPage extends ConsumerWidget {
  /// コンストラクタ
  const ReaderSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('閲覧設定'),
      ),
      body: settings.when(
        data: (data) => ListView(
          children: [
            _buildFontSection(context, ref, data),
            const Divider(),
            _buildLayoutSection(context, ref, data),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildFontSection(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'フォント',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          title: Text('サイズ: ${settings.fontSize.toStringAsFixed(1)}'),
          subtitle: Slider(
            value: settings.fontSize,
            min: 10,
            max: 30,
            divisions: 40,
            label: settings.fontSize.toStringAsFixed(1),
            onChanged: (value) async {
              try {
                await ref.read(settingsProvider.notifier).setFontSize(value);
              } on Exception catch (e, stackTrace) {
                debugPrint('Failed to save font size: $e\n$stackTrace');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('フォントサイズ設定の保存に失敗しました'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        ),
        ListTile(
          title: const Text('フォントファミリー'),
          subtitle: DropdownButton<String>(
            value: settings.fontFamily,
            isExpanded: true,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(
                value: 'NotoSansJP',
                child: Text('Noto Sans JP (ゴシック)'),
              ),
              DropdownMenuItem(
                value: 'NotoSerifJP',
                child: Text('Noto Serif JP (明朝)'),
              ),
            ],
            onChanged: (value) async {
              if (value != null) {
                try {
                  await ref
                      .read(settingsProvider.notifier)
                      .setFontFamily(value);
                } on Exception catch (e, stackTrace) {
                  debugPrint('Failed to save font family: $e\n$stackTrace');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('フォントファミリー設定の保存に失敗しました'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLayoutSection(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'レイアウト',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          title: Text('行間: ${settings.lineHeight.toStringAsFixed(1)}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 警告メッセージ（スライダーの上）
              // 注: 通常のUI操作では発生しないが、古いバージョンからのアップデート時や
              // 設定データの移行時など、過渡的な状態で表示される可能性がある
              if (settings.isRubyEnabled &&
                  settings.lineHeight < Settings.minLineHeightWithRuby)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'ルビが重なる可能性があります',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
              // スライダー
              Slider(
                value: settings.lineHeight,
                min: settings.isRubyEnabled
                    ? Settings.minLineHeightWithRuby
                    : Settings.minLineHeightWithoutRuby,
                max: 3,
                divisions: settings.isRubyEnabled ? 17 : 20,
                label: settings.lineHeight.toStringAsFixed(1),
                onChanged: (value) async {
                  try {
                    await ref
                        .read(settingsProvider.notifier)
                        .setLineHeight(value);
                  } on Exception catch (e, stackTrace) {
                    debugPrint('Failed to save line height: $e\n$stackTrace');
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('行間設定の保存に失敗しました'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
        SwitchListTile(
          title: const Text('縦書き'),
          value: settings.isVertical,
          onChanged: (value) async {
            try {
              await ref
                  .read(settingsProvider.notifier)
                  .setIsVertical(isVertical: value);
            } on Exception catch (e, stackTrace) {
              debugPrint('Failed to save is vertical: $e\n$stackTrace');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('縦書き設定の保存に失敗しました'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        ),
        if (settings.isVertical)
          SwitchListTile(
            title: const Text('ページ送り'),
            value: settings.isPageFlip,
            onChanged: (value) async {
              try {
                await ref
                    .read(settingsProvider.notifier)
                    .setIsPageFlip(isPageFlip: value);
              } on Exception catch (e, stackTrace) {
                debugPrint('Failed to save is page flip: $e\n$stackTrace');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ページ送り設定の保存に失敗しました'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        SwitchListTile(
          title: const Text('ルビを表示'),
          subtitle: const Text('オフにすると行間をより小さく設定できます'),
          value: settings.isRubyEnabled,
          onChanged: (value) async {
            try {
              await ref
                  .read(settingsProvider.notifier)
                  .setIsRubyEnabled(isRubyEnabled: value);
            } on Exception catch (e, stackTrace) {
              debugPrint('Failed to save is ruby enabled: $e\n$stackTrace');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ルビ表示設定の保存に失敗しました'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }
}
