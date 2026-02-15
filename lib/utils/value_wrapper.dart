import 'package:flutter/foundation.dart';

/// copyWithでnullを明示的に設定するためのラッパークラス。
///
/// 使用例:
/// ```dart
/// state.copyWith(selectedGenre: const Value<int?>(null))
/// ```
@immutable
class Value<T> {
  /// ラップする値を指定して[Value]を作成する。
  const Value(this.value);

  /// ラップされた値。
  final T value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Value<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Value($value)';
}
