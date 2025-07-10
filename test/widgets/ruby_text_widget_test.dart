import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/widgets/ruby_text_widget.dart';

void main() {
  testWidgets('RubyTextWidgetが正しく表示されるか', (WidgetTester tester) async {
    const base = '漢字';
    const ruby = 'かんじ';
    const style = TextStyle(fontSize: 20, fontFamily: 'Roboto');

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DefaultTextStyle(
            style: style,
            child: RubySpan(
              base: base,
              ruby: ruby,
              style: style,
            ),
          ),
        ),
      ),
    );

    // RichTextウィジェットを直接探す
    final richTextWidgets = tester
        .widgetList<RichText>(find.byType(RichText))
        .toList();

    // ベーステキストとルビテキストのRichTextがそれぞれ1つずつ存在することを確認
    expect(richTextWidgets, hasLength(2));

    // 順番が不定なので、テキスト内容でソートする
    richTextWidgets.sort(
      (a, b) =>
          (a.text as TextSpan).text!.compareTo((b.text as TextSpan).text!),
    );

    final baseRichText = richTextWidgets.firstWhere(
      (w) => (w.text as TextSpan).text == base,
    );
    final rubyRichText = richTextWidgets.firstWhere(
      (w) => (w.text as TextSpan).text == ruby,
    );

    // スタイルが適用されていることを確認
    expect(baseRichText.text.style?.fontSize, style.fontSize);
    expect(rubyRichText.text.style?.fontSize, style.fontSize! * 0.5);
  });
}
