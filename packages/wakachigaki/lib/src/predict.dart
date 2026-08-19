// 境界確率の予測
// yuhsak/wakachigaki の src/predict/proba.ts / predict.ts を Dart に移植

import 'package:wakachigaki/src/feature.dart';
import 'package:wakachigaki/src/model.dart';
import 'package:wakachigaki/src/ngram.dart';

num _lookup(Map<dynamic, dynamic> weight, NgramFeatureItem f) {
  final byKind = weight[f.kind];
  if (byKind is! Map) return 0;
  final bySize = byKind['${f.size}'];
  if (bySize is! Map) return 0;
  final byOffset = bySize['${f.offset}'];
  if (byOffset is! Map) return 0;
  final value = byOffset[f.value];
  return value is num ? value : 0;
}

/// 1文字分の確率を計算する。[distance] は前回切れ目からの距離。
double proba(List<NgramFeatureItem> features, int distance) {
  final weight = wakachigakiModel['weight'] as Map;
  final bias = weight['bias'] as num;
  final distanceWeight = weight['distance'] as num;
  final scale = wakachigakiScale;

  final sum = features.fold<num>(0, (acc, f) => acc + _lookup(weight, f));
  final value = (bias + sum + distance * distanceWeight) / scale;
  return sigmoid(value);
}

/// 各文字が「単語境界」かどうかを bool リストで返す
List<bool> predict(List<NgramFeature> features, {double threshold = 0.5}) {
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