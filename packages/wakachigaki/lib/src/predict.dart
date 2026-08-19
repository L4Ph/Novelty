// 境界確率の予測
// yuhsak/wakachigaki の src/predict/proba.ts / predict.ts を Dart に移植

import 'package:wakachigaki/src/feature.dart';
import 'package:wakachigaki/src/model.dart';
import 'package:wakachigaki/src/ngram.dart';

// 重みを「キー(int) → バケット内マップ」へ事前にインデックス化し、
// 文字ごとの繰り返し処理で動的な Map 参照・文字列補間をしないようにする。
//
// type/hash ごとに `size → offset → { value: weight }` の構造へ変換する。
typedef _Weights = Map<String, Map<int, Map<int, Map<String, num>>>>;

final _indexedWeights = _buildIndexedWeights();
final num _bias = wakachigakiModel['weight']['bias'] as num; // 参照実装と同じ
final num _distanceWeight = wakachigakiModel['weight']['distance'] as num;
final int _scale = wakachigakiScale;

_Weights _buildIndexedWeights() {
  final weight = wakachigakiModel['weight'] as Map;
  final result = <String, Map<int, Map<int, Map<String, num>>>>{};
  for (final kind in const ['type', 'hash']) {
    final byKind = weight[kind] as Map?;
    if (byKind == null) continue;
    final sizeMap = <int, Map<int, Map<String, num>>>{};
    byKind.forEach((sKey, v) {
      final size = int.tryParse('$sKey') ?? 0;
      final offsetMap = <int, Map<String, num>>{};
      (v as Map).forEach((oKey, v2) {
        final offset = int.tryParse('$oKey') ?? 0;
        (v2 as Map).forEach((valueKey, w) {
          offsetMap.putIfAbsent(offset, () => {})[valueKey] = w as num;
        });
      });
      sizeMap[size] = offsetMap;
    });
    result[kind] = sizeMap;
  }
  return result;
}

num _lookup(NgramFeatureItem f) {
  final bySize = _indexedWeights[f.kind]?[f.size];
  if (bySize == null) return 0;
  final byOffset = bySize[f.offset];
  if (byOffset == null) return 0;
  return byOffset[f.value] ?? 0;
}

/// 1文字分の確率を計算する。[distance] は前回切れ目からの距離。
double proba(List<NgramFeatureItem> features, int distance) {
  var sum = 0.0;
  for (final f in features) {
    sum += _lookup(f);
  }
  final value = (_bias + sum + distance * _distanceWeight) / _scale;
  return sigmoid(value);
}

/// 各文字が「単語境界」かどうかを bool リストで返す
List<bool> predict(
  List<NgramFeature> features, {
  double threshold = wakachigakiThreshold,
}) {
  final result = <bool>[];
  var distance = 0;
  for (final feature in features) {
    final p = proba(feature.features, distance);
    final willBreak = p > threshold;
    result.add(willBreak);
    distance = willBreak ? 0 : distance + 1;
  }
  return result;
}
