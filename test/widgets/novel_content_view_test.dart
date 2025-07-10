import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_content_element.dart';
import 'package:novelty/widgets/novel_content_view.dart';
import 'package:novelty/widgets/ruby_text_widget.dart';

void main() {
  test('NovelContentView.buildSpansが正しくInlineSpanを生成するか', () {
    final elements = <NovelContentElement>[
      const PlainText('これは'),
      const RubyText('テスト', 'てすと'),
      const PlainText('です。'),
      const NewLine(),
    ];

    const style = TextStyle(fontSize: 16);
    final spans = NovelContentView.buildSpans(elements, style);

    expect(spans, hasLength(4));

    // 1. PlainText
    expect(spans[0], isA<TextSpan>().having((s) => s.text, 'text', 'これは'));

    // 2. RubyText (WidgetSpan)
    final widgetSpan = spans[1];
    expect(widgetSpan, isA<WidgetSpan>());
    expect(
      (widgetSpan as WidgetSpan).child,
      isA<RubySpan>()
          .having((w) => w.base, 'base', 'テスト')
          .having((w) => w.ruby, 'ruby', 'てすと'),
    );

    // 3. PlainText
    expect(spans[2], isA<TextSpan>().having((s) => s.text, 'text', 'です。'));

    // 4. NewLine
    expect(spans[3], isA<TextSpan>().having((s) => s.text, 'text', '\n'));
  });
}
