import 'package:json_annotation/json_annotation.dart';

/// Converts a JSON value to `int?`.
///
/// The narou API returns most numeric fields as integers, but some were
/// historically strings, so both are accepted. A value that is present and not
/// empty yet cannot be parsed is treated as a shape change and reported,
/// rather than silently becoming null.
class StringToIntConverter implements JsonConverter<int?, Object?> {
  /// Constructor.
  const StringToIntConverter();

  @override
  int? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    if (json is int) {
      return json;
    }
    if (json is double) {
      return json.toInt();
    }
    if (json is String) {
      // The API uses '' for "no value" on unused fields.
      if (json.isEmpty) {
        return null;
      }
      final parsed = int.tryParse(json);
      if (parsed == null) {
        throw FormatException('Not an integer: "$json"');
      }
      return parsed;
    }
    throw FormatException('Not an integer: ${json.runtimeType}');
  }

  @override
  Object? toJson(int? object) {
    return object;
  }
}
