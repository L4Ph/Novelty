import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

@immutable
class AppSettings {
  const AppSettings({
    required this.selectedFont,
    required this.fontSize,
    required this.seedColor,
  });

  final String selectedFont;
  final double fontSize;
  final Color seedColor;

  ColorScheme get colorScheme => ColorScheme.fromSeed(seedColor: seedColor);

  TextStyle get selectedFontTheme => _getTextStyle(selectedFont);

  AppSettings copyWith({
    String? selectedFont,
    double? fontSize,
    Color? seedColor,
  }) {
    return AppSettings(
      selectedFont: selectedFont ?? this.selectedFont,
      fontSize: fontSize ?? this.fontSize,
      seedColor: seedColor ?? this.seedColor,
    );
  }

  TextStyle _getTextStyle(String font) {
    switch (font) {
      case 'IBM Plex Sans JP':
        return GoogleFonts.ibmPlexSansJp();
      case 'M PLUS 1p':
        return GoogleFonts.mPlus1p();
      case 'M PLUS 1':
        return GoogleFonts.mPlus1();
      case 'Murecho':
        return GoogleFonts.murecho();
      case 'M PLUS 2':
        return GoogleFonts.mPlus2();
      case 'Noto Sans JP':
      default:
        return GoogleFonts.notoSansJp();
    }
  }
}

@Riverpod(keepAlive: true)
class Settings extends _$Settings {
  static const availableFonts = <String>[
    'Noto Sans JP',
    'IBM Plex Sans JP',
    'M PLUS 1p',
    'M PLUS 1',
    'Murecho',
    'M PLUS 2',
  ];

  static const _fontPreferenceKey = 'selected_font';
  static const _fontSizePreferenceKey = 'font_size';
  static const _seedColorPreferenceKey = 'seed_color';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<AppSettings> build() async {
    final prefs = await _prefs;
    final selectedFont =
        prefs.getString(_fontPreferenceKey) ?? availableFonts.first;
    final fontSize = prefs.getDouble(_fontSizePreferenceKey) ?? 16.0;
    final seedColor = Color(
      prefs.getInt(_seedColorPreferenceKey) ?? Colors.blue.value,
    );

    return AppSettings(
      selectedFont: selectedFont,
      fontSize: fontSize,
      seedColor: seedColor,
    );
  }

  Future<void> setSelectedFont(String font) async {
    if (availableFonts.contains(font) && state.hasValue) {
      await (await _prefs).setString(_fontPreferenceKey, font);
      state = AsyncData(state.value!.copyWith(selectedFont: font));
    }
  }

  Future<void> setFontSize(double size) async {
    if (state.hasValue) {
      await (await _prefs).setDouble(_fontSizePreferenceKey, size);
      state = AsyncData(state.value!.copyWith(fontSize: size));
    }
  }

  Future<void> setAndSaveSeedColor(Color color) async {
    if (state.hasValue) {
      await (await _prefs).setInt(_seedColorPreferenceKey, color.value);
      state = AsyncData(state.value!.copyWith(seedColor: color));
    }
  }
}
