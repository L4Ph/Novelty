import 'package:json_annotation/json_annotation.dart';

part 'novel_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NovelInfo {
  String? title;
  String? ncode;
  String? writer;
  String? story;
  int? novelType;
  int? end;
  int? generalAllNo;
  int? genre;
  String? keyword;
  String? generalFirstup;
  String? generalLastup;
  int? globalPoint;
  int? dailyPoint;
  int? weeklyPoint;
  int? monthlyPoint;
  int? quarterPoint;
  int? yearlyPoint;
  int? favNovelCnt;
  int? impressionCnt;
  int? reviewCnt;
  int? allPoint;
  int? allHyokaCnt;
  int? sasieCnt;
  int? kaiwaritu;
  int? novelupdatedAt;
  int? updatedAt;
  List<Map<String, dynamic>>? episodes;

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
  });

  factory NovelInfo.fromJson(Map<String, dynamic> json) =>
      _$NovelInfoFromJson(json);

  Map<String, dynamic> toJson() => {
        'ncode': ncode,
        'title': title,
        'writer': writer,
        'story': story,
        'genre': genre,
        'keyword': keyword,
        'general_all_no': generalAllNo,
        'end': end,
        'novel_type': novelType,
      };
}
