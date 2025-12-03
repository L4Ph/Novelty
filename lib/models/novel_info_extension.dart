import 'package:novelty/database/database.dart' as db;
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';

/// [db.Novel] (DB Entity) から [NovelInfo] (Domain Model) への変換を行う拡張
extension NovelInfoFromDb on db.Novel {
  /// [db.Novel] を [NovelInfo] に変換する
  NovelInfo toModel({List<Episode>? episodes}) {
    return NovelInfo(
      ncode: ncode,
      title: title,
      writer: writer,
      story: story,
      novelType: novelType,
      end: end,
      genre: genre,
      generalAllNo: generalAllNo,
      keyword: keyword,
      // DB定義はIntColumnだが、NovelInfoはString期待。
      // 現状の実装(toDbCompanion)ではint.tryParseしており、
      // 日付文字列がパースできずnullになっている可能性が高いが、
      // 値が入っている場合は文字列として返す。
      generalFirstup: generalFirstup?.toString(),
      generalLastup: generalLastup?.toString(),

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

      // DBはText, NovelInfoはInt
      novelupdatedAt: novelUpdatedAt != null
          ? int.tryParse(novelUpdatedAt!)
          : null,

      episodes: episodes, // そのまま渡す（既にEpisodeモデルのリスト）

      isr15: isr15,
      isbl: isbl,
      isgl: isgl,
      iszankoku: iszankoku,
      istensei: istensei,
      istenni: istenni,
    );
  }
}
