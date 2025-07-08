import 'package:drift/drift.dart' show Value;
import 'package:json_annotation/json_annotation.dart';
import 'package:novelty/database/database.dart' hide Episode;
import 'package:novelty/models/episode.dart';

part 'novel_info.g.dart';

int? _toInt(dynamic val) =>
    val is int ? val : int.tryParse(val as String? ?? '');

/// なろう小説の作品情報を表すクラス。
///
/// [なろう小説API](https://dev.syosetu.com/man/api/) のレスポンスや、
/// なろう小説のHTMLからパースした情報を格納する。
@JsonSerializable(fieldRename: FieldRename.snake)
class NovelInfo {
  /// [NovelInfo]のコンストラクタ
  NovelInfo({
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

  /// JSONから[NovelInfo]を生成するファクトリコンストラクタ
  factory NovelInfo.fromJson(Map<String, dynamic> json) =>
      _$NovelInfoFromJson(json);

  /// 作品名。
  String? title;

  /// Nコード。
  String? ncode;

  /// 作者名。
  String? writer;

  /// 作品のあらすじ。
  String? story;

  /// 小説タイプ。
  ///
  /// [1] 連載
  /// [2] 短編
  @JsonKey(fromJson: _toInt)
  int? novelType;

  /// 連載状態。
  ///
  /// [0] 短編作品と完結済作品
  /// [1] 連載中
  @JsonKey(fromJson: _toInt)
  int? end;

  /// 全掲載エピソード数。
  ///
  /// 短編の場合は 1。
  @JsonKey(fromJson: _toInt)
  int? generalAllNo;

  /// ジャンル。
  ///
  /// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
  @JsonKey(fromJson: _toInt)
  int? genre;

  /// キーワード。
  String? keyword;

  /// 初回掲載日。
  ///
  /// `YYYY-MM-DD HH:MM:SS` の形式。
  String? generalFirstup;

  /// 最終掲載日。
  ///
  /// `YYYY-MM-DD HH:MM:SS` の形式。
  String? generalLastup;

  /// 総合評価ポイント。
  ///
  /// (ブックマーク数×2)+評価ポイント。
  @JsonKey(fromJson: _toInt)
  int? globalPoint;

  /// 日間ポイント。
  @JsonKey(fromJson: _toInt)
  int? dailyPoint;

  /// 週間ポイント。
  @JsonKey(fromJson: _toInt)
  int? weeklyPoint;

  /// 月間ポイント。
  @JsonKey(fromJson: _toInt)
  int? monthlyPoint;

  /// 四半期ポイント。
  @JsonKey(fromJson: _toInt)
  int? quarterPoint;

  /// 年間ポイント。
  @JsonKey(fromJson: _toInt)
  int? yearlyPoint;

  /// ブックマーク数。
  @JsonKey(fromJson: _toInt)
  int? favNovelCnt;

  /// 感想数。
  @JsonKey(fromJson: _toInt)
  int? impressionCnt;

  /// レビュー数。
  @JsonKey(fromJson: _toInt)
  int? reviewCnt;

  /// 評価ポイント。
  @JsonKey(fromJson: _toInt)
  int? allPoint;

  /// 評価者数。
  @JsonKey(fromJson: _toInt)
  int? allHyokaCnt;

  /// 挿絵の数。
  @JsonKey(fromJson: _toInt)
  int? sasieCnt;

  /// 会話率。
  @JsonKey(fromJson: _toInt)
  int? kaiwaritu;

  /// 作品の更新日時。
  @JsonKey(fromJson: _toInt)
  int? novelupdatedAt;

  /// 最終更新日時。
  ///
  /// システム用で作品更新時とは関係ない。
  @JsonKey(fromJson: _toInt)
  int? updatedAt;

  /// エピソードのリスト。
  List<Episode>? episodes;

  /// R15作品か。
  ///
  /// [1] R15
  /// [0] それ以外
  @JsonKey(fromJson: _toInt)
  int? isr15;

  /// ボーイズラブ作品か。
  ///
  /// [1] ボーイズラブ
  /// [0] それ以外
  @JsonKey(fromJson: _toInt)
  int? isbl;

  /// ガールズラブ作品か。
  ///
  /// [1] ガールズラブ
  /// [0] それ以外
  @JsonKey(fromJson: _toInt)
  int? isgl;

  /// 残酷な描写あり作品か。
  ///
  /// [1] 残酷な描写あり
  /// [0] それ以外
  @JsonKey(fromJson: _toInt)
  int? iszankoku;

  /// 異世界転生作品か。
  ///
  /// [1] 異世界転生
  /// [0] それ以外
  @JsonKey(fromJson: _toInt)
  int? istensei;

  /// 異世界転移作品か。
  ///
  /// [1] 異世界転移
  /// [0] それ以外
  @JsonKey(fromJson: _toInt)
  int? istenni;

  /// [NovelInfo]をJSONに変換するメソッド。
  Map<String, dynamic> toJson() => _$NovelInfoToJson(this);

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
      fav: Value(favNovelCnt),
      reviewCount: Value(reviewCnt),
      rateCount: Value(allHyokaCnt),
      allPoint: Value(allPoint),
      poinCount: Value(impressionCnt),
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
