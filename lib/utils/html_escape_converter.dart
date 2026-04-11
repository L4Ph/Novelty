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

  static final _entityRegex = RegExp(
    r'&(?:(quot|amp|lt|gt|nbsp)|#(\d+)|#x([0-9a-fA-F]+));',
    caseSensitive: false,
  );

  static const _namedEntities = {
    'quot': '"',
    'amp': '&',
    'lt': '<',
    'gt': '>',
    'nbsp': ' ',
  };

  static String _decodeHtmlEntities(String text) {
    if (!text.contains('&')) return text;

    return text.replaceAllMapped(_entityRegex, (match) {
      final named = match.group(1);
      if (named != null) {
        return _namedEntities[named.toLowerCase()] ?? match.group(0)!;
      }

      final decimal = match.group(2);
      if (decimal != null) {
        final code = int.tryParse(decimal);
        if (code != null && code >= 0 && code <= 0x10FFFF) {
          return String.fromCharCode(code);
        }
      }

      final hex = match.group(3);
      if (hex != null) {
        final code = int.tryParse(hex, radix: 16);
        if (code != null && code >= 0 && code <= 0x10FFFF) {
          return String.fromCharCode(code);
        }
      }

      return match.group(0)!;
    });
  }
}
