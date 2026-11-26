import 'package:novelty/database/database.dart' as db;
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/sites/novel_source.dart';

/// Whether two lists hold the same works in the same order.
///
/// Compares by (source, workId) instead of all 35 fields: the question the UI
/// states ask is "did the list change", not "was a point count refreshed".
/// NovelInfo is a DTO, so it has no deep equality of its own.
bool sameWorks(List<NovelInfo> a, List<NovelInfo> b) {
  if (identical(a, b)) {
    return true;
  }
  if (a.length != b.length) {
    return false;
  }
  for (var i = 0; i < a.length; i++) {
    if (a[i].source != b[i].source) {
      return false;
    }
    if (a[i].resolvedWorkId != b[i].resolvedWorkId) {
      return false;
    }
  }
  return true;
}

/// [db.Novel] (DB Entity) から [NovelInfo] (Domain Model) への変換を行う拡張
extension NovelInfoFromDb on db.Novel {
  /// [db.Novel] を [NovelInfo] に変換する
  NovelInfo toModel({List<Episode>? episodes}) {
    return NovelInfo(
      source: source,
      workId: workId,
      // ncodeはなろうの作品ID。なろう以外ではnull
      ncode: source == NovelSource.narou ? workId : null,
      title: title,
      writer: writer,
      story: story,
      novelType: novelType,
      end: end,
      genreId: genreId,
      generalAllNo: generalAllNo,
      keyword: keyword,
      // general_firstup / general_lastup は v20 で撤去した。どちらも
      // 日時文字列を int.tryParse で読んでいたため DB 上は常に NULL だった。
      globalPoint: globalPoint,

      reviewCnt: reviewCount,
      allHyokaCnt: rateCount,
      allPoint: allPoint,
      impressionCnt: pointCount,

      dailyPoint: dailyPoint,
      weeklyPoint: weeklyPoint,
      monthlyPoint: monthlyPoint,
      quarterPoint: quarterPoint,
      yearlyPoint: yearlyPoint,

      novelupdatedAt: novelUpdatedAt,

      episodes: episodes, // そのまま渡す（既にEpisodeモデルのリスト）

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
