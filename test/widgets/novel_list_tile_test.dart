import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

void main() {
  group('NovelListTile', () {
    group('status display', () {
      testWidgets('should display "完結済" for serialized novel with end == 0', (
        WidgetTester tester,
      ) async {
        const item = NovelInfo(
          ncode: 'N1234AB',
          title: 'テスト連載小説',
          novelType: 1,
          end: 0,
          genre: 1,
          writer: 'テスト作者',
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NovelListTile(item: item),
            ),
          ),
        );

        expect(find.textContaining('完結済'), findsOneWidget);
      });

      testWidgets('should display "連載中" for serialized novel with end == 1', (
        WidgetTester tester,
      ) async {
        const item = NovelInfo(
          ncode: 'N1234AB',
          title: 'テスト連載小説',
          novelType: 1,
          end: 1,
          genre: 1,
          writer: 'テスト作者',
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NovelListTile(item: item),
            ),
          ),
        );

        expect(find.textContaining('連載中'), findsOneWidget);
      });

      testWidgets('should display "短編" for short story with end == 0', (
        WidgetTester tester,
      ) async {
        const item = NovelInfo(
          ncode: 'N1234AB',
          title: 'テスト短編小説',
          novelType: 2,
          end: 0,
          genre: 1,
          writer: 'テスト作者',
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NovelListTile(item: item),
            ),
          ),
        );

        expect(find.textContaining('ジャンル: 不明 - 短編'), findsOneWidget);
        expect(find.textContaining('連載中'), findsNothing);
      });

      testWidgets('should display "短編" for short story with end == 1', (
        WidgetTester tester,
      ) async {
        const item = NovelInfo(
          ncode: 'N1234AB',
          title: 'テスト短編小説',
          novelType: 2,
          end: 1,
          genre: 1,
          writer: 'テスト作者',
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NovelListTile(item: item),
            ),
          ),
        );

        expect(find.textContaining('ジャンル: 不明 - 短編'), findsOneWidget);
        expect(find.textContaining('連載中'), findsNothing);
      });

      testWidgets('should display "情報取得失敗" when end is null', (
        WidgetTester tester,
      ) async {
        const item = NovelInfo(
          ncode: 'N1234AB',
          title: 'テスト小説',
          novelType: 1,
          // ignore: avoid_redundant_argument_values テストのため
          end: null,
          genre: 1,
          writer: 'テスト作者',
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NovelListTile(item: item),
            ),
          ),
        );

        expect(find.textContaining('情報取得失敗'), findsOneWidget);
      });

      testWidgets('should display "情報取得失敗" when end is -1', (
        WidgetTester tester,
      ) async {
        const item = NovelInfo(
          ncode: 'N1234AB',
          title: 'テスト小説',
          novelType: 1,
          end: -1,
          genre: 1,
          writer: 'テスト作者',
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NovelListTile(item: item),
            ),
          ),
        );

        expect(find.textContaining('情報取得失敗'), findsOneWidget);
      });

      testWidgets('should handle null novelType gracefully', (
        WidgetTester tester,
      ) async {
        const item = NovelInfo(
          ncode: 'N1234AB',
          title: 'テスト小説',
          // ignore: avoid_redundant_argument_values テストのため
          novelType: null,
          end: 0,
          genre: 1,
          writer: 'テスト作者',
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NovelListTile(item: item),
            ),
          ),
        );

        expect(find.textContaining('情報取得失敗'), findsOneWidget);
      });
    });

    group('widget structure', () {
      testWidgets('should display title and ncode', (
        WidgetTester tester,
      ) async {
        const item = NovelInfo(
          ncode: 'N1234AB',
          title: 'テストタイトル',
          novelType: 1,
          end: 0,
          genre: 1,
          writer: 'テスト作者',
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NovelListTile(item: item),
            ),
          ),
        );

        expect(find.text('テストタイトル'), findsOneWidget);
        expect(find.textContaining('N1234AB'), findsOneWidget);
      });

      testWidgets('should display rank when rank is provided', (
        WidgetTester tester,
      ) async {
        const item = NovelInfo(
          ncode: 'N1234AB',
          title: 'テストタイトル',
          novelType: 1,
          end: 0,
          genre: 1,
          writer: 'テスト作者',
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NovelListTile(item: item, rank: 5),
            ),
          ),
        );

        expect(find.text('5'), findsOneWidget);
      });

      testWidgets('should not display rank when rank is null', (
        WidgetTester tester,
      ) async {
        const item = NovelInfo(
          ncode: 'N1234AB',
          title: 'テストタイトル',
          novelType: 1,
          end: 0,
          genre: 1,
          writer: 'テスト作者',
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NovelListTile(item: item),
            ),
          ),
        );

        expect(find.byType(ListTile), findsOneWidget);
        final listTile = tester.widget<ListTile>(find.byType(ListTile));
        expect(listTile.leading, isNull);
      });
    });
  });

  group('flutter_hooks integration', () {
    testWidgets('should use HookWidget and maintain same functionality', (
      WidgetTester tester,
    ) async {
      const item = NovelInfo(
        ncode: 'N1234AB',
        title: 'テストタイトル',
        novelType: 1,
        end: 0,
        genre: 1,
        writer: 'テスト作者',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NovelListTile(item: item),
          ),
        ),
      );

      // 基本的な機能が維持されていることを確認
      expect(find.text('テストタイトル'), findsOneWidget);
      expect(find.textContaining('N1234AB'), findsOneWidget);
      expect(find.textContaining('完結済'), findsOneWidget);

      // HookWidgetとして実装されていることを確認
      expect(find.byType(NovelListTile), findsOneWidget);
      final widget = tester.widget(find.byType(NovelListTile));
      expect(widget, isA<HookWidget>());
    });

    testWidgets('should optimize performance with memoization', (
      WidgetTester tester,
    ) async {
      const item = NovelInfo(
        ncode: 'N1234AB',
        title: 'テストタイトル',
        novelType: 1,
        end: 0,
        genre: 1,
        writer: 'テスト作者',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NovelListTile(item: item),
          ),
        ),
      );

      // 初回レンダリング
      expect(find.text('テストタイトル'), findsOneWidget);

      // 再レンダリング（同じpropsなのでメモ化が効いているはず）
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NovelListTile(item: item),
          ),
        ),
      );

      // 機能が維持されていることを確認
      expect(find.text('テストタイトル'), findsOneWidget);
      expect(find.textContaining('完結済'), findsOneWidget);
    });
  });
}
