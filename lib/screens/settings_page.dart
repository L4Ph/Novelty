import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/utils/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: settings.when(
        data: (settings) => ListView(
          children: [
            _buildFontSetting(context, ref, settings),
            _buildFontSizeSetting(context, ref, settings),
            _buildThemeColorSetting(context, ref, settings),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildFontSetting(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    return ListTile(
      title: const Text('フォント'),
      subtitle: Text(settings.selectedFont),
      onTap: () => _showFontSelectionDialog(context, ref, settings),
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

  Widget _buildThemeColorSetting(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    return ListTile(
      title: const Text('テーマカラー'),
      trailing: CircleAvatar(
        backgroundColor: settings.colorScheme.primary,
        radius: 15,
      ),
      onTap: () => _showColorPickerDialog(context, ref, settings),
    );
  }

  void _showFontSelectionDialog(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('フォントを選択'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Settings.availableFonts.length,
              itemBuilder: (context, index) {
                final font = Settings.availableFonts[index];
                return RadioListTile<String>(
                  title: Text(font),
                  value: font,
                  groupValue: settings.selectedFont,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(settingsProvider.notifier)
                          .setSelectedFont(value);
                      Navigator.of(context).pop();
                    }
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showColorPickerDialog(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    var pickerColor = settings.seedColor;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('テーマカラーを選択'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) {
                pickerColor = color;
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('完了'),
              onPressed: () {
                ref
                    .read(settingsProvider.notifier)
                    .setAndSaveSeedColor(pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
