import 'package:drift/drift.dart' show Value;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:novelty/database/database.dart' hide Episode;
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/string_to_int_converter.dart';

part 'novel_info.freezed.dart';
part 'novel_info.g.dart';

/// なろう小説の作品情報を表すクラス。
///
/// [なろう小説API](https://dev.syosetu.com/man/api/) のレスポンスや、
/// なろう小説のHTMLからパースした情報を格納する。
@freezed
abstract class NovelInfo with _$NovelInfo {
  /// [NovelInfo]のコンストラクタ
  const factory NovelInfo({
    /// 作品名。
    String? title,

    /// Nコード
    ///
    /// 常に小文字で扱う
    String? ncode,

    /// 作者名。
    String? writer,

    /// 作品のあらすじ。
    String? story,

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

    /// 全掲載エピソード数。
    ///
    /// 短編の場合は 1。
    @StringToIntConverter() @JsonKey(name: 'general_all_no') int? generalAllNo,

    /// ジャンル。
    ///
    /// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
    @StringToIntConverter() int? genre,

    /// キーワード。
    String? keyword,

    /// 初回掲載日。
    ///
    /// `YYYY-MM-DD HH:MM:SS` の形式。
    @JsonKey(name: 'general_firstup') String? generalFirstup,

    /// 最終掲載日。
    ///
    /// `YYYY-MM-DD HH:MM:SS` の形式。
    @JsonKey(name: 'general_lastup') String? generalLastup,

    /// 総合評価ポイント。
    ///
    /// (ブックマーク数×2)+評価ポイント。
    @StringToIntConverter() @JsonKey(name: 'global_point') int? globalPoint,

    /// 日間ポイント。
    @StringToIntConverter() @JsonKey(name: 'daily_point') int? dailyPoint,

    /// 週間ポイント。
    @StringToIntConverter() @JsonKey(name: 'weekly_point') int? weeklyPoint,

    /// 月間ポイント。
    @StringToIntConverter() @JsonKey(name: 'monthly_point') int? monthlyPoint,

    /// 四半期ポイント。
    @StringToIntConverter() @JsonKey(name: 'quarter_point') int? quarterPoint,

    /// 年間ポイント。
    @StringToIntConverter() @JsonKey(name: 'yearly_point') int? yearlyPoint,

    /// ブックマーク数。
    @StringToIntConverter() @JsonKey(name: 'fav_novel_cnt') int? favNovelCnt,

    /// 感想数。
    @StringToIntConverter() @JsonKey(name: 'impression_cnt') int? impressionCnt,

    /// レビュー数。
    @StringToIntConverter() @JsonKey(name: 'review_cnt') int? reviewCnt,

    /// 評価ポイント。
    @StringToIntConverter() @JsonKey(name: 'all_point') int? allPoint,

    /// 評価者数。
    @StringToIntConverter() @JsonKey(name: 'all_hyoka_cnt') int? allHyokaCnt,

    /// 挿絵の数。
    @StringToIntConverter() @JsonKey(name: 'sasie_cnt') int? sasieCnt,

    /// 会話率。
    @StringToIntConverter() int? kaiwaritu,

    /// 作品の更新日時。
    @StringToIntConverter()
    @JsonKey(name: 'novelupdated_at')
    int? novelupdatedAt,

    /// 最終更新日時。
    ///
    /// システム用で作品更新時とは関係ない。
    @StringToIntConverter() @JsonKey(name: 'updated_at') int? updatedAt,

    /// エピソードのリスト。
    List<Episode>? episodes,

    /// R15作品か。
    ///
    /// [1] R15
    /// [0] それ以外
    @StringToIntConverter() int? isr15,

    /// ボーイズラブ作品か。
    ///
    /// [1] ボーイズラブ
    /// [0] それ以外
    @StringToIntConverter() int? isbl,

    /// ガールズラブ作品か。
    ///
    /// [1] ガールズラブ
    /// [0] それ以外
    @StringToIntConverter() int? isgl,

    /// 残酷な描写あり作品か。
    ///
    /// [1] 残酷な描写あり
    /// [0] それ以外
    @StringToIntConverter() int? iszankoku,

    /// 異世界転生作品か。
    ///
    /// [1] 異世界転生
    /// [0] それ以外
    @StringToIntConverter() int? istensei,

    /// 異世界転移作品か。
    ///
    /// [1] 異世界転移
    /// [0] それ以外
    @StringToIntConverter() int? istenni,
  }) = _NovelInfo;

  /// JSONから[NovelInfo]を生成するファクトリコンストラクタ
  factory NovelInfo.fromJson(Map<String, dynamic> json) {
    // ncodeを小文字化
    if (json['ncode'] is String) {
      json['ncode'] = (json['ncode'] as String).toLowerCase();
    }
    return _$NovelInfoFromJson(json);
  }
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
      generalAllNo: Value(generalAllNo),
      keyword: Value(keyword),
      generalFirstup: Value(int.tryParse(generalFirstup ?? '')),
      generalLastup: Value(int.tryParse(generalLastup ?? '')),
      globalPoint: Value(globalPoint),
      reviewCount: Value(reviewCnt),
      rateCount: Value(allHyokaCnt),
      allPoint: Value(allPoint),
      pointCount: Value(impressionCnt),
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
