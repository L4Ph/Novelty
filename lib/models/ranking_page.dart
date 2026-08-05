import 'package:flutter/foundation.dart';
import 'package:novelty/models/novel_info.dart';

/// ランキングの1ページ分の結果を表すクラス。
///
/// ランキングの小説リストと、次のページが存在するかを保持する。
@immutable
class RankingPage {
  /// [RankingPage]のコンストラクタ
  const RankingPage({
    required List<NovelInfo> novels,
    required this.hasNextPage,
  }) : _novels = novels;

  /// ランキングの小説リスト（変更不可）
  List<NovelInfo> get novels => List.unmodifiable(_novels);
  final List<NovelInfo> _novels;

  /// 次のページが存在するかどうか
  final bool hasNextPage;

  /// フィールドを変更した新しいインスタンスを作成する
  RankingPage copyWith({
    List<NovelInfo>? novels,
    bool? hasNextPage,
  }) {
    return RankingPage(
      novels: novels ?? _novels,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RankingPage &&
          runtimeType == other.runtimeType &&
          listEquals(_novels, other._novels) &&
          hasNextPage == other.hasNextPage;

  @override
  int get hashCode => Object.hash(Object.hashAll(_novels), hasNextPage);

  @override
  String toString() =>
      'RankingPage(novels: ${_novels.length} items, hasNextPage: $hasNextPage)';
}
