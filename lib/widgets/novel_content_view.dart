import 'package:flutter/material.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/widgets/kenten_text_widget.dart';
import 'package:novelty/widgets/ruby_text_widget.dart';

/// 小説のコンテンツを表示するウィジェット。
class NovelContentView extends StatefulWidget {
  /// コンストラクタ。
  const NovelContentView({
    required this.elements,
    this.isRubyEnabled = true,
    super.key,
  });

  /// 小説のコンテンツ要素のリスト。
  final List<NovelContentElement> elements;

  /// ルビの表示設定。
  final bool isRubyEnabled;

  /// 小説のコンテンツ要素から`InlineSpan`のリストを生成するヘルパーメソッド。
  static List<InlineSpan> buildSpans(
    List<NovelContentElement> elements,
    TextStyle style, {
    bool isRubyEnabled = true,
  }) {
    final spans = <InlineSpan>[];
    for (final element in elements) {
      switch (element) {
        case PlainText():
          spans.add(TextSpan(text: element.text, style: style));
        case RubyText():
          if (isRubyEnabled) {
            // ルビ有効時: WidgetSpanを使用してルビを表示
            spans.add(
              WidgetSpan(
                child: RubySpan(
                  base: element.base,
                  ruby: element.ruby,
                  style: style,
                ),
              ),
            );
          } else {
            // ルビ無効時: ベーステキストのみ表示
            spans.add(TextSpan(text: element.base, style: style));
          }
        case Kenten():
          // 横書きでは各文字の上に点を表示する
          spans.add(
            WidgetSpan(
              child: KentenSpan(
                base: element.base,
                mark: element.mark,
                style: style,
              ),
            ),
          );
        case NewLine():
          spans.add(const TextSpan(text: '\n'));
      }
    }
    return spans;
  }

  @override
  State<NovelContentView> createState() => _NovelContentViewState();
}

class _NovelContentViewState extends State<NovelContentView> {
  late List<InlineSpan> _spans;
  List<NovelContentElement>? _spansFor;
  TextStyle? _spansStyle;
  bool? _spansRubyEnabled;

  /// span生成は要素・スタイル・ルビ設定が変わった時だけ行う。
  List<InlineSpan> _buildSpans(TextStyle style) {
    if (identical(_spansFor, widget.elements) &&
        _spansStyle == style &&
        _spansRubyEnabled == widget.isRubyEnabled) {
      return _spans;
    }
    _spansFor = widget.elements;
    _spansStyle = style;
    _spansRubyEnabled = widget.isRubyEnabled;
    return _spans = NovelContentView.buildSpans(
      widget.elements,
      style,
      isRubyEnabled: widget.isRubyEnabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;

    // ルビの高さを考慮して、行の高さを少し多めに確保する
    // ルビ無効時は StrutStyle を使わず、lineHeight をそのまま反映
    final strutStyle = widget.isRubyEnabled
        ? StrutStyle(
            fontSize: defaultStyle.fontSize,
            height: 1.8, // 行間の倍率
            forceStrutHeight: true,
          )
        : null;

    return RichText(
      strutStyle: strutStyle,
      text: TextSpan(
        style: defaultStyle,
        children: _buildSpans(defaultStyle),
      ),
    );
  }
}
