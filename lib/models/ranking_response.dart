import 'package:freezed_annotation/freezed_annotation.dart';

part 'ranking_response.freezed.dart';
part 'ranking_response.g.dart';

/// なろう小説ランキングAPIのレスポンスを表すクラス。
///
/// [なろう小説ランキングAPI](https://dev.syosetu.com/man/rankapi/) と
/// [なろう小説API](https://dev.syosetu.com/man/api/) のレスポンスを組み合わせたモデル。
@freezed
abstract class RankingResponse with _$RankingResponse {
  /// [RankingResponse]のコンストラクタ
  const factory RankingResponse({
    /// 順位。
    ///
    /// 1～300位。
    /// ランキングAPIで取得。
    int? rank,

    /// ポイント。
    ///
    /// ランキングAPIで取得。
    int? pt,

    /// 総合評価ポイント。
    ///
    /// (ブックマーク数×2)+評価ポイント。
    /// 小説APIで取得。
    int? allPoint,

    /// Nコード。
    required String ncode,

    /// 作品名。
    String? title,

    /// 小説タイプ。
    ///
    /// [1] 連載
    /// [2] 短編
    int? novelType,

    /// 連載状態。
    ///
    /// [0] 短編作品と完結済作品
    /// [1] 連載中
    int? end,

    /// ジャンル。
    ///
    /// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
    int? genre,

    /// 作者名。
    String? writer,

    /// 作品のあらすじ。
    String? story,

    /// 作者のユーザID(数値)。
    int? userId,

    /// 全掲載エピソード数。
    ///
    /// 短編の場合は 1。
    int? generalAllNo,

    /// キーワード。
    String? keyword,
  }) = _RankingResponse;

  /// JSONから[RankingResponse]を生成するファクトリコンストラクタ
  factory RankingResponse.fromJson(Map<String, dynamic> json) =>
      _$RankingResponseFromJson(json);
}
