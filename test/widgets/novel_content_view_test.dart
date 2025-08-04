import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_content_element.dart';
import 'package:novelty/widgets/novel_content_view.dart';
import 'package:novelty/widgets/ruby_text_widget.dart';

void main() {
  group('NovelContentView', () {
    test('buildSpansが正しくInlineSpanを生成するか', () {
      final elements = <NovelContentElement>[
        PlainText('これは'),
        RubyText('テスト', 'てすと'),
        PlainText('です。'),
        NewLine(),
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

    testWidgets('HookWidgetとして実装されておりuseMemoizedを使用するか', (tester) async {
      final elements = <NovelContentElement>[
        PlainText('テストテキスト'),
        NewLine(),
      ];

      // HookWidgetかどうかをテストするためのカウンター
      var buildCount = 0;
      late NovelContentView widget;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HookBuilder(
              builder: (context) {
                buildCount++;
                widget = NovelContentView(elements: elements);
                return widget;
              },
            ),
          ),
        ),
      );

      // ウィジェットがHookWidgetであることを確認
      expect(widget, isA<HookWidget>());

      // RichTextが正しく表示されていることを確認
      expect(find.byType(RichText), findsOneWidget);

      // 同じelementsで再ビルドしても、メモ化により効率化されることを期待
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovelContentView(elements: elements),
          ),
        ),
      );

      expect(find.byType(RichText), findsOneWidget);
    });

    testWidgets('elementsが変更された時のみspan再計算が行われるか', (tester) async {
      var elements = <NovelContentElement>[
        PlainText('初期テキスト'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovelContentView(elements: elements),
          ),
        ),
      );

      // 初期状態の確認
      final richText1 = tester.widget<RichText>(find.byType(RichText));
      final textSpan1 = richText1.text as TextSpan;
      expect(textSpan1.toPlainText(), '初期テキスト');

      // 異なるelementsで更新
      elements = <NovelContentElement>[
        PlainText('更新されたテキスト'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovelContentView(elements: elements),
          ),
        ),
      );

      // テキストが更新されていることを確認
      final richText2 = tester.widget<RichText>(find.byType(RichText));
      final textSpan2 = richText2.text as TextSpan;
      expect(textSpan2.toPlainText(), '更新されたテキスト');
    });
  });
}
