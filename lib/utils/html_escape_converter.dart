import 'package:json_annotation/json_annotation.dart';

/// HTMLエスケープされた文字列をデコードするJsonConverter。
///
/// 以下のエンティティに対応：
/// - &quot; → "
/// - &amp; → &
/// - &lt; → <
/// - &gt; → >
/// - &nbsp; → 半角スペース
///
/// 数値参照（&#34;、&#x22;）にも対応。
/// 大文字・小文字は区別しない。
class HtmlEscapeConverter implements JsonConverter<String?, String?> {
  /// [HtmlEscapeConverter]のコンストラクタ
  const HtmlEscapeConverter();

  /// JSON文字列からHTMLエスケープされた文字列をデコードする。
  ///
  /// [json] - デコードするHTMLエスケープされた文字列（nullable）
  ///
  /// Returns: デコードされた文字列、または入力がnullの場合はnull
  @override
  String? fromJson(String? json) {
    if (json == null) return null;
    return _decodeHtmlEntities(json);
  }

  /// 文字列をJSON用のHTMLエスケープ形式にエンコードする。
  ///
  /// [object] - エンコードする文字列（nullable）
  ///
  /// Returns: HTMLエスケープされた文字列、または入力がnullの場合はnull
  @override
  String? toJson(String? object) {
    return object;
  }

  /// HTMLエンティティをデコードする。
  static String _decodeHtmlEntities(String text) {
    if (!text.contains('&')) return text;

    return text
        // 名前付きエンティティ（大文字小文字不問）
        .replaceAllMapped(
          RegExp('&quot;', caseSensitive: false),
          (_) => '"',
        )
        .replaceAllMapped(
          RegExp('&amp;', caseSensitive: false),
          (_) => '&',
        )
        .replaceAllMapped(
          RegExp('&lt;', caseSensitive: false),
          (_) => '<',
        )
        .replaceAllMapped(
          RegExp('&gt;', caseSensitive: false),
          (_) => '>',
        )
        .replaceAllMapped(
          RegExp('&nbsp;', caseSensitive: false),
          (_) => ' ',
        )
        // 十進数値参照 &#34; → "
        .replaceAllMapped(
          RegExp('&#(\\d+);'),
          (match) {
            final code = int.tryParse(match.group(1)!);
            if (code != null && code >= 0 && code <= 0x10FFFF) {
              return String.fromCharCode(code);
            }
            return match.group(0)!;
          },
        )
        // 十六進数値参照 &#x22; → "
        .replaceAllMapped(
          RegExp('&#[xX]([0-9a-fA-F]+);'),
          (match) {
            final code = int.tryParse(match.group(1)!, radix: 16);
            if (code != null && code >= 0 && code <= 0x10FFFF) {
              return String.fromCharCode(code);
            }
            return match.group(0)!;
          },
        );
  }
}