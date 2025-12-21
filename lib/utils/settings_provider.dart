import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

@immutable
/// アプリケーションの設定を管理するクラス。
/// フォントサイズ、縦書き設定、ダウンロードパスの設定を含む。
class AppSettings {
  /// コンストラクタ。
  const AppSettings({
    required this.fontSize,
    required this.isVertical,
    required this.novelDownloadPath,
  });

  /// フォントサイズ。
  final double fontSize;

  /// 縦書き設定。
  final bool isVertical;

  /// 小説のダウンロードパス。
  final String novelDownloadPath;

  /// 設定をコピーするメソッド。
  AppSettings copyWith({
    double? fontSize,
    bool? isVertical,
    String? novelDownloadPath,
  }) {
    return AppSettings(
      fontSize: fontSize ?? this.fontSize,
      isVertical: isVertical ?? this.isVertical,
      novelDownloadPath: novelDownloadPath ?? this.novelDownloadPath,
    );
  }
}

@Riverpod(keepAlive: true, dependencies: [])
/// アプリケーションの設定を提供するプロバイダー。
class Settings extends _$Settings {
  static const _fontSizePreferenceKey = 'font_size';
  static const _isVerticalPreferenceKey = 'is_vertical';
  static const _novelDownloadPathPreferenceKey = 'novel_download_path';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<AppSettings> build() async {
    final prefs = await _prefs;
    final fontSize = prefs.getDouble(_fontSizePreferenceKey) ?? 16.0;
    final isVertical = prefs.getBool(_isVerticalPreferenceKey) ?? false;
    final novelDownloadPath =
        prefs.getString(_novelDownloadPathPreferenceKey) ??
        (await getApplicationDocumentsDirectory()).path;

    return AppSettings(
      fontSize: fontSize,
      isVertical: isVertical,
      novelDownloadPath: novelDownloadPath,
    );
  }

  /// フォントサイズを設定するメソッド。
  Future<void> setFontSize(double size) async {
    if (state.hasValue) {
      await (await _prefs).setDouble(_fontSizePreferenceKey, size);
      state = AsyncData(state.value!.copyWith(fontSize: size));
    }
  }

  /// 縦書き設定を更新するメソッド。
  Future<void> setIsVertical({required bool isVertical}) async {
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
