import 'package:drift/drift.dart' show Value;
import 'package:json_annotation/json_annotation.dart';
import 'package:novelty/database/database.dart' hide Episode;
import 'package:novelty/models/episode.dart';

part 'novel_info.g.dart';

int? _toInt(dynamic val) =>
    val is int ? val : int.tryParse(val as String? ?? '');

@JsonSerializable(fieldRename: FieldRename.snake)
class NovelInfo {
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

  factory NovelInfo.fromJson(Map<String, dynamic> json) =>
      _$NovelInfoFromJson(json);
  String? title;
  String? ncode;
  String? writer;
  String? story;
  @JsonKey(fromJson: _toInt)
  int? novelType;
  @JsonKey(fromJson: _toInt)
  int? end;
  @JsonKey(fromJson: _toInt)
  int? generalAllNo;
  @JsonKey(fromJson: _toInt)
  int? genre;
  String? keyword;
  String? generalFirstup;
  String? generalLastup;
  @JsonKey(fromJson: _toInt)
  int? globalPoint;
  @JsonKey(fromJson: _toInt)
  int? dailyPoint;
  @JsonKey(fromJson: _toInt)
  int? weeklyPoint;
  @JsonKey(fromJson: _toInt)
  int? monthlyPoint;
  @JsonKey(fromJson: _toInt)
  int? quarterPoint;
  @JsonKey(fromJson: _toInt)
  int? yearlyPoint;
  @JsonKey(fromJson: _toInt)
  int? favNovelCnt;
  @JsonKey(fromJson: _toInt)
  int? impressionCnt;
  @JsonKey(fromJson: _toInt)
  int? reviewCnt;
  @JsonKey(fromJson: _toInt)
  int? allPoint;
  @JsonKey(fromJson: _toInt)
  int? allHyokaCnt;
  @JsonKey(fromJson: _toInt)
  int? sasieCnt;
  @JsonKey(fromJson: _toInt)
  int? kaiwaritu;
  @JsonKey(fromJson: _toInt)
  int? novelupdatedAt;
  @JsonKey(fromJson: _toInt)
  int? updatedAt;
  List<Episode>? episodes;
  @JsonKey(fromJson: _toInt)
  int? isr15;
  @JsonKey(fromJson: _toInt)
  int? isbl;
  @JsonKey(fromJson: _toInt)
  int? isgl;
  @JsonKey(fromJson: _toInt)
  int? iszankoku;
  @JsonKey(fromJson: _toInt)
  int? istensei;
  @JsonKey(fromJson: _toInt)
  int? istenni;

  Map<String, dynamic> toJson() => _$NovelInfoToJson(this);

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
