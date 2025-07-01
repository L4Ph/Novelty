import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:novelty/utils/font_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        children: [
          _buildFontSetting(context),
        ],
      ),
    );
  }

  Widget _buildFontSetting(BuildContext context) {
    final fontProvider = Provider.of<FontProvider>(context);

    return ListTile(
      title: const Text('フォント'),
      subtitle: Text(fontProvider.selectedFont),
      onTap: () => _showFontSelectionDialog(context, fontProvider),
    );
  }

  void _showFontSelectionDialog(BuildContext context, FontProvider fontProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('フォントを選択'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: FontProvider.availableFonts.length,
              itemBuilder: (context, index) {
                final font = FontProvider.availableFonts[index];
                return RadioListTile<String>(
                  title: Text(font),
                  value: font,
                  groupValue: fontProvider.selectedFont,
                  onChanged: (value) {
                    if (value != null) {
                      fontProvider.setSelectedFont(value);
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
}
