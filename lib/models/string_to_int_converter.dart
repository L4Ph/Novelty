import 'package:freezed_annotation/freezed_annotation.dart';

class StringToIntConverter implements JsonConverter<int?, Object?> {
  const StringToIntConverter();

  @override
  int? fromJson(Object? json) {
    if (json is int) {
      return json;
    }
    if (json is double) {
      return json.toInt();
    }
    if (json is String) {
      return int.tryParse(json);
    }
    return null;
  }

  @override
  Object? toJson(int? object) {
    return object;
  }
}
