import 'package:tategaki/src/layout/vertical_orientation_data.dart';

/// Unicode UAX #50 の `Vertical_Orientation` プロパティ値
enum TategakiOrientation {
  /// 正立（code chart と同じ向き）
  upright,

  /// 90度時計回りに横倒し
  rotated,

  /// 正立だが縦書き用字形（フォールバックは正立）
  transformedUpright,

  /// 縦書き用字形（フォールバックは横倒し）
  transformedRotated,
}

/// 文字の縦書き時の向きを UAX #50 の範囲表から解決する
class VerticalOrientation {
  VerticalOrientation._();

  /// コードポイントの向きを返す。
  ///
  /// 表に無い場合は正立（U）とする（CJK の未割り当ては正立が既定）。
  static TategakiOrientation of(int codePoint) {
    final index = _search(codePoint);
    if (index < 0) {
      return TategakiOrientation.upright;
    }
    return switch (verticalOrientationValues[index]) {
      1 => TategakiOrientation.rotated,
      2 => TategakiOrientation.transformedUpright,
      3 => TategakiOrientation.transformedRotated,
      _ => TategakiOrientation.upright,
    };
  }

  /// `text-orientation: mixed` 相当で横倒し（R）になるかどうか
  static bool isRotated(int codePoint) {
    return of(codePoint) == TategakiOrientation.rotated;
  }

  /// コードポイントを含む範囲のインデックスを二分探索で返す。無ければ -1。
  static int _search(int codePoint) {
    var low = 0;
    var high = verticalOrientationStarts.length - 1;
    while (low <= high) {
      final mid = (low + high) >> 1;
      if (codePoint < verticalOrientationStarts[mid]) {
        high = mid - 1;
      } else if (codePoint > verticalOrientationEnds[mid]) {
        low = mid + 1;
      } else {
        return mid;
      }
    }
    return -1;
  }
}
