import 'package:json_annotation/json_annotation.dart';

part 'episode.g.dart';

/// 小説のエピソード情報を表すクラス。
///
/// なろう小説のHTMLからパースした情報を格納する。
@JsonSerializable(fieldRename: FieldRename.snake)
class Episode {
  /// [Episode]のコンストラクタ
  Episode({
    this.subtitle,
    this.url,
    this.update,
    this.revised,
    this.ncode,
    this.index,
    this.body,
    this.novelUpdatedAt,
  });

  /// JSONから[Episode]を生成するファクトリコンストラクタ
  factory Episode.fromJson(Map<String, dynamic> json) =>
      _$EpisodeFromJson(json);

  /// サブタイトル。
  final String? subtitle;

  /// エピソードへのURL。
  final String? url;

  /// 更新日時。
  ///
  /// `YYYY/MM/DD HH:MM` の形式。
  final String? update;

  /// 改稿日時。
  ///
  /// `YYYY/MM/DD HH:MM` の形式。
  final String? revised;

  /// Nコード。
  final String? ncode;

  /// 話数。
  final int? index;

  /// 本文。
  ///
  /// HTML形式。
  final String? body;

  /// 小説の更新日時。
  ///
  /// `YYYY-MM-DD HH:MM:SS` の形式。
  final String? novelUpdatedAt;

  /// [Episode]をJSONに変換するメソッド。
  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}
