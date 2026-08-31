import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tategaki/src/layout/tategaki_column_engine.dart';
import 'package:tategaki/src/layout/tategaki_layout.dart';
import 'package:tategaki/tategaki.dart';

void main() {
  const style = TextStyle(fontSize: 16);

  group('TategakiTextPaged', () {
    testWidgets('基本的なレンダリングができる', (tester) async {
      final elements = TategakiParser.parse('あいうえお');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TategakiTextPaged(
              elements,
              width: 300,
              height: 600,
            ),
          ),
        ),
      );

      expect(find.byType(TategakiTextPaged), findsOneWidget);
      expect(find.byType(PageView), findsOneWidget);
      // ページ内に描画（CustomPaint）が存在する
      expect(
        find.descendant(
          of: find.byType(PageView),
          matching: find.byType(CustomPaint),
        ),
        findsWidgets,
      );
    });

    testWidgets('空の要素リストでSizedBox.shrinkが表示される', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TategakiTextPaged(
              [],
              width: 300,
              height: 600,
            ),
          ),
        ),
      );

      expect(find.byType(TategakiTextPaged), findsOneWidget);
      expect(find.byType(PageView), findsNothing);
    });

    testWidgets('ページめくりでonPageChangedが呼ばれる', (tester) async {
      // 長いテキストで複数ページを生成する
      final elements = List.generate(
        2000,
        (i) => const TategakiChar('あ'),
      );
      var changedTo = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultTextStyle(
              style: style,
              child: TategakiTextPaged(
                elements,
                width: 100,
                height: 100,
                onPageChanged: (index) => changedTo = index,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(changedTo, -1);

      // 次のページへフリング（RTLなので右フリングで次へ）
      await tester.fling(find.byType(PageView), const Offset(200, 0), 1000);
      await tester.pumpAndSettle();

      expect(changedTo, 1);
    });

    testWidgets('ページ数が正しく分割される', (tester) async {
      final elements = List.generate(
        200,
        (i) => const TategakiChar('あ'),
      );

      // 期待ページ数をエンジン + partition で独立に計算する
      final engine = TategakiColumnEngine(
        elements: elements,
        maxHeight: 200,
        textStyle: style,
      );
      final columns = engine.computeAll();
      final expectedPages = TategakiLayout.partition(
        columns: columns,
        maxWidth: 100,
        height: 200,
      ).length;
      expect(expectedPages, greaterThan(1));

      var changedTo = -1;
      final pageController = PageController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultTextStyle(
              style: style,
              child: TategakiTextPaged(
                elements,
                width: 100,
                height: 200,
                onPageChanged: (index) => changedTo = index,
                controller: pageController,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 最後のページまで到達できる
      final lastPage = expectedPages - 1;
      pageController.jumpToPage(lastPage);
      await tester.pumpAndSettle();
      expect(changedTo, lastPage);
    });

    testWidgets('同じ入力で再ビルドしてもエラーなく描画される', (tester) async {
      final elements = TategakiParser.parse('あいうえおかきくけこ');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TategakiTextPaged(
              elements,
              width: 300,
              height: 600,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 同じ入力で再ビルド
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TategakiTextPaged(
              elements,
              width: 300,
              height: 600,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TategakiTextPaged), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
