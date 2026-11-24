import 'package:json_annotation/json_annotation.dart';

/// Converts a JSON value to a `String?`.
///
/// The narou API's `genre` is documented as an integer but some works return it
/// as a string, so both are accepted and normalised to a string. Any other type
/// is treated as a shape change and reported.
class IntOrStringConverter implements JsonConverter<String?, Object?> {
  /// Constructor.
  const IntOrStringConverter();

  @override
  String? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    if (json is String) {
      return json;
    }
    if (json is num) {
      return json.toString();
    }
    throw FormatException('Neither a string nor a number: ${json.runtimeType}');
  }

  @override
  Object? toJson(String? object) {
    return object;
  }
}
