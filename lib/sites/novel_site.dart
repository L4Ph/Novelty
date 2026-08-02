import 'package:flutter/foundation.dart';
import 'package:novelty/sites/novel_source.dart';

/// ジャンルのマスタデータ。
///
/// なろう・カクヨム双方のジャンル体系を表現できるよう、
/// 大ジャンルと小ジャンルの2階層を保持する。
@immutable
class GenreMaster {
  /// コンストラクタ。
  const GenreMaster({
    required this.id,
    required this.name,
    this.bigGenreId,
    this.isBigGenre = false,
  });

  /// ジャンルID。
  ///
  /// なろうはAPIの genre パラメータ値、カクヨムはカテゴリIDを想定する。
  final String id;

  /// ジャンル表示名。
  final String name;

  /// 所属する大ジャンルのID。大ジャンル自身の場合は null。
  final String? bigGenreId;

  /// 大ジャンルかどうか。false の場合は小ジャンル。
  final bool isBigGenre;

  /// すべてのフィールドが一致する場合に等価とみなす。
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is GenreMaster &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            bigGenreId == other.bigGenreId &&
            isBigGenre == other.isBigGenre;
  }

  /// フィールドから算出するハッシュ値。
  @override
  int get hashCode => Object.hash(id, name, bigGenreId, isBigGenre);

  /// デバッグ表示用の文字列。
  @override
  String toString() {
    return 'GenreMaster(id: $id, name: $name, '
        'bigGenreId: $bigGenreId, isBigGenre: $isBigGenre)';
  }
}

/// ランキング種別のマスタデータ。
@immutable
class RankingTypeMaster {
  /// コンストラクタ。
  const RankingTypeMaster({
    required this.id,
    required this.label,
    required this.urlPath,
  });

  /// ランキング種別ID。
  ///
  /// 既存UI（RankingList 等）で使われている rankingType と同一とする。
  final String id;

  /// UI表示用の種別名。
  final String label;

  /// ランキング取得先のパス。
  ///
  /// なろうはAPIの order パラメータ名、カクヨムは /rankings/... パスを想定する。
  final String urlPath;

  /// すべてのフィールドが一致する場合に等価とみなす。
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RankingTypeMaster &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            label == other.label &&
            urlPath == other.urlPath;
  }

  /// フィールドから算出するハッシュ値。
  @override
  int get hashCode => Object.hash(id, label, urlPath);

  /// デバッグ表示用の文字列。
  @override
  String toString() {
    return 'RankingTypeMaster(id: $id, label: $label, urlPath: $urlPath)';
  }
}

/// 小説提供サイトの抽象インターフェース。
///
/// P1ではサイトのマスタデータ（ジャンル・ランキング種別）を定義する。
/// 作品情報の取得などは P2 以降で追加する。
abstract class NovelSite {
  /// サイト種別。
  NovelSource get source;

  /// ジャンルのマスタデータ一覧。
  List<GenreMaster> get genres;

  /// ランキング種別のマスタデータ一覧。
  List<RankingTypeMaster> get rankingTypes;
}
