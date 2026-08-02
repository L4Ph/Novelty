import 'package:flutter/foundation.dart';

/// フォント設定の意味的なキー。
///
/// SharedPreferences には [storageKey] で保存され、[resolveFontFamily] の入力となる。
enum FontFamilySetting {
  /// ゴシック体。
  sans,

  /// 明朝体。
  serif;

  /// SharedPreferences に保存する文字列表現。
  String get storageKey => name;

  /// 保存された文字列からフォント設定へ変換する。
  ///
  /// 旧バージョンで保存されたバンドルフォント名 (`NotoSerifJP`) も
  /// 新しいキーへ移行する。未知の値はゴシック体として扱う。
  static FontFamilySetting fromStored(String? stored) {
    // 保存表現は storageKey で比較し、enum 改名時も一貫して扱えるようにする
    for (final setting in FontFamilySetting.values) {
      if (stored == setting.storageKey) {
        return setting;
      }
    }
    // 旧バージョンで保存されたバンドルフォント名
    if (stored == 'NotoSerifJP') {
      return FontFamilySetting.serif;
    }
    return FontFamilySetting.sans;
  }
}

/// フォント設定を解決した結果。
///
/// [family] が null の場合はプラットフォーム標準のフォントを使用する。
/// [fallbacks] は [family] が存在しない場合のフォールバック先ファミリー名。
@immutable
class FontFamilyResolution {
  /// コンストラクタ。
  const FontFamilyResolution({this.family, this.fallbacks = const []});

  /// 使用するフォントファミリー名。
  final String? family;

  /// フォールバック先のフォントファミリー名。
  final List<String> fallbacks;
}

/// フォント設定とプラットフォームから実際のファミリー名へ解決する。
///
/// バンドルフォントを廃止し、各プラットフォームに同梱されているフォントを
/// 使用する方針のため、設定値は「ゴシック」「明朝」の意味的なキーのみを持つ。
FontFamilyResolution resolveFontFamily(
  FontFamilySetting fontFamily,
  TargetPlatform platform,
) {
  switch (fontFamily) {
    case FontFamilySetting.serif:
      // 明朝体はプラットフォーム固有のファミリー名を指定する
      switch (platform) {
        case TargetPlatform.android:
          // 汎用名 `serif` がシステムの明朝体 (Noto Serif CJK JP) へ解決される
          return const FontFamilyResolution(family: 'serif');
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          return const FontFamilyResolution(family: 'Hiragino Mincho ProN');
        case TargetPlatform.windows:
          // Windows 11 以降は Noto Serif JP が同梱される
          return const FontFamilyResolution(
            family: 'Noto Serif JP',
            fallbacks: ['Yu Mincho'],
          );
        case TargetPlatform.linux:
          return const FontFamilyResolution(family: 'Noto Serif CJK JP');
        case TargetPlatform.fuchsia:
          return const FontFamilyResolution();
      }
    case FontFamilySetting.sans:
      // ゴシック体はプラットフォーム標準のゴシック体を使用する
      switch (platform) {
        case TargetPlatform.windows:
          // Windows 10/11 には Noto Sans JP が同梱される
          return const FontFamilyResolution(
            family: 'Noto Sans JP',
            fallbacks: ['Yu Gothic'],
          );
        case TargetPlatform.linux:
          return const FontFamilyResolution(family: 'Noto Sans CJK JP');
        case TargetPlatform.android:
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
        case TargetPlatform.fuchsia:
          // プラットフォーム標準のフォントに任せる
          return const FontFamilyResolution();
      }
  }
}
