import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/utils/settings_provider.dart';

/// 設定ページのウィジェット。
class SettingsPage extends ConsumerWidget {
  /// コンストラクタ。
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: settings.when(
        data: (settings) => ListView(
          children: [
            _buildFontSizeSetting(context, ref, settings),
            _buildVerticalSetting(context, ref, settings),
            _buildDownloadPathSetting(context, ref, settings),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildVerticalSetting(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    return SwitchListTile(
      title: const Text('縦書き'),
      value: settings.isVertical,
      onChanged: (value) =>
          ref.read(settingsProvider.notifier).setIsVertical(isVertical: value),
    );
  }

  Widget _buildFontSizeSetting(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    return ListTile(
      title: Text('文字サイズ: ${settings.fontSize.toStringAsFixed(1)}'),
      subtitle: Slider(
        value: settings.fontSize,
        min: 10,
        max: 30,
        divisions: 20,
        onChanged: (value) =>
            ref.read(settingsProvider.notifier).setFontSize(value),
      ),
    );
  }

  Widget _buildDownloadPathSetting(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    return ListTile(
      title: const Text('ダウンロード先'),
      subtitle: Text(settings.novelDownloadPath),
      onTap: () async {
        final path = await FilePicker.platform.getDirectoryPath();
        if (path != null) {
          await ref.read(settingsProvider.notifier).setNovelDownloadPath(path);
        }
      },
    );
  }
}
