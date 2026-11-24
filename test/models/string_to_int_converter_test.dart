import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/string_to_int_converter.dart';

void main() {
  const converter = StringToIntConverter();

  group('StringToIntConverter', () {
    test('passes integers through', () {
      expect(converter.fromJson(42), equals(42));
    });

    test('truncates doubles', () {
      expect(converter.fromJson(42.9), equals(42));
    });

    test('parses numeric strings', () {
      expect(converter.fromJson('42'), equals(42));
    });

    test('treats a missing value as absent', () {
      expect(converter.fromJson(null), isNull);
    });

    test('treats an empty string as absent', () {
      // The API uses '' for "no value" on unused fields.
      expect(converter.fromJson(''), isNull);
    });

    test('rejects a non-numeric string', () {
      // This is the shape change worth hearing about: a date string used to
      // become null silently.
      expect(
        () => converter.fromJson('2026-03-22 23:00:26'),
        throwsA(isA<FormatException>()),
      );
    });

    test('rejects a value of an unexpected type', () {
      expect(
        () => converter.fromJson(<String, Object?>{'value': 1}),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
