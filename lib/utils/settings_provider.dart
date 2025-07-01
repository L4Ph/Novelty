import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class FontProvider with ChangeNotifier {
  static const List<String> availableFonts = [
    'Noto Sans JP',
    'IBM Plex Sans JP',
    'M PLUS 1p',
    'M PLUS 1',
    'Murecho',
    'M PLUS 2',
  ];

  static const String _fontPreferenceKey = 'selected_font';
  String _selectedFont = availableFonts.first;

  FontProvider() {
    _loadFont();
  }

  String get selectedFont => _selectedFont;

  TextTheme get selectedFontTheme => _getTextTheme(_selectedFont);

  Future<void> setSelectedFont(String font) async {
    if (availableFonts.contains(font)) {
      _selectedFont = font;
      await _saveFont(font);
      notifyListeners();
    }
  }

  Future<void> _loadFont() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedFont = prefs.getString(_fontPreferenceKey) ?? availableFonts.first;
    notifyListeners();
  }

  Future<void> _saveFont(String font) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontPreferenceKey, font);
  }

  TextTheme _getTextTheme(String font) {
    switch (font) {
      case 'IBM Plex Sans JP':
        return GoogleFonts.ibmPlexSansJpTextTheme();
      case 'M PLUS 1p':
        return GoogleFonts.mPlus1pTextTheme();
      case 'M PLUS 1':
        return GoogleFonts.mPlus1TextTheme();
      case 'Murecho':
        return GoogleFonts.murechoTextTheme();
      case 'M PLUS 2':
        return GoogleFonts.mPlus2TextTheme();
      case 'Noto Sans JP':
      default:
        return GoogleFonts.notoSansJpTextTheme();
    }
  }
}
