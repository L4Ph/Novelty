import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/string_to_int_converter.dart';
import 'package:novelty/utils/ncode_utils.dart';

part 'novel_info.g.dart';

/// なろう小説の作品情報を表すクラス。
///
/// [なろう小説API](https://dev.syosetu.com/man/api/) のレスポンスや、
/// なろう小説のHTMLからパースした情報を格納する。
@immutable
@JsonSerializable()
class NovelInfo {
  /// [NovelInfo]のコンストラクタ
  const NovelInfo({
    this.title,
    this.ncode,
    this.writer,
    this.story,
    this.novelType,
    this.end,
    this.generalAllNo,
    this.genre,
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
    this.updatedAt,
    this.episodes,
    this.isr15,
    this.isbl,
    this.isgl,
    this.iszankoku,
    this.istensei,
    this.istenni,
  });

  /// 作品名。
  final String? title;

  /// Nコード
  ///
  /// 常に小文字で扱う
  final String? ncode;

  /// 作者名。
  final String? writer;

  /// 作品のあらすじ。
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
  /// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
  @StringToIntConverter()
  final int? genre;

  /// キーワード。
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
  @StringToIntConverter()
  @JsonKey(name: 'novelupdated_at')
  final int? novelupdatedAt;

  /// 最終更新日時。
  ///
  /// システム用で作品更新時とは関係ない。
  @StringToIntConverter()
  @JsonKey(name: 'updated_at')
  final int? updatedAt;

  /// エピソードのリスト。
  final List<Episode>? episodes;

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

  /// JSONから[NovelInfo]を生成するファクトリコンストラクタ
  factory NovelInfo.fromJson(Map<String, dynamic> json) => _$NovelInfoFromJson({
    ...json,
    if (json['ncode'] is String)
      'ncode': (json['ncode'] as String).toNormalizedNcode(),
  });

  /// JSONに変換する
  Map<String, dynamic> toJson() => _$NovelInfoToJson(this);

  /// フィールドを変更した新しいインスタンスを作成する
  NovelInfo copyWith({
    String? title,
    String? ncode,
    String? writer,
    String? story,
    int? novelType,
    int? end,
    int? generalAllNo,
    int? genre,
    String? keyword,
    String? generalFirstup,
    String? generalLastup,
    int? globalPoint,
    int? dailyPoint,
    int? weeklyPoint,
    int? monthlyPoint,
    int? quarterPoint,
    int? yearlyPoint,
    int? favNovelCnt,
    int? impressionCnt,
    int? reviewCnt,
    int? allPoint,
    int? allHyokaCnt,
    int? sasieCnt,
    int? kaiwaritu,
    int? novelupdatedAt,
    int? updatedAt,
    List<Episode>? episodes,
    int? isr15,
    int? isbl,
    int? isgl,
    int? iszankoku,
    int? istensei,
    int? istenni,
  }) {
    return NovelInfo(
      title: title ?? this.title,
      ncode: ncode ?? this.ncode,
      writer: writer ?? this.writer,
      story: story ?? this.story,
      novelType: novelType ?? this.novelType,
      end: end ?? this.end,
      generalAllNo: generalAllNo ?? this.generalAllNo,
      genre: genre ?? this.genre,
      keyword: keyword ?? this.keyword,
      generalFirstup: generalFirstup ?? this.generalFirstup,
      generalLastup: generalLastup ?? this.generalLastup,
      globalPoint: globalPoint ?? this.globalPoint,
      dailyPoint: dailyPoint ?? this.dailyPoint,
      weeklyPoint: weeklyPoint ?? this.weeklyPoint,
      monthlyPoint: monthlyPoint ?? this.monthlyPoint,
      quarterPoint: quarterPoint ?? this.quarterPoint,
      yearlyPoint: yearlyPoint ?? this.yearlyPoint,
      favNovelCnt: favNovelCnt ?? this.favNovelCnt,
      impressionCnt: impressionCnt ?? this.impressionCnt,
      reviewCnt: reviewCnt ?? this.reviewCnt,
      allPoint: allPoint ?? this.allPoint,
      allHyokaCnt: allHyokaCnt ?? this.allHyokaCnt,
      sasieCnt: sasieCnt ?? this.sasieCnt,
      kaiwaritu: kaiwaritu ?? this.kaiwaritu,
      novelupdatedAt: novelupdatedAt ?? this.novelupdatedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      episodes: episodes ?? this.episodes,
      isr15: isr15 ?? this.isr15,
      isbl: isbl ?? this.isbl,
      isgl: isgl ?? this.isgl,
      iszankoku: iszankoku ?? this.iszankoku,
      istensei: istensei ?? this.istensei,
      istenni: istenni ?? this.istenni,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NovelInfo &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          ncode == other.ncode &&
          writer == other.writer &&
          story == other.story &&
          novelType == other.novelType &&
          end == other.end &&
          generalAllNo == other.generalAllNo &&
          genre == other.genre &&
          keyword == other.keyword &&
          generalFirstup == other.generalFirstup &&
          generalLastup == other.generalLastup &&
          globalPoint == other.globalPoint &&
          dailyPoint == other.dailyPoint &&
          weeklyPoint == other.weeklyPoint &&
          monthlyPoint == other.monthlyPoint &&
          quarterPoint == other.quarterPoint &&
          yearlyPoint == other.yearlyPoint &&
          favNovelCnt == other.favNovelCnt &&
          impressionCnt == other.impressionCnt &&
          reviewCnt == other.reviewCnt &&
          allPoint == other.allPoint &&
          allHyokaCnt == other.allHyokaCnt &&
          sasieCnt == other.sasieCnt &&
          kaiwaritu == other.kaiwaritu &&
          novelupdatedAt == other.novelupdatedAt &&
          updatedAt == other.updatedAt &&
          episodes == other.episodes &&
          isr15 == other.isr15 &&
          isbl == other.isbl &&
          isgl == other.isgl &&
          iszankoku == other.iszankoku &&
          istensei == other.istensei &&
          istenni == other.istenni;

  @override
  int get hashCode => Object.hash(
    title,
    ncode,
    writer,
    novelType,
    end,
    generalAllNo,
    genre,
    globalPoint,
    episodes,
  );

  @override
  String toString() =>
      'NovelInfo(title: $title, ncode: $ncode, writer: $writer)';
}

/// [NovelInfo]をデータベースの[NovelsCompanion]に変換する拡張メソッド。
extension NovelInfoEx on NovelInfo {
  /// [NovelInfo]をデータベースの[NovelsCompanion]に変換するメソッド。
  NovelsCompanion toDbCompanion() {
    return NovelsCompanion(
      ncode: Value(ncode!),
      title: Value(title),
      writer: Value(writer),
      story: Value(story),
      novelType: Value(novelType),
      end: Value(end),
      genre: Value(genre),
      generalAllNo: Value(generalAllNo),
      keyword: Value(keyword),
      generalFirstup: Value(int.tryParse(generalFirstup ?? '')),
      generalLastup: Value(int.tryParse(generalLastup ?? '')),
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
      novelUpdatedAt: Value(novelupdatedAt?.toString()),
      cachedAt: Value(DateTime.now().millisecondsSinceEpoch),
      isr15: Value(isr15),
      isbl: Value(isbl),
      isgl: Value(isgl),
      iszankoku: Value(iszankoku),
      istensei: Value(istensei),
      istenni: Value(istenni),
    );
  }
}
