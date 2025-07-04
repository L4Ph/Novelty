import 'package:json_annotation/json_annotation.dart';

part 'ranking_response.g.dart';

@JsonSerializable()
class RankingResponse {
  RankingResponse({
    this.rank,
    this.pt,
    required this.ncode,
    this.title,
    this.novelType,
    this.end,
    this.genre,
    this.writer,
    this.story,
    this.userId,
    this.generalAllNo,
    this.keyword,
  });

  factory RankingResponse.fromJson(Map<String, dynamic> json) =>
      _$RankingResponseFromJson(json);
  final int? rank;
  final int? pt;
  final String ncode;
  final String? title;
  @JsonKey(name: 'novel_type')
  final int? novelType;
  final int? end;
  final int? genre;
  final String? writer;
  final String? story;
  @JsonKey(name: 'userid')
  final int? userId;
  @JsonKey(name: 'general_all_no')
  final int? generalAllNo;
  final String? keyword;

  Map<String, dynamic> toJson() => _$RankingResponseToJson(this);
}
