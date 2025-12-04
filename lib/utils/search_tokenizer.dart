/// 検索用のトークナイザ (Bigram)
class SearchTokenizer {
  /// テキストをトークン化する
  ///
  /// 文字列を2文字ずつ切り出してスペース区切りで返す (Bigram)
  /// 例: "異世界転生" -> "異世 世界 界転 転生"
  static String tokenize(String text) {
    if (text.isEmpty) return '';

    // 空白を除去して正規化
    final normalized = text.replaceAll(RegExp(r'\s+'), '');
    if (normalized.isEmpty) return '';

    if (normalized.length == 1) {
      return normalized;
    }

    final grams = <String>[];
    for (var i = 0; i < normalized.length - 1; i++) {
      grams.add(normalized.substring(i, i + 2));
    }

    return grams.join(' ');
  }
}
