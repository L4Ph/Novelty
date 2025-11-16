import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:novelty/models/string_to_int_converter.dart';
import 'package:novelty/utils/ncode_utils.dart';

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
    /// Nコード
    ///
    /// 常に小文字で扱う
    required String ncode,

    /// 順位。
    ///
    /// 1～300位。
    /// ランキングAPIで取得。
    @StringToIntConverter() int? rank,

    /// ポイント。
    ///
    /// ランキングAPIで取得。
    @StringToIntConverter() int? pt,

    /// 総合評価ポイント。
    ///
    /// (ブックマーク数×2)+評価ポイント。
    /// 小説APIで取得。
    @StringToIntConverter() @JsonKey(name: 'all_point') int? allPoint,

    /// 作品名。
    String? title,

    /// 小説タイプ。
    ///
    /// [1] 連載
    /// [2] 短編
    @StringToIntConverter() @JsonKey(name: 'novel_type') int? novelType,

    /// 連載状態。
    ///
    /// [0] 短編作品と完結済作品
    /// [1] 連載中
    @StringToIntConverter() int? end,

    /// ジャンル。
    ///
    /// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
    @StringToIntConverter() int? genre,

    /// 作者名。
    String? writer,

    /// 作品のあらすじ。
    String? story,

    /// 作者のユーザID(数値)。
    @StringToIntConverter() @JsonKey(name: 'userid') int? userId,

    /// 全掲載エピソード数。
    ///
    /// 短編の場合は 1。
    @StringToIntConverter() @JsonKey(name: 'general_all_no') int? generalAllNo,

    /// キーワード。
    String? keyword,
  }) = _RankingResponse;

  /// JSONから[RankingResponse]を生成するファクトリコンストラクタ
  factory RankingResponse.fromJson(Map<String, dynamic> json) =>
      _$RankingResponseFromJson({
        ...json,
        if (json['ncode'] is String) 'ncode': (json['ncode'] as String).toNormalizedNcode(),
      });
}
