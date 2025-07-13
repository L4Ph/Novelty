import 'package:drift/drift.dart' show Value;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:novelty/database/database.dart' hide Episode;
import 'package:novelty/models/episode.dart';

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

    /// Nコード。
    String? ncode,

    /// 作者名。
    String? writer,

    /// 作品のあらすじ。
    String? story,

    /// 小説タイプ。
    ///
    /// [1] 連載
    /// [2] 短編
    int? novelType,

    /// 連載状態。
    ///
    /// [0] 短編作品と��結済作品
    /// [1] 連載中
    int? end,

    /// 全掲載エピソード数。
    ///
    /// 短編の場合は 1。
    int? generalAllNo,

    /// ジャンル。
    ///
    /// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
    int? genre,

    /// キーワード。
    String? keyword,

    /// 初回掲載日。
    ///
    /// `YYYY-MM-DD HH:MM:SS` の形式。
    String? generalFirstup,

    /// 最終掲載日。
    ///
    /// `YYYY-MM-DD HH:MM:SS` の形式。
    String? generalLastup,

    /// 総合評価ポイント。
    ///
    /// (ブックマーク数×2)+評価ポイント。
    int? globalPoint,

    /// 日間ポイント。
    int? dailyPoint,

    /// 週間ポイント。
    int? weeklyPoint,

    /// 月間ポイント。
    int? monthlyPoint,

    /// 四半期ポイント。
    int? quarterPoint,

    /// 年間ポイント。
    int? yearlyPoint,

    /// ブックマーク数。
    int? favNovelCnt,

    /// 感想数。
    int? impressionCnt,

    /// レビュー数。
    int? reviewCnt,

    /// 評価ポイント。
    int? allPoint,

    /// 評価者数。
    int? allHyokaCnt,

    /// 挿絵の数。
    int? sasieCnt,

    /// 会話率。
    int? kaiwaritu,

    /// 作品の更新日時。
    int? novelupdatedAt,

    /// 最終更新日時。
    ///
    /// システム用で作品更新時とは関係ない。
    int? updatedAt,

    /// エピソードのリスト。
    List<Episode>? episodes,

    /// R15作品か。
    ///
    /// [1] R15
    /// [0] それ以外
    int? isr15,

    /// ボーイズラブ作品か。
    ///
    /// [1] ボーイズラブ
    /// [0] それ以外
    int? isbl,

    /// ガールズラブ作品か。
    ///
    /// [1] ガールズラブ
    /// [0] それ以外
    int? isgl,

    /// 残酷な描写あり作品か。
    ///
    /// [1] 残酷な描写あり
    /// [0] それ以外
    int? iszankoku,

    /// 異世界転生作品か。
    ///
    /// [1] 異世界転生
    /// [0] それ以外
    int? istensei,

    /// 異世界転移作品か。
    ///
    /// [1] 異世界転移
    /// [0] それ以外
    int? istenni,
  }) = _NovelInfo;

  /// JSONから[NovelInfo]を生成するファクトリコンストラクタ
  factory NovelInfo.fromJson(Map<String, dynamic> json) =>
      _$NovelInfoFromJson(json);
}

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
