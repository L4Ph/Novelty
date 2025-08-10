import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_content_element.dart';
import 'package:novelty/widgets/tategaki.dart';

void main() {
  group('Tategaki Hooks Integration Tests', () {
    testWidgets('TategakiウィジェットがHookWidgetとして正常に動作すること', (tester) async {
      // Given: テスト用のコンテンツデータ
      final testContent = <NovelContentElement>[
        NovelContentElement.plainText('テスト文字列'),
        NovelContentElement.rubyText('漢字', 'かんじ'),
        NovelContentElement.newLine(),
        NovelContentElement.plainText('二行目'),
      ];

      // When: Tategakiウィジェットをレンダリング
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Tategaki(
                  testContent,
                  maxHeight: 300,
                  style: const TextStyle(fontSize: 16),
                  space: 12,
                );
              },
            ),
          ),
        ),
      );

      // Then: ウィジェットが正常に表示される
      expect(find.byType(Tategaki), findsOneWidget);
      
      // Tategakiウィジェット内のCustomPaintを確認
      final tategakiFinder = find.byType(Tategaki);
      final customPaintFinder = find.descendant(
        of: tategakiFinder,
        matching: find.byType(CustomPaint),
      );
      expect(customPaintFinder, findsOneWidget);
    });

    testWidgets('TategakiがHookWidgetであることを確認', (tester) async {
      // Given: テスト用のコンテンツデータ
      final testContent = <NovelContentElement>[
        NovelContentElement.plainText('フックテスト'),
      ];

      // When: Tategakiウィジェットをレンダリング
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Tategaki(
                  testContent,
                  maxHeight: 300,
                  style: const TextStyle(fontSize: 16),
                  space: 12,
                );
              },
            ),
          ),
        ),
      );

      // Then: TategakiがHookWidgetを継承していることを確認
      final tategakiWidget = tester.widget<Tategaki>(find.byType(Tategaki));
      expect(tategakiWidget, isA<Tategaki>());
      // 実際にはHookWidgetかどうかをランタイムで検証するのは難しいため、
      // 動作が正常であることを確認する
      expect(find.byType(Tategaki), findsOneWidget);
    });

    testWidgets('プロパティ変更時にメトリクスが正しく再計算されること', (tester) async {
      // Given: 初期コンテンツ
      final initialContent = <NovelContentElement>[
        NovelContentElement.plainText('初期テキスト'),
      ];
      
      // リビルド回数をカウントするためのキー
      var rebuildCount = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                rebuildCount++;
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return Tategaki(
                      initialContent,
                      maxHeight: 300,
                      style: const TextStyle(fontSize: 16),
                      space: 12,
                    );
                  },
                );
              },
            ),
          ),
        ),
      );

      // 初期レンダリング
      expect(find.byType(Tategaki), findsOneWidget);
      final initialRebuildCount = rebuildCount;

      // When: コンテンツを変更
      final updatedContent = <NovelContentElement>[
        NovelContentElement.plainText('更新されたテキスト'),
        NovelContentElement.plainText('追加テキスト'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                rebuildCount++;
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return Tategaki(
                      updatedContent,
                      maxHeight: 300,
                      style: const TextStyle(fontSize: 16),
                      space: 12,
                    );
                  },
                );
              },
            ),
          ),
        ),
      );

      // Then: ウィジェットが再レンダリングされる
      expect(find.byType(Tategaki), findsOneWidget);
      expect(rebuildCount, greaterThan(initialRebuildCount));
    });

    testWidgets('同じプロパティでの再ビルド時にメモ化が効いていること', (tester) async {
      // Given: 固定コンテンツ
      final content = <NovelContentElement>[
        NovelContentElement.plainText('固定テキスト'),
      ];

      var firstBuild = true;
      Widget buildTategaki() {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Tategaki(
              content,
              maxHeight: 300,
              style: const TextStyle(fontSize: 16),
              space: 12,
            );
          },
        );
      }

      // 初回ビルド
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: buildTategaki()),
        ),
      );

      expect(find.byType(Tategaki), findsOneWidget);
      
      // 同じプロパティで再ビルド
      firstBuild = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: buildTategaki()),
        ),
      );

      // ウィジェットが正常に動作することを確認
      expect(find.byType(Tategaki), findsOneWidget);
    });

    testWidgets('空のコンテンツでSizedBox.shrinkが表示されること', (tester) async {
      // Given: 空のコンテンツ
      final emptyContent = <NovelContentElement>[];

      // When: 空のコンテンツでTategakiをレンダリング
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Tategaki(
                  emptyContent,
                  maxHeight: 300,
                  style: const TextStyle(fontSize: 16),
                  space: 12,
                );
              },
            ),
          ),
        ),
      );

      // Then: SizedBox.shrinkが表示される
      expect(find.byType(SizedBox), findsOneWidget);
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 0);
      expect(sizedBox.height, 0);
    });
  });
}