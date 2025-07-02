import 'package:json_annotation/json_annotation.dart';

part 'episode.g.dart';

@JsonSerializable()
class Episode {
  final String title;
  final String ncode;
  final int index;
  final String body;
  final String novelUpdatedAt;

  Episode({
    required this.title,
    required this.ncode,
    required this.index,
    required this.body,
    required this.novelUpdatedAt,
  });

  factory Episode.fromJson(Map<String, dynamic> json) =>
      _$EpisodeFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}
