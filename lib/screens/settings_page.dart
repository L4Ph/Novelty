import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        children: [
          _buildFontSetting(context, settings),
          _buildFontSizeSetting(context, settings),
          _buildThemeColorSetting(context, settings),
        ],
      ),
    );
  }

  Widget _buildFontSetting(BuildContext context, SettingsProvider settings) {
    return ListTile(
      title: const Text('フォント'),
      subtitle: Text(settings.selectedFont),
      onTap: () => _showFontSelectionDialog(context, settings),
    );
  }

  Widget _buildFontSizeSetting(
    BuildContext context,
    SettingsProvider settings,
  ) {
    return ListTile(
      title: Text('文字サイズ: ${settings.fontSize.toStringAsFixed(1)}'),
      subtitle: Slider(
        value: settings.fontSize,
        min: 10,
        max: 30,
        divisions: 20,
        onChanged: (value) => settings.setFontSize(value),
      ),
    );
  }

  Widget _buildThemeColorSetting(
    BuildContext context,
    SettingsProvider settings,
  ) {
    return ListTile(
      title: const Text('テーマカラー'),
      trailing: CircleAvatar(
        backgroundColor: settings.colorScheme.primary,
        radius: 15,
      ),
      onTap: () => _showColorPickerDialog(context, settings),
    );
  }

  void _showFontSelectionDialog(
    BuildContext context,
    SettingsProvider settings,
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
              itemCount: SettingsProvider.availableFonts.length,
              itemBuilder: (context, index) {
                final font = SettingsProvider.availableFonts[index];
                return RadioListTile<String>(
                  title: Text(font),
                  value: font,
                  groupValue: settings.selectedFont,
                  onChanged: (value) {
                    if (value != null) {
                      settings.setSelectedFont(value);
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

  void _showColorPickerDialog(BuildContext context, SettingsProvider settings) {
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
                settings.updateSeedColor(color);
                pickerColor = color;
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                settings.updateSeedColor(settings.seedColor);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('完了'),
              onPressed: () {
                settings.setAndSaveSeedColor(pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
