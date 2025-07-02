import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsProvider with ChangeNotifier {
  // Font settings
  static const List<String> availableFonts = [
    'Noto Sans JP',
    'IBM Plex Sans JP',
    'M PLUS 1p',
    'M PLUS 1',
    'Murecho',
    'M PLUS 2',
  ];
  String _selectedFont = availableFonts.first;

  // Font size settings
  double _fontSize = 16.0;

  // Color scheme settings
  ColorScheme _colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
  Color _seedColor = Colors.blue;

  // SharedPreferences keys
  static const String _fontPreferenceKey = 'selected_font';
  static const String _fontSizePreferenceKey = 'font_size';
  static const String _seedColorPreferenceKey = 'seed_color';

  SettingsProvider() {
    _loadSettings();
  }

  // Getters
  String get selectedFont => _selectedFont;
  double get fontSize => _fontSize;
  ColorScheme get colorScheme => _colorScheme;
  Color get seedColor => _seedColor;

  TextTheme get selectedFontTheme => _getTextTheme(_selectedFont);

  // Setters
  Future<void> setSelectedFont(String font) async {
    if (availableFonts.contains(font)) {
      _selectedFont = font;
      await _saveString(_fontPreferenceKey, font);
      notifyListeners();
    }
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size;
    await _saveDouble(_fontSizePreferenceKey, size);
    notifyListeners();
  }

  void updateSeedColor(Color color) {
    _colorScheme = ColorScheme.fromSeed(seedColor: color);
    notifyListeners();
  }

  Future<void> setAndSaveSeedColor(Color color) async {
    _seedColor = color;
    _colorScheme = ColorScheme.fromSeed(seedColor: color);
    await _saveInt(_seedColorPreferenceKey, color.toARGB32());
    notifyListeners();
  }

  // Load and Save methods
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedFont = prefs.getString(_fontPreferenceKey) ?? availableFonts.first;
    _fontSize = prefs.getDouble(_fontSizePreferenceKey) ?? 16.0;
    _seedColor = Color(prefs.getInt(_seedColorPreferenceKey) ?? Colors.blue.toARGB32());
    _colorScheme = ColorScheme.fromSeed(seedColor: _seedColor);
    notifyListeners();
  }

  Future<void> _saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<void> _saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  Future<void> _saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
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
