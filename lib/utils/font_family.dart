/// バンドルフォントのファミリー名(ゴシック体)。
const bundledSansFontFamily = 'NotoSansJP';

/// バンドルフォントのファミリー名(明朝体)。
const bundledSerifFontFamily = 'NotoSerifJP';

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

/// フォント設定からバンドルフォントのファミリー名へ解決する。
///
/// 全プラットフォームで同梱の Noto フォントを使用する。
/// システムフォントに委ねると OS のロケール解決によって
/// 中国語字形の CJK フォントが選ばれる場合があるため、
/// 日本語字形のみを持つフォントをバンドルして固定する。
String resolveFontFamily(FontFamilySetting fontFamily) {
  switch (fontFamily) {
    case FontFamilySetting.sans:
      return bundledSansFontFamily;
    case FontFamilySetting.serif:
      return bundledSerifFontFamily;
  }
}
