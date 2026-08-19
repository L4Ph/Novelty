// N-gram 生成と sigmoid
// yuhsak/wakachigaki の src/util.ts を Dart に移植

import 'dart:math' as math;

/// chars の位置 index 起点で [size] 文字（offset 分ずらした）を連結する関数を返す
String Function(int, int) Function(int) ngram(List<String> chars) {
  return (index) {
    return (size, offset) {
      var result = '';
      for (var k = 0; k < size; k++) {
        final pos = index + offset + k;
        if (pos < 0 || pos >= chars.length) continue;
        result += chars[pos];
      }
      return result;
    };
  };
}

/// [start, end) の整数リスト
List<int> range(int start, int end) =>
    List.generate(end - start, (i) => start + i);

/// シグモイド関数
double sigmoid(num n) => 1 / (1 + math.exp(-n));