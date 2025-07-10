import 'package:flutter/material.dart';
import 'package:novelty/models/novel_content_element.dart';
import 'package:novelty/widgets/ruby_text_widget.dart';

class NovelContentView extends StatelessWidget {
  const NovelContentView({super.key, required this.elements});

  final List<NovelContentElement> elements;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;
    // ルビの高さを考慮して、行の高さを少し多めに確保する
    final strutStyle = StrutStyle(
      fontSize: defaultStyle.fontSize,
      height: 1.8, // 行間の倍率
      forceStrutHeight: true,
    );

    return RichText(
      strutStyle: strutStyle,
      text: TextSpan(
        style: defaultStyle,
        children: buildSpans(elements, defaultStyle),
      ),
    );
  }

  static List<InlineSpan> buildSpans(
    List<NovelContentElement> elements,
    TextStyle style,
  ) {
    final spans = <InlineSpan>[];
    for (final element in elements) {
      switch (element) {
        case PlainText():
          spans.add(TextSpan(text: element.text, style: style));
          break;
        case RubyText():
          spans.add(
            WidgetSpan(
              child: RubySpan(
                base: element.base,
                ruby: element.ruby,
                style: style,
              ),
            ),
          );
          break;
        case NewLine():
          spans.add(const TextSpan(text: '\n'));
          break;
      }
    }
    return spans;
  }
}
