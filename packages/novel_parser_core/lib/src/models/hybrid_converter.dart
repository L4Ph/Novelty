import 'dart:convert';

import 'package:novel_parser_core/src/models/novel_content_element.dart';

/// Hybrid JSON コンバータ
///
/// `List<NovelContentElement>` を `{"txt": "...", "rb": [{"off":..., "base":"...","ruby":"..."}]}` 形式で
/// 効率的に永続化する。`txt` は `PlainText` + `RubyText.base` + `"\n"` を連結した読み上げテキスト、
/// `rb` は `RubyText` の注釈をオフセットで保持する。`newLine` は `txt` 内の `"\n"` として表現する。
class HybridConverter {
  /// リストを Hybrid JSON 文字列に変換する
  static String toHybridJson(List<NovelContentElement> elements) {
    final buffer = StringBuffer();
    final rb = <Map<String, dynamic>>[];
    var off = 0;

    for (final e in elements) {
      e.when(
        plainText: (text) {
          buffer.write(text);
          off += text.length;
        },
        rubyText: (base, ruby) {
          rb.add({'off': off, 'base': base, 'ruby': ruby});
          buffer.write(base);
          off += base.length;
        },
        newLine: () {
          buffer.write('\n');
          off += 1;
        },
      );
    }

    return json.encode({'txt': buffer.toString(), 'rb': rb});
  }

  /// Hybrid JSON 文字列からリストを復元する
  ///
  /// Hybrid形式 `{"txt":..., "rb":[...]}` と旧verbose形式 `[{...},...]` の両方を読む。
  /// `off`/`base` の不整合は `FormatException` を投げる。
  static List<NovelContentElement> fromHybridJson(String jsonStr) {
    if (jsonStr.isEmpty) return [];
    final decoded = json.decode(jsonStr);

    // 旧形式: ルートが List
    if (decoded is List) {
      return decoded
          .map((e) => NovelContentElement.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (decoded is! Map<String, dynamic>) {
      throw FormatException(
        'Hybrid JSON は Map または List である必要があります: $jsonStr',
      );
    }

    // 新形式の検証
    if (!decoded.containsKey('txt') || !decoded.containsKey('rb')) {
      // 旧形式の単一オブジェクト fallback（念のため）
      throw FormatException(
        'Hybrid JSON に txt/rb が見つかりません: $jsonStr',
      );
    }

    final txt = decoded['txt'] as String;
    final rbList = decoded['rb'] as List;

    // rb を off でソート
    final spans = rbList.map((e) {
      final m = e as Map<String, dynamic>;
      return _RubySpan(
        off: m['off'] as int,
        base: m['base'] as String,
        ruby: m['ruby'] as String,
      );
    }).toList()
      ..sort((a, b) => a.off.compareTo(b.off));

    // 検証: txt と base の一致、およびスパン同士の重なり
    var prevEnd = -1;
    for (final span in spans) {
      if (span.off < 0 || span.off + span.base.length > txt.length) {
        throw FormatException(
          'Ruby span の off/length が txt 範囲外です: '
          'off=${span.off}, base=${span.base}, txt.length=${txt.length}',
        );
      }
      // 重なり検出: 直前スパンの終端より前から始まる場合
      if (span.off < prevEnd) {
        throw FormatException(
          'Ruby span が重なっています: '
          'off=${span.off}, base=${span.base} (直前スパンの終端=$prevEnd)',
        );
      }
      prevEnd = span.off + span.base.length;
      final actual = txt.substring(span.off, span.off + span.base.length);
      if (actual != span.base) {
        throw FormatException(
          'Ruby span の base が txt と一致しません: '
          'off=${span.off}, expected=${span.base}, actual=$actual',
        );
      }
    }

    // 再構築
    final result = <NovelContentElement>[];
    final plainBuffer = StringBuffer();
    var txtIndex = 0;
    var rbIndex = 0;

    void flushPlain() {
      if (plainBuffer.isNotEmpty) {
        result.add(NovelContentElement.plainText(plainBuffer.toString()));
        plainBuffer.clear();
      }
    }

    while (txtIndex < txt.length) {
      // ruby の開始位置か？
      if (rbIndex < spans.length && txtIndex == spans[rbIndex].off) {
        flushPlain();
        final span = spans[rbIndex];
        result.add(NovelContentElement.rubyText(span.base, span.ruby));
        txtIndex += span.base.length;
        rbIndex++;
        continue;
      }

      final char = txt[txtIndex];
      if (char == '\n') {
        flushPlain();
        result.add(NovelContentElement.newLine());
        txtIndex++;
        continue;
      }

      plainBuffer.write(char);
      txtIndex++;
    }

    flushPlain();

    // 末尾に rb が残っている場合はエラー（txt 終端を超える、または順序不整合）
    if (rbIndex < spans.length) {
      final span = spans[rbIndex];
      throw FormatException(
        'Ruby span が txt 内で消費されませんでした '
        '(txt 終端を超える、またはスパンが重なっています): '
        'off=${span.off}, base=${span.base}',
      );
    }

    return result;
  }
}

class _RubySpan {
  const _RubySpan({required this.off, required this.base, required this.ruby});
  final int off;
  final String base;
  final String ruby;
}

/// `List<NovelContentElement>` に対する Hybrid 変換拡張
extension HybridConverterExtension on List<NovelContentElement> {
  /// Hybrid JSON 文字列に変換する
  String toHybridJson() => HybridConverter.toHybridJson(this);
}
