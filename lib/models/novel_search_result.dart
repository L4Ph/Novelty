import 'package:flutter/foundation.dart';
import 'package:novelty/models/novel_info.dart';

/// 小説検索結果を表すクラス。
///
/// 検索結果の小説リストと全件数を保持する。
@immutable
class NovelSearchResult {
  /// [NovelSearchResult]のコンストラクタ
  const NovelSearchResult({
    required this.novels,
    required this.allCount,
  });

  /// 検索結果の小説リスト
  final List<NovelInfo> novels;

  /// 検索条件に一致する全件数
  final int allCount;

  /// フィールドを変更した新しいインスタンスを作成する
  NovelSearchResult copyWith({
    List<NovelInfo>? novels,
    int? allCount,
  }) {
    return NovelSearchResult(
      novels: novels ?? this.novels,
      allCount: allCount ?? this.allCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NovelSearchResult &&
          runtimeType == other.runtimeType &&
          listEquals(novels, other.novels) &&
          allCount == other.allCount;

  @override
  int get hashCode => Object.hash(Object.hashAll(novels), allCount);

  @override
  String toString() =>
      'NovelSearchResult(novels: $novels, allCount: $allCount)';
}
