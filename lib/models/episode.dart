import 'package:json_annotation/json_annotation.dart';

part 'episode.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Episode {
  Episode({this.title, this.ncode, this.index, this.body, this.novelUpdatedAt});

  factory Episode.fromJson(Map<String, dynamic> json) =>
      _$EpisodeFromJson(json);
  final String? title;
  final String? ncode;
  final int? index;
  final String? body;
  final String? novelUpdatedAt;

  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}
