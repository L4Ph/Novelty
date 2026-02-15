import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:novelty/models/string_to_int_converter.dart';
import 'package:novelty/utils/ncode_utils.dart';

part 'ranking_response.g.dart';

/// なろう小説ランキングAPIのレスポンスを表すクラス。
///
/// [なろう小説ランキングAPI](https://dev.syosetu.com/man/rankapi/) と
/// [なろう小説API](https://dev.syosetu.com/man/api/) のレスポンスを組み合わせたモデル。
@immutable
@JsonSerializable()
class RankingResponse {
  /// [RankingResponse]のコンストラクタ
  const RankingResponse({
    required this.ncode,
    this.rank,
    this.pt,
    this.allPoint,
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

  /// Nコード
  ///
  /// 常に小文字で扱う
  final String ncode;

  /// 順位。
  ///
  /// 1～300位。
  /// ランキングAPIで取得。
  @StringToIntConverter()
  final int? rank;

  /// ポイント。
  ///
  /// ランキングAPIで取得。
  @StringToIntConverter()
  final int? pt;

  /// 総合評価ポイント。
  ///
  /// (ブックマーク数×2)+評価ポイント。
  /// 小説APIで取得。
  @StringToIntConverter()
  @JsonKey(name: 'all_point')
  final int? allPoint;

  /// 作品名。
  final String? title;

  /// 小説タイプ。
  ///
  /// [1] 連載
  /// [2] 短編
  @StringToIntConverter()
  @JsonKey(name: 'novel_type')
  final int? novelType;

  /// 連載状態。
  ///
  /// [0] 短編作品と完結済作品
  /// [1] 連載中
  @StringToIntConverter()
  final int? end;

  /// ジャンル。
  ///
  /// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
  @StringToIntConverter()
  final int? genre;

  /// 作者名。
  final String? writer;

  /// 作品のあらすじ。
  final String? story;

  /// 作者のユーザID(数値)。
  @StringToIntConverter()
  @JsonKey(name: 'userid')
  final int? userId;

  /// 全掲載エピソード数。
  ///
  /// 短編の場合は 1。
  @StringToIntConverter()
  @JsonKey(name: 'general_all_no')
  final int? generalAllNo;

  /// キーワード。
  final String? keyword;

  /// JSONから[RankingResponse]を生成するファクトリコンストラクタ
  factory RankingResponse.fromJson(Map<String, dynamic> json) =>
      _$RankingResponseFromJson({
        ...json,
        if (json['ncode'] is String)
          'ncode': (json['ncode'] as String).toNormalizedNcode(),
      });

  /// JSONに変換する
  Map<String, dynamic> toJson() => _$RankingResponseToJson(this);

  /// フィールドを変更した新しいインスタンスを作成する
  RankingResponse copyWith({
    String? ncode,
    int? rank,
    int? pt,
    int? allPoint,
    String? title,
    int? novelType,
    int? end,
    int? genre,
    String? writer,
    String? story,
    int? userId,
    int? generalAllNo,
    String? keyword,
  }) {
    return RankingResponse(
      ncode: ncode ?? this.ncode,
      rank: rank ?? this.rank,
      pt: pt ?? this.pt,
      allPoint: allPoint ?? this.allPoint,
      title: title ?? this.title,
      novelType: novelType ?? this.novelType,
      end: end ?? this.end,
      genre: genre ?? this.genre,
      writer: writer ?? this.writer,
      story: story ?? this.story,
      userId: userId ?? this.userId,
      generalAllNo: generalAllNo ?? this.generalAllNo,
      keyword: keyword ?? this.keyword,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RankingResponse &&
          runtimeType == other.runtimeType &&
          ncode == other.ncode &&
          rank == other.rank &&
          pt == other.pt &&
          allPoint == other.allPoint &&
          title == other.title &&
          novelType == other.novelType &&
          end == other.end &&
          genre == other.genre &&
          writer == other.writer &&
          story == other.story &&
          userId == other.userId &&
          generalAllNo == other.generalAllNo &&
          keyword == other.keyword;

  @override
  int get hashCode => Object.hash(
    ncode,
    rank,
    pt,
    allPoint,
    title,
    novelType,
    end,
    genre,
    writer,
    story,
    userId,
    generalAllNo,
    keyword,
  );

  @override
  String toString() =>
      'RankingResponse(ncode: $ncode, title: $title, rank: $rank, '
      'pt: $pt)';
}
