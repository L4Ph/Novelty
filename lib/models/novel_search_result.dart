import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:novelty/models/novel_info.dart';

part 'novel_search_result.freezed.dart';

/// 小説検索結果を表すクラス。
///
/// 検索結果の小説リストと全件数を保持する。
@freezed
abstract class NovelSearchResult with _$NovelSearchResult {
  /// [NovelSearchResult]のコンストラクタ
  const factory NovelSearchResult({
    /// 検索結果の小説リスト
    required List<NovelInfo> novels,

    /// 検索条件に一致する全件数
    required int allCount,
  }) = _NovelSearchResult;
}
