/// 禁則処理のためのユーティリティクラス
class Kinsoku {
  Kinsoku._();

  /// 行頭禁則文字かどうかを判定する
  ///
  /// 列の先頭に来てはいけない文字
  static bool isHeadProhibited(String char) {
    return _headProhibited.contains(char);
  }

  /// 行末禁則文字かどうかを判定する
  ///
  /// 列の末尾に来てはいけない文字
  static bool isTailProhibited(String char) {
    return _tailProhibited.contains(char);
  }

  /// 行頭禁則文字
  static const _headProhibited = <String>{
    // 句読点
    '。',
    '、',
    '．',
    '，',
    '：',
    '；',
    // 疑問符・感嘆符
    '？',
    '！',
    '?',
    '!',
    // 閉じ括弧
    '）',
    '］',
    '｝',
    '」',
    '』',
    '】',
    '〉',
    '》',
    ')',
    ']',
    '}',
    // 長音・波線
    'ー',
    '～',
    '〜',
    // 三点リーダ
    '…',
    '‥',
  };

  /// 行末禁則文字
  static const _tailProhibited = <String>{
    // 開き括弧
    '（',
    '［',
    '｛',
    '「',
    '『',
    '【',
    '〈',
    '《',
    '(',
    '[',
    '{',
  };
}
