import 'package:flutter/material.dart';
import 'package:novelty/models/novel_content_element.dart';
import 'package:novelty/widgets/ruby_text_widget.dart';

class NovelContentView extends StatelessWidget {
  const NovelContentView({super.key, required this.elements});

  final List<NovelContentElement> elements;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;
    return RichText(
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
              alignment: PlaceholderAlignment.middle,
              child: RubyTextWidget(
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
