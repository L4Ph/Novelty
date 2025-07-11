// lib/models/novel_content_element.dart

sealed class NovelContentElement {
  const NovelContentElement();

  Map<String, dynamic> toJson();

  factory NovelContentElement.fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case 'plain':
        return PlainText(json['text'] as String);
      case 'ruby':
        return RubyText(json['base'] as String, json['ruby'] as String);
      case 'newline':
        return NewLine();
      default:
        throw ArgumentError('Unknown type: ${json['type']}');
    }
  }
}

class PlainText extends NovelContentElement {
  const PlainText(this.text);
  final String text;

  @override
  Map<String, dynamic> toJson() => {'type': 'plain', 'text': text};
}

class RubyText extends NovelContentElement {
  const RubyText(this.base, this.ruby);
  final String base;
  final String ruby;

  @override
  Map<String, dynamic> toJson() => {'type': 'ruby', 'base': base, 'ruby': ruby};
}

class NewLine extends NovelContentElement {
  const NewLine();

  @override
  Map<String, dynamic> toJson() => {'type': 'newline'};
}
