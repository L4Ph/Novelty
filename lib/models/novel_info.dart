import 'package:json_annotation/json_annotation.dart';

part 'novel_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NovelInfo {
  final String? title;
  final String? ncode;
  final String? writer;
  final String? story;
  final int? novelType;
  final int? end;
  final int? generalAllNo;
  final int? genre;
  final String? keyword;
  final String? generalFirstup;
  final String? generalLastup;
  final int? globalPoint;
  final int? dailyPoint;
  final int? weeklyPoint;
  final int? monthlyPoint;
  final int? quarterPoint;
  final int? yearlyPoint;
  final int? favNovelCnt;
  final int? impressionCnt;
  final int? reviewCnt;
  final int? allPoint;
  final int? allHyokaCnt;
  final int? sasieCnt;
  final int? kaiwaritu;
  final int? novelupdatedAt;
  final int? updatedAt;
  final List<dynamic>? episodes;

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

  Map<String, dynamic> toJson() => _$NovelInfoToJson(this);
}
