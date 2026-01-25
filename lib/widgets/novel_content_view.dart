import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/widgets/ruby_text_widget.dart';

/// 小説のコンテンツを表示するウィジェット。
class NovelContentView extends HookWidget {
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

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;

    // ルビの高さを考慮して、行の高さを少し多めに確保する
    // スタイル計算をメモ化してパフォーマンスを向上
    final strutStyle = useMemoized(
      () => StrutStyle(
        fontSize: defaultStyle.fontSize,
        height: 1.8, // 行間の倍率
        forceStrutHeight: true,
      ),
      [defaultStyle.fontSize],
    );

    // span生成処理をメモ化してelementsが変更された時のみ再計算
    final spans = useMemoized(
      () => buildSpans(elements, defaultStyle, isRubyEnabled: isRubyEnabled),
      [elements, defaultStyle, isRubyEnabled],
    );

    return RichText(
      strutStyle: strutStyle,
      text: TextSpan(
        style: defaultStyle,
        children: spans,
      ),
    );
  }

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
        case NewLine():
          spans.add(const TextSpan(text: '\n'));
      }
    }
    return spans;
  }
}
