import 'package:wakachigaki/src/feature.dart';

// 最小実装: 文字種に基づく簡易分かち書き
// 本来は重み付きロジスティック回帰で境界確率を計算するが、
// 第一弾では文字種 N-gram の簡易版で近似する。
// 将来 tool/codegen.dart で生成した重みを使って predict を差し替える.

/// 日本語テキストを分かち書きする
List<String> tokenize(String text) {
  if (text.isEmpty) return [];
  final normalized = text.replaceAll(RegExp(r'\s+'), '');
  if (normalized.isEmpty) return [];
  if (normalized.length == 1) return [normalized];

  final tokens = <String>[];
  final buffer = StringBuffer();

  for (var i = 0; i < normalized.length; i++) {
    final ch = normalized[i];
    buffer.write(ch);

    if (i < normalized.length - 1) {
      final nextCh = normalized[i + 1];
      final nextType = getCharType(nextCh);
      final currType = getCharType(ch);
      final isBoundary =
          (currType != nextType && currType != 'H' && nextType != 'H') ||
              (nextCh == 'は' ||
                  nextCh == 'が' ||
                  nextCh == 'を' ||
                  nextCh == 'に' ||
                  nextCh == 'で');
      if (isBoundary && buffer.length >= 2) {
        tokens.add(buffer.toString());
        buffer.clear();
      }
    }
  }
  if (buffer.isNotEmpty) {
    tokens.add(buffer.toString());
  }
  final merged = <String>[];
  for (final t in tokens) {
    if (t.length == 1 && merged.isNotEmpty && merged.last.length == 1) {
      merged[merged.length - 1] = merged.last + t;
    } else {
      merged.add(t);
    }
  }
  return merged.where((e) => e.isNotEmpty).toList();
}

/// 互換エイリアス
List<String> segment(String text) => tokenize(text);
