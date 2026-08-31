import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tategaki/src/layout/tategaki_column_engine.dart';
import 'package:tategaki/src/layout/tategaki_layout.dart';
import 'package:tategaki/tategaki.dart';

/// 再ビルドをトリガーするためのヘルパーウィジェット
class _Rebuildable extends StatefulWidget {
  const _Rebuildable({required this.elements, required this.height});

  final List<TategakiElement> elements;
  final double height;

  @override
  State<_Rebuildable> createState() => _RebuildableState();
}

class _RebuildableState extends State<_Rebuildable> {
  void rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TategakiText(
          widget.elements,
          height: widget.height,
        ),
      ),
    );
  }
}

void main() {
  const style = TextStyle(fontSize: 16);

  group('TategakiText (遅延レンダリング)', () {
    testWidgets('基本的なレンダリングができる', (tester) async {
      final elements = TategakiParser.parse('あいうえお');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TategakiText(elements, height: 600),
          ),
        ),
      );

      final customPaint = find.descendant(
        of: find.byType(TategakiText),
        matching: find.byType(CustomPaint),
      );
      expect(customPaint, findsWidgets);
    });

    testWidgets('外側のGlobalKeyをListViewと共有しない', (tester) async {
      final key = GlobalKey();
      final elements = TategakiParser.parse('あいうえお');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TategakiText(elements, key: key, height: 600),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(key.currentWidget, isA<TategakiText>());
      final listView = tester.widget<ListView>(
        find.descendant(
          of: find.byType(TategakiText),
          matching: find.byType(ListView),
        ),
      );
      expect(listView.key, isA<PageStorageKey<Object>>());
      expect(identical(listView.key, key), isFalse);
    });

    testWidgets('空の要素リストでSizedBox.shrinkが表示される', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TategakiText([], height: 600),
          ),
        ),
      );

      expect(find.byType(TategakiText), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);
      // ListView が存在しない
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('可視列のみがビルドされる（遅延レンダリング）', (tester) async {
      final elements = List.generate(
        2000,
        (i) => const TategakiChar('あ'),
      );
      const height = 100.0;

      // 総列数をエンジンで計算（独立した情報源）
      final engine = TategakiColumnEngine(
        elements: elements,
        maxHeight: height,
        textStyle: style,
      );
      final totalColumns = engine.computeAll().length;
      expect(totalColumns, greaterThan(50));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TategakiText(elements, height: height),
          ),
        ),
      );

      final customPaint = find.descendant(
        of: find.byType(TategakiText),
        matching: find.byType(CustomPaint),
      );
      final builtCount = tester.widgetList(customPaint).length;

      // 可視域 + cacheExtent の列だけがビルドされる
      expect(builtCount, greaterThan(0));
      expect(builtCount, lessThan(totalColumns));
    });

    testWidgets('同じ入力で再ビルドしてもレンダリングが維持される', (tester) async {
      final elements = TategakiParser.parse('あいうえおかきくけこ');

      await tester.pumpWidget(
        _Rebuildable(elements: elements, height: 600),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TategakiText), findsOneWidget);
      final before = tester
          .widgetList(
            find.descendant(
              of: find.byType(TategakiText),
              matching: find.byType(CustomPaint),
            ),
          )
          .length;

      // 親ウィジェットを再ビルド
      (tester.state(find.byType(_Rebuildable)) as _RebuildableState).rebuild();
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(TategakiText), findsOneWidget);
      final after = tester
          .widgetList(
            find.descendant(
              of: find.byType(TategakiText),
              matching: find.byType(CustomPaint),
            ),
          )
          .length;
      expect(after, before);
    });

    testWidgets('列間にcolumnSpacingのスペースが入る', (tester) async {
      // 高さを小さくして複数列を生成する
      final elements = List.generate(
        30,
        (i) => const TategakiChar('あ'),
      );
      const height = 100.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TategakiText(elements, height: height),
          ),
        ),
      );

      final paints = find.descendant(
        of: find.byType(TategakiText),
        matching: find.byType(CustomPaint),
      );
      expect(tester.widgetList(paints).length, greaterThan(1));

      // 隣接する列の間隔が columnSpacing になっている
      final firstRect = tester.getRect(paints.at(0));
      final secondRect = tester.getRect(paints.at(1));
      final gap = secondRect.left - firstRect.right;
      expect(gap, TategakiLayout.columnSpacing);
    });

    testWidgets('高さが変わると列構成が再計算される', (tester) async {
      final elements = TategakiParser.parse('あいうえおかきくけこ');

      // 高さ 600 → 1列
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TategakiText(elements, height: 600),
          ),
        ),
      );
      final tallCount = tester
          .widgetList(
            find.descendant(
              of: find.byType(TategakiText),
              matching: find.byType(CustomPaint),
            ),
          )
          .length;

      // 高さ 50 → 複数列
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TategakiText(elements, height: 50),
          ),
        ),
      );
      final shortCount = tester
          .widgetList(
            find.descendant(
              of: find.byType(TategakiText),
              matching: find.byType(CustomPaint),
            ),
          )
          .length;

      expect(shortCount, greaterThan(tallCount));
    });
  });
}
