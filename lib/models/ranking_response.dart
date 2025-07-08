import 'package:json_annotation/json_annotation.dart';

part 'ranking_response.g.dart';

/// なろう小説ランキングAPIのレスポンスを表すクラス。
///
/// [なろう小説ランキングAPI](https://dev.syosetu.com/man/rankapi/) と
/// [なろう小説API](https://dev.syosetu.com/man/api/) のレスポンスを組み合わせたモデル。
@JsonSerializable()
class RankingResponse {
  /// [RankingResponse]のコンストラクタ
  RankingResponse({
    this.rank,
    this.pt,
    this.allPoint,
    required this.ncode,
    this.title,
    this.novelType,
    this.end,
    this.genre,
    this.writer,
    this.story,
    this.userId,
    this.generalAllNo,
    this.keyword,
  });

  /// JSONから[RankingResponse]を生成するファクトリコンストラクタ
  factory RankingResponse.fromJson(Map<String, dynamic> json) =>
      _$RankingResponseFromJson(json);

  /// 順位。
  ///
  /// 1～300位。
  /// ランキングAPIで取得。
  final int? rank;

  /// ポイント。
  ///
  /// ランキングAPIで取得。
  final int? pt;

  /// 総合評価ポイント。
  ///
  /// (ブックマーク数×2)+評価ポイント。
  /// 小説APIで取得。
  @JsonKey(name: 'all_point')
  final int? allPoint;

  /// Nコード。
  final String ncode;

  /// 作品名。
  final String? title;

  /// 小説タイプ。
  ///
  /// [1] 連載
  /// [2] 短編
  @JsonKey(name: 'noveltype')
  final int? novelType;

  /// 連載状態。
  ///
  /// [0] 短編作品と完結済作品
  /// [1] 連載中
  final int? end;

  /// ジャンル。
  ///
  /// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
  final int? genre;

  /// 作者名。
  final String? writer;

  /// 作品のあらすじ。
  final String? story;

  /// 作者のユーザID(数値)。
  @JsonKey(name: 'userid')
  final int? userId;

  /// 全掲載エピソード数。
  ///
  /// 短編の場合は 1。
  @JsonKey(name: 'general_all_no')
  final int? generalAllNo;

  /// キーワード。
  final String? keyword;

  /// [RankingResponse]をJSONに変換するメソッド
  Map<String, dynamic> toJson() => _$RankingResponseToJson(this);
}
