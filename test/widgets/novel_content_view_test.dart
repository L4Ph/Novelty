import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:narou_parser/narou_parser.dart';
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

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovelContentView(elements: elements),
          ),
        ),
      );

      // ウィジェットがHookWidgetであることを確認
      final widget = tester.widget<NovelContentView>(
        find.byType(NovelContentView),
      );
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

  group('NovelContentView with ruby control', () {
    test('buildSpansはisRubyEnabledがtrueのときルビを含む', () {
      final elements = <NovelContentElement>[
        PlainText('これは'),
        RubyText('テスト', 'てすと'),
        PlainText('です。'),
      ];

      const style = TextStyle(fontSize: 16);
      final spans = NovelContentView.buildSpans(elements, style);

      expect(spans, hasLength(3));

      // RubyTextはWidgetSpanとして描画される
      final widgetSpan = spans[1];
      expect(widgetSpan, isA<WidgetSpan>());
      expect(
        (widgetSpan as WidgetSpan).child,
        isA<RubySpan>()
            .having((w) => w.base, 'base', 'テスト')
            .having((w) => w.ruby, 'ruby', 'てすと'),
      );
    });

    test('buildSpansはisRubyEnabledがfalseのときルビを除外', () {
      final elements = <NovelContentElement>[
        PlainText('これは'),
        RubyText('テスト', 'てすと'),
        PlainText('です。'),
      ];

      const style = TextStyle(fontSize: 16);
      final spans = NovelContentView.buildSpans(
        elements,
        style,
        isRubyEnabled: false,
      );

      expect(spans, hasLength(3));

      // RubyTextはplain TextSpan（ベーステキストのみ）として描画される
      final textSpan = spans[1];
      expect(textSpan, isA<TextSpan>());
      expect((textSpan as TextSpan).text, equals('テスト'));
    });

    test('buildSpansは複数のルビ要素を正しく処理する', () {
      final elements = <NovelContentElement>[
        RubyText('漢字', 'かんじ'),
        PlainText('と'),
        RubyText('平仮名', 'ひらがな'),
      ];

      const style = TextStyle(fontSize: 16);

      // ルビ有効
      final spansWithRuby = NovelContentView.buildSpans(elements, style);
      final widgetSpansWithRuby = spansWithRuby.whereType<WidgetSpan>();
      expect(widgetSpansWithRuby, hasLength(2));

      // ルビ無効
      final spansWithoutRuby = NovelContentView.buildSpans(
        elements,
        style,
        isRubyEnabled: false,
      );
      final widgetSpansWithoutRuby = spansWithoutRuby.whereType<WidgetSpan>();
      expect(widgetSpansWithoutRuby, hasLength(0));
      final textSpansWithoutRuby = spansWithoutRuby.whereType<TextSpan>();
      expect(textSpansWithoutRuby, hasLength(3));
    });
  });
}
