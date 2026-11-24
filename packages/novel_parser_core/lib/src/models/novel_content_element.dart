import 'dart:convert';

import 'package:meta/meta.dart';

/// A parsed piece of an episode body.
///
/// Persisted as JSON, so [toJson] and [NovelContentElement.fromJson] define the
/// on-disk format. `test/novel_content_element_test.dart` pins it with literals.
sealed class NovelContentElement {
  const NovelContentElement();

  /// Plain text.
  const factory NovelContentElement.plainText(String text) = PlainText;

  /// Text with ruby annotation: [base] carries [ruby].
  const factory NovelContentElement.rubyText(String base, String ruby) =
      RubyText;

  /// Text with emphasis marks: [base] carries [mark].
  const factory NovelContentElement.kenten(String base, String mark) = Kenten;

  /// A line break.
  const factory NovelContentElement.newLine() = NewLine;

  /// Restores an element from its persisted form.
  factory NovelContentElement.fromJson(Map<String, dynamic> json) {
    return switch (json['runtimeType']) {
      'plainText' => PlainText.fromJson(json),
      'rubyText' => RubyText.fromJson(json),
      'kenten' => Kenten.fromJson(json),
      'newLine' => NewLine.fromJson(json),
      final other => throw FormatException(
        'Unknown NovelContentElement runtimeType: $other',
      ),
    };
  }

  /// The discriminator written to storage.
  String get type;

  /// The persisted form.
  Map<String, dynamic> toJson();
}

/// Plain text.
@immutable
final class PlainText extends NovelContentElement {
  /// Creates plain text.
  const PlainText(this.text);

  /// Restores from storage.
  factory PlainText.fromJson(Map<String, dynamic> json) {
    final text = json['text'];
    if (text is! String) {
      throw FormatException('PlainText.text is not a string: $text');
    }
    return PlainText(text);
  }

  /// The text.
  final String text;

  @override
  String get type => 'plainText';

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'text': text,
    'runtimeType': type,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PlainText && other.text == text;

  @override
  int get hashCode => text.hashCode;

  @override
  String toString() => 'PlainText(text: $text)';
}

/// Text with ruby annotation.
@immutable
final class RubyText extends NovelContentElement {
  /// Creates ruby text.
  const RubyText(this.base, this.ruby);

  /// Restores from storage.
  factory RubyText.fromJson(Map<String, dynamic> json) {
    final base = json['base'];
    final ruby = json['ruby'];
    if (base is! String || ruby is! String) {
      throw FormatException('RubyText has a non-string field: $json');
    }
    return RubyText(base, ruby);
  }

  /// The text the ruby is attached to.
  final String base;

  /// The ruby annotation.
  final String ruby;

  @override
  String get type => 'rubyText';

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'base': base,
    'ruby': ruby,
    'runtimeType': type,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RubyText && other.base == base && other.ruby == ruby;

  @override
  int get hashCode => Object.hash(base, ruby);

  @override
  String toString() => 'RubyText(base: $base, ruby: $ruby)';
}

/// Text with emphasis marks.
@immutable
final class Kenten extends NovelContentElement {
  /// Creates emphasised text.
  const Kenten(this.base, this.mark);

  /// Restores from storage.
  factory Kenten.fromJson(Map<String, dynamic> json) {
    final base = json['base'];
    final mark = json['mark'];
    if (base is! String || mark is! String) {
      throw FormatException('Kenten has a non-string field: $json');
    }
    return Kenten(base, mark);
  }

  /// The text the marks are attached to.
  final String base;

  /// The mark character.
  final String mark;

  @override
  String get type => 'kenten';

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'base': base,
    'mark': mark,
    'runtimeType': type,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Kenten && other.base == base && other.mark == mark;

  @override
  int get hashCode => Object.hash(base, mark);

  @override
  String toString() => 'Kenten(base: $base, mark: $mark)';
}

/// A line break.
@immutable
final class NewLine extends NovelContentElement {
  /// Creates a line break.
  const NewLine();

  /// Restores from storage.
  factory NewLine.fromJson(Map<String, dynamic> _) => const NewLine();

  @override
  String get type => 'newLine';

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{'runtimeType': type};

  @override
  bool operator ==(Object other) => other is NewLine;

  @override
  int get hashCode => (NewLine).hashCode;

  @override
  String toString() => 'NewLine()';
}

/// Helpers for a list of elements.
extension NovelContentListExtension on List<NovelContentElement> {
  /// Encodes the list as a JSON string.
  String toJsonString() {
    return json.encode(map((e) => e.toJson()).toList());
  }
}
