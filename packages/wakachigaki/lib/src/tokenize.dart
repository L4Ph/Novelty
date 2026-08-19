// 分かち書き
// yuhsak/wakachigaki の src/tokenize.ts を Dart に移植

import 'package:wakachigaki/src/feature.dart';
import 'package:wakachigaki/src/model.dart';
import 'package:wakachigaki/src/predict.dart';

class _Tokenizer {
  _Tokenizer(this.nBuckets, this.size, this.offset) : _features = featurer(nBuckets, size, offset);

  final int nBuckets;
  final int size;
  final int offset;
  final List<NgramFeature> Function(String) _features;

  List<String> call(String text) {
    final chars = _features(text);
    final willBreak = predict(chars, threshold: wakachigakiThreshold);

    final acc = <String>[''];
    for (var i = 0; i < chars.length; i++) {
      acc[acc.length - 1] += chars[i].char;
      if (willBreak[i]) {
        acc.add('');
      }
    }
    return acc.where((c) => c.isNotEmpty).toList();
  }
}

final _tokenizer = _Tokenizer(wakachigakiNBuckets, wakachigakiSize, wakachigakiOffset);

/// 日本語テキストを分かち書きする
List<String> tokenize(String text) => _tokenizer(text);

/// 互換エイリアス
List<String> segment(String text) => tokenize(text);