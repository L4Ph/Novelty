import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

@immutable
/// アプリケーションの設定を管理するクラス。
class AppSettings {
  /// コンストラクタ。
  const AppSettings({
    required this.themeMode,
    required this.fontSize,
    required this.lineHeight,
    required this.fontFamily,
    required this.isVertical,
    required this.isIncognito,
    required this.isPageFlip,
    required this.isRubyEnabled,
  });

  /// テーマモード (system, light, dark)。
  final ThemeMode themeMode;

  /// フォントサイズ。
  final double fontSize;

  /// 行間。
  final double lineHeight;

  /// フォントファミリー。
  final String fontFamily;

  /// 縦書き設定。
  final bool isVertical;

  /// シークレットモード (履歴を残さない)。
  final bool isIncognito;

  /// ページ送り設定 (true: ページ送り, false: スクロール)。
  final bool isPageFlip;

  /// ルビ（ふりがな）の表示設定。
  ///
  /// `true` の場合、ルビが表示されます（デフォルト）。
  /// `false` の場合、ルビは非表示になりベーステキストのみが表示されます。
  /// これにより、行間をより小さく設定することができます。
  final bool isRubyEnabled;

  /// 設定をコピーするメソッド。
  AppSettings copyWith({
    ThemeMode? themeMode,
    double? fontSize,
    double? lineHeight,
    String? fontFamily,
    bool? isVertical,
    bool? isIncognito,
    bool? isPageFlip,
    bool? isRubyEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      fontFamily: fontFamily ?? this.fontFamily,
      isVertical: isVertical ?? this.isVertical,
      isIncognito: isIncognito ?? this.isIncognito,
      isPageFlip: isPageFlip ?? this.isPageFlip,
      isRubyEnabled: isRubyEnabled ?? this.isRubyEnabled,
    );
  }
}

@Riverpod(keepAlive: true)
/// アプリケーションの設定を提供するプロバイダー。
class Settings extends _$Settings {
  static const _themeModeKey = 'theme_mode';
  static const _fontSizeKey = 'font_size';
  static const _lineHeightKey = 'line_height';
  static const _fontFamilyKey = 'font_family';
  static const _isVerticalKey = 'is_vertical';
  static const _isIncognitoKey = 'is_incognito';
  static const _isPageFlipKey = 'is_page_flip';
  static const _isRubyEnabledKey = 'is_ruby_enabled';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<AppSettings> build() async {
    final prefs = await _prefs;
    final themeModeIndex =
        prefs.getInt(_themeModeKey) ?? ThemeMode.system.index;
    final fontSize = prefs.getDouble(_fontSizeKey) ?? 16.0;
    final lineHeight = prefs.getDouble(_lineHeightKey) ?? 1.5;
    final fontFamily = prefs.getString(_fontFamilyKey) ?? 'NotoSansJP';
    final isVertical = prefs.getBool(_isVerticalKey) ?? false;
    final isIncognito = prefs.getBool(_isIncognitoKey) ?? false;
    final isPageFlip = prefs.getBool(_isPageFlipKey) ?? false;
    final isRubyEnabled = prefs.getBool(_isRubyEnabledKey) ?? true;

    return AppSettings(
      themeMode: ThemeMode.values[themeModeIndex],
      fontSize: fontSize,
      lineHeight: lineHeight,
      fontFamily: fontFamily,
      isVertical: isVertical,
      isIncognito: isIncognito,
      isPageFlip: isPageFlip,
      isRubyEnabled: isRubyEnabled,
    );
  }

  /// テーマモードを設定するメソッド。
  Future<void> setThemeMode(ThemeMode mode) async {
    if (state.hasValue) {
      await (await _prefs).setInt(_themeModeKey, mode.index);
      state = AsyncData(state.value!.copyWith(themeMode: mode));
    }
  }

  /// フォントサイズを設定するメソッド。
  Future<void> setFontSize(double size) async {
    if (state.hasValue) {
      await (await _prefs).setDouble(_fontSizeKey, size);
      state = AsyncData(state.value!.copyWith(fontSize: size));
    }
  }

  /// 行間を設定するメソッド。
  Future<void> setLineHeight(double height) async {
    if (state.hasValue) {
      await (await _prefs).setDouble(_lineHeightKey, height);
      state = AsyncData(state.value!.copyWith(lineHeight: height));
    }
  }

  /// フォントファミリーを設定するメソッド。
  Future<void> setFontFamily(String family) async {
    if (state.hasValue) {
      await (await _prefs).setString(_fontFamilyKey, family);
      state = AsyncData(state.value!.copyWith(fontFamily: family));
    }
  }

  /// 縦書き設定を更新するメソッド。
  Future<void> setIsVertical({required bool isVertical}) async {
    if (state.hasValue) {
      await (await _prefs).setBool(_isVerticalKey, isVertical);
      state = AsyncData(state.value!.copyWith(isVertical: isVertical));
    }
  }

  /// シークレットモードを設定するメソッド。
  Future<void> setIsIncognito({required bool isIncognito}) async {
    if (state.hasValue) {
      await (await _prefs).setBool(_isIncognitoKey, isIncognito);
      state = AsyncData(state.value!.copyWith(isIncognito: isIncognito));
    }
  }

  /// ページ送り設定を更新するメソッド。
  Future<void> setIsPageFlip({required bool isPageFlip}) async {
    if (state.hasValue) {
      await (await _prefs).setBool(_isPageFlipKey, isPageFlip);
      state = AsyncData(state.value!.copyWith(isPageFlip: isPageFlip));
    }
  }

  /// ルビ表示設定を更新するメソッド。
  Future<void> setIsRubyEnabled({required bool isRubyEnabled}) async {
    if (state.hasValue) {
      await (await _prefs).setBool(_isRubyEnabledKey, isRubyEnabled);
      state = AsyncData(state.value!.copyWith(isRubyEnabled: isRubyEnabled));
    }
  }
}
