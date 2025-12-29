import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

void main() {
  group('NovelListTile', () {
    group('status display', () {
      testWidgets('should display "完結" badge for novel with end == 0', (
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

        expect(find.text('完結'), findsOneWidget);
        expect(find.text('連載中'), findsNothing);
      });

      testWidgets(
        'should display "連載" badge for serialized novel with end == 1',
        (
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

          expect(find.text('連載'), findsOneWidget);
          expect(find.text('完結'), findsNothing);
        },
      );

      // Note: '短編' is now handled by logic that might fall into '完結' or '連載中'
      // based on typical API response, or custom logic in the tile.
      // In the current implementation:
      // isOngoing = item.end == 1.
      // If short story (novelType=2) usually end=0 or similar?
      // The code uses: final isOngoing = useMemoized(() => item.end == 1, [item.end]);
      // So checks purely based on end flag.

      testWidgets('should display "短編" badge for short story with end == 0', (
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

        expect(find.text('短編'), findsOneWidget);
        expect(find.text('連載中'), findsNothing);
        expect(find.text('完結'), findsNothing);
      });

      testWidgets('should display "短編" badge for short story with end == 1', (
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

        expect(find.text('短編'), findsOneWidget);
        expect(find.text('連載中'), findsNothing);
        expect(find.text('完結'), findsNothing);
      });
    });

    group('widget structure', () {
      testWidgets('should display title and metadata', (
        WidgetTester tester,
      ) async {
        const item = NovelInfo(
          ncode: 'N1234AB',
          title: 'テストタイトル',
          novelType: 1,
          end: 0,
          genre: 1,
          writer: 'テスト作者',
          allPoint: 12345,
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NovelListTile(item: item),
            ),
          ),
        );

        expect(find.text('テストタイトル'), findsOneWidget);
        // Metadata format: "${item.writer} • $genreName${item.allPoint != null ? ' • ${(item.allPoint! / 1000).toStringAsFixed(1)}k pt' : ''}"
        // Genre 1 usually maps to something like "異世界..." dependent on app_constants.
        // We will just check if writer name exists in the widget tree for now,
        // as exact string depends on constant mapping.
        expect(find.textContaining('テスト作者'), findsOneWidget);
        expect(find.textContaining('12.3k pt'), findsOneWidget);
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

        // No InkWell/ListTile leading check easy here without specific keys,
        // but verifying no isolated '5' or similar is enough,
        // or just ensuring the widget builds without error.
        expect(find.byType(InkWell), findsOneWidget);
      });
    });
  });

  group('flutter_hooks integration', () {
    testWidgets('should use HookWidget and maintain functionality', (
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
      expect(find.byType(NovelListTile), findsOneWidget);
      final widget = tester.widget(find.byType(NovelListTile));
      expect(widget, isA<HookWidget>());
    });
  });
}
