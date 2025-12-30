import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/utils/settings_provider.dart';

/// 表示設定ページ
class AppearanceSettingsPage extends ConsumerWidget {
  /// コンストラクタ
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('表示設定'),
      ),
      body: settings.when(
        data: (data) => ListView(
          children: [
            _buildThemeSection(context, ref, data),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildThemeSection(
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
            'テーマ',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        RadioGroup<ThemeMode>(
          groupValue: settings.themeMode,
          onChanged: (value) async {
            if (value != null) {
              await ref.read(settingsProvider.notifier).setThemeMode(value);
            }
          },
          child: const Column(
            children: [
              RadioListTile<ThemeMode>(
                title: Text('システム設定に従う'),
                value: ThemeMode.system,
              ),
              RadioListTile<ThemeMode>(
                title: Text('ライト'),
                value: ThemeMode.light,
              ),
              RadioListTile<ThemeMode>(
                title: Text('ダーク'),
                value: ThemeMode.dark,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
