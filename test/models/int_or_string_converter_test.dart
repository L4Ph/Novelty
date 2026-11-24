import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/int_or_string_converter.dart';

void main() {
  const converter = IntOrStringConverter();

  group('IntOrStringConverter', () {
    test('passes strings through', () {
      expect(converter.fromJson('101'), equals('101'));
    });

    test('stringifies numbers', () {
      // genre is documented as an int but has been seen as a string.
      expect(converter.fromJson(101), equals('101'));
    });

    test('treats a missing value as absent', () {
      expect(converter.fromJson(null), isNull);
    });

    test('rejects a value that is neither a string nor a number', () {
      expect(
        () => converter.fromJson(<String, Object?>{'genre': '101'}),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
