import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:novelty/utils/ncode_utils.dart';

part 'novel_search_query.freezed.dart';
part 'novel_search_query.g.dart';

/// なろう小説APIの検索クエリを表すクラス。
///
/// [なろう小説API](https://dev.syosetu.com/man/api/) のGETパラメータを表現する。
@freezed
abstract class NovelSearchQuery with _$NovelSearchQuery {
  /// [NovelSearchQuery]のコンストラクタ
  const factory NovelSearchQuery({
    /// 検索単語。
    ///
    /// 半角または全角スペースで区切るとAND抽出になる。
    String? word,

    /// 除外単語。
    ///
    /// スペースで区切ることにより除外単語を増やせる。
    String? notword,

    /// タイトルを検索対象にするか。
    @Default(false) bool title,

    /// あらすじを検索対象にするか。
    @Default(false) bool ex,

    /// キーワードを検索対象にするか。
    @Default(false) bool keyword,

    /// 作者名を検索対象にするか。
    @Default(false) bool wname,

    /// 大ジャンル。
    ///
    /// [大ジャンル一覧](https://dev.syosetu.com/man/api/#biggenre)
    List<int>? biggenre,

    /// 除外大ジャンル。
    ///
    /// [大ジャンル一覧](https://dev.syosetu.com/man/api/#biggenre)
    List<int>? notbiggenre,

    /// ジャンル。
    ///
    /// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
    List<int>? genre,

    /// 除外ジャンル。
    ///
    /// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
    List<int>? notgenre,

    /// ユーザID。
    List<int>? userid,

    /// R15作品のみを対象とするか。
    @Default(false) bool isr15,

    /// ボーイズラブ作品のみを対象とするか。
    @Default(false) bool isbl,

    /// ガールズラブ作品のみを対象とするか。
    @Default(false) bool isgl,

    /// 残酷な描写あり作品のみを対象とするか。
    @Default(false) bool iszankoku,

    /// 異世界転生作品のみを対象とするか。
    @Default(false) bool istensei,

    /// 異世界転移作品のみを対象とするか。
    @Default(false) bool istenni,

    /// 異世界転生・転移作品のみを対象とするか。
    @Default(false) bool istt,

    /// R15作品を除外するか。
    @Default(false) bool notr15,

    /// ボーイズラブ作品を除外するか。
    @Default(false) bool notbl,

    /// ガールズラブ作品を除外するか。
    @Default(false) bool notgl,

    /// 残酷な描写あり作品を除外するか。
    @Default(false) bool notzankoku,

    /// 異世界転生作品を除外するか。
    @Default(false) bool nottensei,

    /// 異世界転移作品を除外するか。
    @Default(false) bool nottenni,

    /// 最小文字数。
    int? minlen,

    /// 最大文字数。
    int? maxlen,

    /// 文字数範囲。
    ///
    /// `minlen` または `maxlen` と併用はできない。
    /// 範囲指定する場合は、最小文字数と最大文字数をハイフン(-)記号で区切る。
    String? length,

    /// 会話率範囲。
    ///
    /// 範囲指定する場合は、最低数と最大数をハイフン(-)記号で区切る。
    String? kaiwaritu,

    /// 挿絵数範囲。
    ///
    /// 範囲指定する場合は、最小数と最大数をハイフン(-)記号で区切る。
    String? sasie,

    /// 最小読了時間(分単位)。
    int? mintime,

    /// 最大読了時間(分単位)。
    int? maxtime,

    /// 読了時間範囲。
    ///
    /// `mintime` または `maxtime` と併用はできない。
    /// 範囲指定する場合は、最小読了時間と最大読了時間をハイフン(-)記号で区切る。
    String? time,

    /// Nコード。
    ///
    /// ハイフン(-)記号で区切ればOR検索ができる。
    /// 常に小文字で扱う
    List<String>? ncode,

    /// 作品タイプ。
    ///
    /// * `t` - 短編
    /// * `r` - 連載中
    /// * `er` - 完結済連載作品
    /// * `re` - すべての連載作品(連載中および完結済)
    /// * `ter` - 短編と完結済連載作品
    String? type,

    /// 文体。
    ///
    /// ハイフン(-)記号で区切ればOR検索ができる。
    /// * `1` - 字下げされておらず、連続改行が多い作品
    /// * `2` - 字下げされていないが、改行数は平均な作品
    /// * `4` - 字下げが適切だが、連続改行が多い作品
    /// * `6` - 字下げが適切でかつ改行数も平均な作品
    List<int>? buntai,

    /// 長期連載停止中作品に関する指定。
    ///
    /// * `1` - 長期連載停止中を除きます
    /// * `2` - 長期連載停止中のみ取得します
    int? stop,

    /// 最終掲載日で抽出。
    ///
    /// * `thisweek` - 今週
    /// * `lastweek` - 先週
    /// * `sevenday` - 過去7日間
    /// * `thismonth` - 今月
    /// * `lastmonth` - 先月
    /// * `unixtime-unixtime` - UNIXタイムスタンプで範囲指定
    String? lastup,

    /// 最終更新日で抽出。
    ///
    /// * `thisweek` - 今週
    /// * `lastweek` - 先週
    /// * `sevenday` - 過去7日間
    /// * `thismonth` - 今月
    /// * `lastmonth` - 先月
    /// * `unixtime-unixtime` - UNIXタイムスタンプで範囲指定
    String? lastupdate,

    /// ピックアップ作品のみを対象とするか。
    @Default(false) bool ispickup,

    /// 出力順序。
    ///
    /// デフォルトは `new` (新着更新順)。
    /// [出力順序一覧](https://dev.syosetu.com/man/api/#order)
    @Default('new') String order,

    /// 最大出力数。
    ///
    /// 1～500。���フォルトは20。
    @Default(20) int lim,

    /// 表示開始位置。
    ///
    /// 1～2000。デフォルトは1。
    @Default(1) int st,
  }) = _NovelSearchQuery;

  /// [NovelSearchQuery]を生成するためのファクトリコンストラクタ。
  factory NovelSearchQuery.fromJson(Map<String, dynamic> json) =>
      _$NovelSearchQueryFromJson(json);
}

/// [NovelSearchQuery]をMapに変換する拡張メソッド。
extension NovelSearchQueryEx on NovelSearchQuery {
  /// [NovelSearchQuery]をMapに変換するメソッド。
  ///
  /// なろう小説APIのGETパラメータ形式に変換する。
  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'notword': notword,
      'title': title ? 1 : null,
      'ex': ex ? 1 : null,
      'keyword': keyword ? 1 : null,
      'wname': wname ? 1 : null,
      'biggenre': biggenre?.join('-'),
      'notbiggenre': notbiggenre?.join('-'),
      'genre': genre?.join('-'),
      'notgenre': notgenre?.join('-'),
      'userid': userid?.join('-'),
      'isr15': isr15 ? 1 : null,
      'isbl': isbl ? 1 : null,
      'isgl': isgl ? 1 : null,
      'iszankoku': iszankoku ? 1 : null,
      'istensei': istensei ? 1 : null,
      'istenni': istenni ? 1 : null,
      'istt': istt ? 1 : null,
      'notr15': notr15 ? 1 : null,
      'notbl': notbl ? 1 : null,
      'notgl': notgl ? 1 : null,
      'notzankoku': notzankoku ? 1 : null,
      'nottensei': nottensei ? 1 : null,
      'nottenni': nottenni ? 1 : null,
      'minlen': minlen,
      'maxlen': maxlen,
      'length': length,
      'kaiwaritu': kaiwaritu,
      'sasie': sasie,
      'mintime': mintime,
      'maxtime': maxtime,
      'time': time,
      'ncode': ncode?.map((n) => n.toNormalizedNcode()).join('-'),
      'type': type,
      'buntai': buntai?.join('-'),
      'stop': stop,
      'lastup': lastup,
      'lastupdate': lastupdate,
      'ispickup': ispickup ? 1 : null,
      'order': order,
      'lim': lim,
      'st': st,
    }..removeWhere((key, value) => value == null);
  }
}
