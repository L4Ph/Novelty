import 'package:drift/drift.dart' show Value;
import 'package:json_annotation/json_annotation.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/int_or_string_converter.dart';
import 'package:novelty/models/string_to_int_converter.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/html_escape_converter.dart';
import 'package:novelty/utils/ncode_utils.dart';

part 'novel_info.g.dart';

/// 小説の作品情報を表すクラス。
///
/// なろう小説APIのレスポンスや、なろう小説のHTMLからパースした情報を格納する。
/// カクヨム対応（#240）により、[source]で提供サイトを識別する。
@JsonSerializable()
class NovelInfo {
  /// Constructor.
  const NovelInfo({
    this.source = NovelSource.narou,
    this.workId,
    this.title,
    this.ncode,
    this.writer,
    this.userId,
    this.story,
    this.novelType,
    this.end,
    this.generalAllNo,
    this.genreId,
    this.keyword,
    this.generalFirstup,
    this.generalLastup,
    this.globalPoint,
    this.dailyPoint,
    this.weeklyPoint,
    this.monthlyPoint,
    this.quarterPoint,
    this.yearlyPoint,
    this.favNovelCnt,
    this.impressionCnt,
    this.reviewCnt,
    this.allPoint,
    this.allHyokaCnt,
    this.sasieCnt,
    this.kaiwaritu,
    this.novelupdatedAt,
    this.episodes,
    this.isr15,
    this.isbl,
    this.isgl,
    this.iszankoku,
    this.istensei,
    this.istenni,
    this.isPrivate = false,
  });

  /// JSONから[NovelInfo]を生成するファクトリコンストラクタ
  factory NovelInfo.fromJson(Map<String, dynamic> json) => _$NovelInfoFromJson({
    ...json,
    if (json['ncode'] is String)
      'ncode': (json['ncode'] as String).toNormalizedNcode(),
    // 旧フォーマット（workId未設定）の場合はncodeから補完する
    if (json['workId'] == null && json['ncode'] is String)
      'workId': (json['ncode'] as String).toNormalizedNcode(),
  });

  /// JSONへ変換する。
  Map<String, dynamic> toJson() => _$NovelInfoToJson(this);

  /// 提供サイト（プロバイダ）。
  final NovelSource source;

  /// サイト共通の作品ID。
  ///
  /// なろうはNコード、カクヨムは作品IDが入る。
  /// なろうの場合は[ncode]と同一の値になる。
  final String? workId;

  /// 作品名。
  @HtmlEscapeConverter()
  final String? title;

  /// Nコード
  ///
  /// 常に小文字で扱う。なろう以外のサイトでは null。
  final String? ncode;

  /// 作者名。
  @HtmlEscapeConverter()
  final String? writer;

  /// ユーザID。
  @StringToIntConverter()
  @JsonKey(name: 'userid')
  final int? userId;

  /// 作品のあらすじ。
  @HtmlEscapeConverter()
  final String? story;

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

  /// 全掲載エピソード数。
  ///
  /// 短編の場合は 1。
  @StringToIntConverter()
  @JsonKey(name: 'general_all_no')
  final int? generalAllNo;

  /// ジャンル。
  ///
  /// サイト共通のジャンルID（文字列）。
  /// なろうは [ジャンル一覧](https://dev.syosetu.com/man/api/#genre) のID文字列。
  /// カクヨムはカテゴリID文字列。
  /// なろうAPIは作品によって数値で返す場合があるため、[IntOrStringConverter] で正規化する。
  @IntOrStringConverter()
  @JsonKey(name: 'genre')
  final String? genreId;

  /// キーワード。
  @HtmlEscapeConverter()
  final String? keyword;

  /// 初回掲載日。
  ///
  /// `YYYY-MM-DD HH:MM:SS` の形式。
  @JsonKey(name: 'general_firstup')
  final String? generalFirstup;

  /// 最終掲載日。
  ///
  /// `YYYY-MM-DD HH:MM:SS` の形式。
  @JsonKey(name: 'general_lastup')
  final String? generalLastup;

  /// 総合評価ポイント。
  ///
  /// (ブックマーク数×2)+評価ポイント。
  @StringToIntConverter()
  @JsonKey(name: 'global_point')
  final int? globalPoint;

  /// 日間ポイント。
  @StringToIntConverter()
  @JsonKey(name: 'daily_point')
  final int? dailyPoint;

  /// 週間ポイント。
  @StringToIntConverter()
  @JsonKey(name: 'weekly_point')
  final int? weeklyPoint;

  /// 月間ポイント。
  @StringToIntConverter()
  @JsonKey(name: 'monthly_point')
  final int? monthlyPoint;

  /// 四半期ポイント。
  @StringToIntConverter()
  @JsonKey(name: 'quarter_point')
  final int? quarterPoint;

  /// 年間ポイント。
  @StringToIntConverter()
  @JsonKey(name: 'yearly_point')
  final int? yearlyPoint;

  /// ブックマーク数。
  @StringToIntConverter()
  @JsonKey(name: 'fav_novel_cnt')
  final int? favNovelCnt;

  /// 感想数。
  @StringToIntConverter()
  @JsonKey(name: 'impression_cnt')
  final int? impressionCnt;

  /// レビュー数。
  @StringToIntConverter()
  @JsonKey(name: 'review_cnt')
  final int? reviewCnt;

  /// 評価ポイント。
  @StringToIntConverter()
  @JsonKey(name: 'all_point')
  final int? allPoint;

  /// 評価者数。
  @StringToIntConverter()
  @JsonKey(name: 'all_hyoka_cnt')
  final int? allHyokaCnt;

  /// 挿絵の数。
  @StringToIntConverter()
  @JsonKey(name: 'sasie_cnt')
  final int? sasieCnt;

  /// 会話率。
  @StringToIntConverter()
  final int? kaiwaritu;

  /// 作品の更新日時。
  ///
  /// The API returns a date string such as `2026-03-22 23:00:26`.
  /// It used to be decoded as int, which always produced null.
  @JsonKey(name: 'novelupdated_at')
  final String? novelupdatedAt;

  /// エピソードのリスト。
  final List<Episode>? episodes;

  /// ログとデバッグ用の文字列表現。
  @override
  String toString() {
    final parts = <String>[
      'source: $source',
      'workId: $workId',
      'title: $title',
      'ncode: $ncode',
      'writer: $writer',
      'userId: $userId',
      'story: $story',
      'novelType: $novelType',
      'end: $end',
      'generalAllNo: $generalAllNo',
      'genreId: $genreId',
      'keyword: $keyword',
      'generalFirstup: $generalFirstup',
      'generalLastup: $generalLastup',
      'globalPoint: $globalPoint',
      'dailyPoint: $dailyPoint',
      'weeklyPoint: $weeklyPoint',
      'monthlyPoint: $monthlyPoint',
      'quarterPoint: $quarterPoint',
      'yearlyPoint: $yearlyPoint',
      'favNovelCnt: $favNovelCnt',
      'impressionCnt: $impressionCnt',
      'reviewCnt: $reviewCnt',
      'allPoint: $allPoint',
      'allHyokaCnt: $allHyokaCnt',
      'sasieCnt: $sasieCnt',
      'kaiwaritu: $kaiwaritu',
      'novelupdatedAt: $novelupdatedAt',
      'episodes: $episodes',
      'isr15: $isr15',
      'isbl: $isbl',
      'isgl: $isgl',
      'iszankoku: $iszankoku',
      'istensei: $istensei',
      'istenni: $istenni',
      'isPrivate: $isPrivate',
    ];
    return 'NovelInfo(${parts.join(', ')})';
  }

  /// R15作品か。
  ///
  /// [1] R15
  /// [0] それ以外
  @StringToIntConverter()
  final int? isr15;

  /// ボーイズラブ作品か。
  ///
  /// [1] ボーイズラブ
  /// [0] それ以外
  @StringToIntConverter()
  final int? isbl;

  /// ガールズラブ作品か。
  ///
  /// [1] ガールズラブ
  /// [0] それ以外
  @StringToIntConverter()
  final int? isgl;

  /// 残酷な描写あり作品か。
  ///
  /// [1] 残酷な描写あり
  /// [0] それ以外
  @StringToIntConverter()
  final int? iszankoku;

  /// 異世界転生作品か。
  ///
  /// [1] 異世界転生
  /// [0] それ以外
  @StringToIntConverter()
  final int? istensei;

  /// 異世界転移作品か。
  ///
  /// [1] 異世界転移
  /// [0] それ以外
  @StringToIntConverter()
  final int? istenni;

  /// 非公開・削除等でAPIから取得できない状態か。
  final bool isPrivate;

  /// Copies the fields callers actually change.
  ///
  /// A full copyWith was generated before and only these two were ever used.
  NovelInfo copyWith({int? novelType, List<Episode>? episodes}) {
    return NovelInfo(
      source: source,
      workId: workId,
      title: title,
      ncode: ncode,
      writer: writer,
      userId: userId,
      story: story,
      novelType: novelType ?? this.novelType,
      end: end,
      generalAllNo: generalAllNo,
      genreId: genreId,
      keyword: keyword,
      generalFirstup: generalFirstup,
      generalLastup: generalLastup,
      globalPoint: globalPoint,
      dailyPoint: dailyPoint,
      weeklyPoint: weeklyPoint,
      monthlyPoint: monthlyPoint,
      quarterPoint: quarterPoint,
      yearlyPoint: yearlyPoint,
      favNovelCnt: favNovelCnt,
      impressionCnt: impressionCnt,
      reviewCnt: reviewCnt,
      allPoint: allPoint,
      allHyokaCnt: allHyokaCnt,
      sasieCnt: sasieCnt,
      kaiwaritu: kaiwaritu,
      novelupdatedAt: novelupdatedAt,
      episodes: episodes ?? this.episodes,
      isr15: isr15,
      isbl: isbl,
      isgl: isgl,
      iszankoku: iszankoku,
      istensei: istensei,
      istenni: istenni,
      isPrivate: isPrivate,
    );
  }
}

/// Helpers for the fields that every site is expected to populate.
extension NovelInfoEx on NovelInfo {
  /// The site-wide work id.
  ///
  /// Narou derives it from the ncode when the payload has no explicit workId.
  /// Null means the payload was unusable, which is worth failing on rather
  /// than letting a null reach a NOT NULL column.
  String? get resolvedWorkId => workId ?? ncode;

  /// Maps this model onto the row it came from.
  NovelsCompanion toDbCompanion() {
    return NovelsCompanion(
      source: Value(source),
      workId: Value(
        resolvedWorkId ??
            (throw StateError('NovelInfo has neither workId nor ncode')),
      ),
      title: Value(title),
      writer: Value(writer),
      userId: Value(userId),
      story: Value(story),
      novelType: Value(novelType),
      end: Value(end),
      genreId: Value(genreId),
      generalAllNo: Value(generalAllNo),
      keyword: Value(keyword),
      globalPoint: Value(globalPoint),
      reviewCount: Value(reviewCnt),
      rateCount: Value(allHyokaCnt),
      allPoint: Value(allPoint),
      pointCount: Value(impressionCnt),
      dailyPoint: Value(dailyPoint),
      weeklyPoint: Value(weeklyPoint),
      monthlyPoint: Value(monthlyPoint),
      quarterPoint: Value(quarterPoint),
      yearlyPoint: Value(yearlyPoint),
      novelUpdatedAt: Value(novelupdatedAt),
      cachedAt: Value(DateTime.now().millisecondsSinceEpoch),
      isr15: Value(isr15),
      isbl: Value(isbl),
      isgl: Value(isgl),
      iszankoku: Value(iszankoku),
      istensei: Value(istensei),
      istenni: Value(istenni),
      isPrivate: Value(isPrivate),
    );
  }
}
