import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

@immutable
/// アプリケーションの設定を管理するクラス。
/// フォント、フォントサイズ、縦書き設定、ダウンロードパスの設定を含む。
class AppSettings {
  /// コンストラクタ。
  const AppSettings({
    required this.selectedFont,
    required this.fontSize,
    required this.isVertical,
    required this.novelDownloadPath,
  });

  /// 選択されたフォント名。
  final String selectedFont;

  /// フォントサイズ。
  final double fontSize;

  /// 縦書き設定。
  final bool isVertical;

  /// 小説のダウンロードパス。
  final String novelDownloadPath;

  /// 選択されたフォントに基づいてテキストスタイルを取得するメソッド。
  TextStyle get selectedFontTheme => _getTextStyle(selectedFont);

  /// フォントサイズに基づいてテキストスタイルを取得するメソッド。
  AppSettings copyWith({
    String? selectedFont,
    double? fontSize,
    bool? isVertical,
    String? novelDownloadPath,
  }) {
    return AppSettings(
      selectedFont: selectedFont ?? this.selectedFont,
      fontSize: fontSize ?? this.fontSize,
      isVertical: isVertical ?? this.isVertical,
      novelDownloadPath: novelDownloadPath ?? this.novelDownloadPath,
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
/// アプリケーションの設定を提供するプロバイダー。
class Settings extends _$Settings {
  /// 利用可能なフォントのリスト。
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
  static const _isVerticalPreferenceKey = 'is_vertical';
  static const _novelDownloadPathPreferenceKey = 'novel_download_path';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<AppSettings> build() async {
    final prefs = await _prefs;
    final selectedFont =
        prefs.getString(_fontPreferenceKey) ?? availableFonts.first;
    final fontSize = prefs.getDouble(_fontSizePreferenceKey) ?? 16.0;
    final isVertical = prefs.getBool(_isVerticalPreferenceKey) ?? false;
    final novelDownloadPath =
        prefs.getString(_novelDownloadPathPreferenceKey) ??
        (await getApplicationDocumentsDirectory()).path;

    return AppSettings(
      selectedFont: selectedFont,
      fontSize: fontSize,
      isVertical: isVertical,
      novelDownloadPath: novelDownloadPath,
    );
  }

  /// フォントを設定するメソッド。
  Future<void> setSelectedFont(String font) async {
    if (availableFonts.contains(font) && state.hasValue) {
      await (await _prefs).setString(_fontPreferenceKey, font);
      state = AsyncData(state.value!.copyWith(selectedFont: font));
    }
  }

  /// フォントサイズを設定するメソッド。
  Future<void> setFontSize(double size) async {
    if (state.hasValue) {
      await (await _prefs).setDouble(_fontSizePreferenceKey, size);
      state = AsyncData(state.value!.copyWith(fontSize: size));
    }
  }

  /// 縦書き設定を更新するメソッド。
  Future<void> setIsVertical(bool isVertical) async {
    if (state.hasValue) {
      await (await _prefs).setBool(_isVerticalPreferenceKey, isVertical);
      state = AsyncData(state.value!.copyWith(isVertical: isVertical));
    }
  }

  /// 小説のダウンロードパスを設定するメソッド。
  Future<void> setNovelDownloadPath(String path) async {
    if (state.hasValue) {
      await (await _prefs).setString(_novelDownloadPathPreferenceKey, path);
      state = AsyncData(state.value!.copyWith(novelDownloadPath: path));
    }
  }
}
