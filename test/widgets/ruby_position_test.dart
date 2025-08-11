import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_content_element.dart';
import 'package:novelty/widgets/tategaki.dart';

void main() {
  group('縦書きルビ位置テスト', () {
    testWidgets('ルビ付きテキストとプレーンテキストの位置が正しく配置されること', (tester) async {
      // Given: ルビ付きテキストとプレーンテキストを含むコンテンツ
      final testContent = <NovelContentElement>[
        NovelContentElement.plainText('普通'),
        NovelContentElement.rubyText('漢字', 'かんじ'),
        NovelContentElement.plainText('普通'),
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
                );
              },
            ),
          ),
        ),
      );

      // Then: ウィジェットが正常に表示される
      expect(find.byType(Tategaki), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
      
      // Tategaki内のCustomPaintを確認
      final tategakiFinder = find.byType(Tategaki);
      final customPaintFinder = find.descendant(
        of: tategakiFinder,
        matching: find.byType(CustomPaint),
      );
      expect(customPaintFinder, findsOneWidget);
    });

    testWidgets('ルビのみのテキストが正しく表示されること', (tester) async {
      // Given: ルビ付きテキストのみのコンテンツ
      final testContent = <NovelContentElement>[
        NovelContentElement.rubyText('漢字', 'かんじ'),
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
                );
              },
            ),
          ),
        ),
      );

      // Then: ウィジェットが正常に表示される
      expect(find.byType(Tategaki), findsOneWidget);
      
      // Tategaki内のCustomPaintを確認
      final tategakiFinder = find.byType(Tategaki);
      final customPaintFinder = find.descendant(
        of: tategakiFinder,
        matching: find.byType(CustomPaint),
      );
      expect(customPaintFinder, findsOneWidget);
    });

    testWidgets('複数のルビ付きテキストが正しく表示されること', (tester) async {
      // Given: 複数のルビ付きテキストを含むコンテンツ
      final testContent = <NovelContentElement>[
        NovelContentElement.rubyText('漢字', 'かんじ'),
        NovelContentElement.rubyText('読書', 'どくしょ'),
        NovelContentElement.rubyText('図書館', 'としょかん'),
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
                );
              },
            ),
          ),
        ),
      );

      // Then: ウィジェットが正常に表示される
      expect(find.byType(Tategaki), findsOneWidget);
      
      // Tategaki内のCustomPaintを確認  
      final tategakiFinder = find.byType(Tategaki);
      final customPaintFinder = find.descendant(
        of: tategakiFinder,
        matching: find.byType(CustomPaint),
      );
      expect(customPaintFinder, findsOneWidget);
    });
  });
}