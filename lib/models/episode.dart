import 'package:freezed_annotation/freezed_annotation.dart';

part 'episode.freezed.dart';
part 'episode.g.dart';

/// 小説のエピソード情報を表すクラス。
///
/// なろう小説のHTMLからパースした情報を格納する。
@freezed
abstract class Episode with _$Episode {
  /// [Episode]のコンストラクタ
  const factory Episode({
    /// サブタイトル。
    String? subtitle,

    /// エピソードへのURL。
    String? url,

    /// 更新日時。
    ///
    /// `YYYY/MM/DD HH:MM` の形式。
    String? update,

    /// 改稿日時。
    ///
    /// `YYYY/MM/DD HH:MM` の形式。
    String? revised,

    /// Nコード
    ///
    /// 常に小文字で扱う
    String? ncode,

    /// 話数。
    int? index,

    /// 本文。
    ///
    /// HTML形式。
    String? body,

    /// 小説の更新日時。
    ///
    /// `YYYY-MM-DD HH:MM:SS` の形式。
    String? novelUpdatedAt,
  }) = _Episode;

  /// JSONから[Episode]を生成するファクトリコンストラクタ
  factory Episode.fromJson(Map<String, dynamic> json) {
    // ncodeを小文字化
    if (json['ncode'] is String) {
      json['ncode'] = (json['ncode'] as String).toLowerCase();
    }
    return _$EpisodeFromJson(json);
  }
}
