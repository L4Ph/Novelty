import 'package:json_annotation/json_annotation.dart';

part 'novel_info.g.dart';

@JsonSerializable()
class NovelInfo {
  final String title;
  final String ncode;
  final String writer;
  final String story;
  final int novelType;
  final int end;
  final int generalAllNo;
  final int genre;
  final String keyword;
  final String generalFirstup;
  final String generalLastup;
  final int globalPoint;
  final int dailyPoint;
  final int weeklyPoint;
  final int monthlyPoint;
  final int quarterPoint;
  final int yearlyPoint;
  final int favNovelCnt;
  final int impressionCnt;
  final int reviewCnt;
  final int allPoint;
  final int allHyokaCnt;
  final int sasieCnt;
  final int kaiwaritu;
  final int novelupdatedAt;
  final int updatedAt;
  final List<dynamic>? episodes;

  NovelInfo({
    required this.title,
    required this.ncode,
    required this.writer,
    required this.story,
    required this.novelType,
    required this.end,
    required this.generalAllNo,
    required this.genre,
    required this.keyword,
    required this.generalFirstup,
    required this.generalLastup,
    required this.globalPoint,
    required this.dailyPoint,
    required this.weeklyPoint,
    required this.monthlyPoint,
    required this.quarterPoint,
    required this.yearlyPoint,
    required this.favNovelCnt,
    required this.impressionCnt,
    required this.reviewCnt,
    required this.allPoint,
    required this.allHyokaCnt,
    required this.sasieCnt,
    required this.kaiwaritu,
    required this.novelupdatedAt,
    required this.updatedAt,
    this.episodes,
  });

  factory NovelInfo.fromJson(Map<String, dynamic> json) =>
      _$NovelInfoFromJson(json);

  Map<String, dynamic> toJson() => _$NovelInfoToJson(this);
}
