import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info.dart';

/// [Novel] (DB Entity) から [NovelInfo] (Domain Model) への変換を行う拡張
extension NovelInfoFromDb on Novel {
  /// [Novel] を [NovelInfo] に変換する
  NovelInfo toModel() {
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
      favNovelCnt: null, // DBには保存されていない（favはLibraryNovelsで管理）

      reviewCnt: reviewCount,
      allHyokaCnt: rateCount,
      allPoint: allPoint,
      impressionCnt: pointCount,

      dailyPoint: dailyPoint,
      weeklyPoint: weeklyPoint,
      monthlyPoint: monthlyPoint,
      quarterPoint: quarterPoint,
      yearlyPoint: yearlyPoint,

      sasieCnt: null, // DBには保存されていない
      kaiwaritu: null, // DBには保存されていない

      // DBはText, NovelInfoはInt
      novelupdatedAt: novelUpdatedAt != null ? int.tryParse(novelUpdatedAt!) : null,

      updatedAt: null, // DBには保存されていない(system用)

      episodes: null, // DBには保存されていない

      isr15: isr15,
      isbl: isbl,
      isgl: isgl,
      iszankoku: iszankoku,
      istensei: istensei,
      istenni: istenni,
    );
  }
}
