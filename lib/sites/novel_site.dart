import 'package:flutter/foundation.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/models/novel_search_result.dart';
import 'package:novelty/models/ranking_page.dart';
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
/// サイトのマスタデータ（ジャンル・ランキング種別）に加え、
/// 作品情報・目次・本文の取得（読書コア）を提供する。
abstract class NovelSite {
  /// コンストラクタ。
  const NovelSite();

  /// サイト種別。
  NovelSource get source;

  /// ジャンルのマスタデータ一覧。
  List<GenreMaster> get genres;

  /// ランキング種別のマスタデータ一覧。
  List<RankingTypeMaster> get rankingTypes;

  /// リスト表示用のサイト固有情報サフィックスを返す。
  ///
  /// なろうは「1.2k pt」、カクヨムは「★1,234」のように、
  /// サイトごとの評価指標を整形して返す。
  /// 表示すべき情報がない場合は null。
  String? metaText(NovelInfo info);

  /// 作品情報を取得する。
  ///
  /// 未対応サイトでは [UnsupportedError] を投げる。
  Future<NovelInfo> fetchNovelInfo(String workId) {
    throw UnsupportedError('${source.label} は作品情報取得に対応していません');
  }

  /// 目次（エピソード一覧）を取得する。
  ///
  /// 未対応サイトでは [UnsupportedError] を投げる。
  Future<List<Episode>> fetchToc(String workId) {
    throw UnsupportedError('${source.label} は目次取得に対応していません');
  }

  /// エピソード本文を取得する。
  ///
  /// [index] は目次順の連番、[url] は解決済みのエピソードURL
  /// （省略時は目次から解決する）。
  /// 未対応サイトでは [UnsupportedError] を投げる。
  Future<Episode> fetchEpisode(
    String workId,
    int index, {
    String? url,
  }) {
    throw UnsupportedError('${source.label} は本文取得に対応していません');
  }

  /// キーワード検索を実行する。
  ///
  /// 共通項目（[NovelSearchQuery.word] / [NovelSearchQuery.st] 等）を使用する。
  /// 未対応サイトでは [UnsupportedError] を投げる。
  Future<NovelSearchResult> searchNovels(NovelSearchQuery query) {
    throw UnsupportedError('${source.label} は検索に対応していません');
  }

  /// ランキングを取得する。
  ///
  /// [rankingType] は [RankingTypeMaster.id] に対応する。
  /// 未対応サイトでは [UnsupportedError] を投げる。
  Future<RankingPage> fetchRanking(
    String rankingType, {
    int page = 1,
  }) {
    throw UnsupportedError('${source.label} はランキングに対応していません');
  }
}
