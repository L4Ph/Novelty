import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:novelty/utils/ncode_utils.dart';
import 'package:novelty/utils/value_wrapper.dart';

part 'episode.g.dart';

/// 小説のエピソード情報を表すクラス。
///
/// なろう小説のHTMLからパースした情報を格納する。
@immutable
@JsonSerializable()
class Episode {
  /// [Episode]のコンストラクタ
  const Episode({
    this.subtitle,
    this.url,
    this.update,
    this.revised,
    this.ncode,
    this.index,
    this.body,
    this.novelUpdatedAt,
    this.isDownloaded = false,
  });

  /// JSONから[Episode]を生成するファクトリコンストラクタ
  factory Episode.fromJson(Map<String, dynamic> json) => _$EpisodeFromJson({
    ...json,
    if (json['ncode'] is String)
      'ncode': (json['ncode'] as String).toNormalizedNcode(),
  });

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

  /// Nコード
  ///
  /// 常に小文字で扱う
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

  /// ダウンロード済みかどうか
  @JsonKey(defaultValue: false)
  final bool isDownloaded;

  /// JSONに変換する
  Map<String, dynamic> toJson() => _$EpisodeToJson(this);

  /// フィールドを変更した新しいインスタンスを作成する
  Episode copyWith({
    Value<String?>? subtitle,
    Value<String?>? url,
    Value<String?>? update,
    Value<String?>? revised,
    Value<String?>? ncode,
    Value<int?>? index,
    Value<String?>? body,
    Value<String?>? novelUpdatedAt,
    bool? isDownloaded,
  }) {
    return Episode(
      subtitle: subtitle != null ? subtitle.value : this.subtitle,
      url: url != null ? url.value : this.url,
      update: update != null ? update.value : this.update,
      revised: revised != null ? revised.value : this.revised,
      ncode: ncode != null ? ncode.value : this.ncode,
      index: index != null ? index.value : this.index,
      body: body != null ? body.value : this.body,
      novelUpdatedAt: novelUpdatedAt != null
          ? novelUpdatedAt.value
          : this.novelUpdatedAt,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Episode &&
          runtimeType == other.runtimeType &&
          subtitle == other.subtitle &&
          url == other.url &&
          update == other.update &&
          revised == other.revised &&
          ncode == other.ncode &&
          index == other.index &&
          body == other.body &&
          novelUpdatedAt == other.novelUpdatedAt &&
          isDownloaded == other.isDownloaded;

  @override
  int get hashCode => Object.hash(
    subtitle,
    url,
    update,
    revised,
    ncode,
    index,
    body,
    novelUpdatedAt,
    isDownloaded,
  );

  @override
  String toString() =>
      'Episode(subtitle: $subtitle, url: $url, index: $index, '
      'ncode: $ncode, isDownloaded: $isDownloaded)';
}
