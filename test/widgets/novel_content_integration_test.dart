import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/widgets/novel_content_view.dart';
import 'package:novelty/widgets/ruby_text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('NovelContent integration test with ruby setting', () {
    late ProviderContainer container;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('isRubyEnabledがtrueのときルビを表示する', (tester) async {
      final elements = <NovelContentElement>[
        RubyText('漢字', 'かんじ'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovelContentView(elements: elements),
          ),
        ),
      );

      // RubySpanウィジェットが存在することを確認
      expect(find.byType(RubySpan), findsOneWidget);
    });

    testWidgets('isRubyEnabledがfalseのときルビを表示しない', (tester) async {
      final elements = <NovelContentElement>[
        RubyText('漢字', 'かんじ'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovelContentView(
              elements: elements,
              isRubyEnabled: false,
            ),
          ),
        ),
      );

      // RubySpanウィジェットが存在しないことを確認
      expect(find.byType(RubySpan), findsNothing);

      // RichTextが存在し、ベーステキストが含まれていることを確認
      expect(find.byType(RichText), findsOneWidget);
      final richText = tester.widget<RichText>(find.byType(RichText));
      final textSpan = richText.text as TextSpan;
      expect(textSpan.toPlainText(), contains('漢字'));
    });

    testWidgets('isRubyEnabledの変更でウィジェットが再構築される', (tester) async {
      final elements = <NovelContentElement>[
        RubyText('漢字', 'かんじ'),
      ];

      // 初期状態: ルビ有効
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovelContentView(elements: elements),
          ),
        ),
      );

      expect(find.byType(RubySpan), findsOneWidget);

      // ルビ無効に変更
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovelContentView(
              elements: elements,
              isRubyEnabled: false,
            ),
          ),
        ),
      );

      expect(find.byType(RubySpan), findsNothing);

      // RichTextのテキスト内容を確認
      final richText = tester.widget<RichText>(find.byType(RichText));
      final textSpan = richText.text as TextSpan;
      expect(textSpan.toPlainText(), contains('漢字'));
    });
  });
}
