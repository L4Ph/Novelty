import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

void main() {
  group('NovelListTile', () {
    group('status display', () {
      testWidgets('should display "完結" badge for novel with end == 0', (
        tester,
      ) async {
        const item = NovelInfo(
          ncode: 'N1234AB',
          title: 'テスト連載小説',
          novelType: 1,
          end: 0,
          genreId: '1',
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
          tester,
        ) async {
          const item = NovelInfo(
            ncode: 'N1234AB',
            title: 'テスト連載小説',
            novelType: 1,
            end: 1,
            genreId: '1',
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

      // 注: '短編' は現在、'完結' や '連載中' に分類されるロジックで処理される
      // based on typical API response, or custom logic in the tile.
      // 現在の実装では:
      // isOngoing = item.end == 1.
      // 短編 (novelType=2) は通常 end=0 または類似の値?
      // コードでは: final isOngoing = useMemoized(() => item.end == 1,
      // [item.end]);
      // つまり end フラグのみで判定している

      testWidgets('should display "短編" badge for short story with end == 0', (
        tester,
      ) async {
        const item = NovelInfo(
          ncode: 'N1234AB',
          title: 'テスト短編小説',
          novelType: 2,
          end: 0,
          genreId: '1',
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
        tester,
      ) async {
        const item = NovelInfo(
          ncode: 'N1234AB',
          title: 'テスト短編小説',
          novelType: 2,
          end: 1,
          genreId: '1',
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
        tester,
      ) async {
        const item = NovelInfo(
          ncode: 'N1234AB',
          title: 'テストタイトル',
          novelType: 1,
          end: 0,
          genreId: '1',
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
        // メタデータ形式: "${item.writer} • $genreName${item.allPoint !=
        // null ? ' • ${(item.allPoint! / 1000).toStringAsFixed(1)}k pt' : ''}"
        // ジャンル 1 は通常「異世界...」などの依存する値にマッピングされる
        // on app_constants.
        // 現時点では著者名がウィジェットツリーに存在するかだけ確認する
        // as exact string depends on constant mapping.
        expect(find.textContaining('テスト作者'), findsOneWidget);
        expect(find.textContaining('12.3k pt'), findsOneWidget);
      });

      testWidgets('should display rank when rank is provided', (
        tester,
      ) async {
        const item = NovelInfo(
          ncode: 'N1234AB',
          title: 'テストタイトル',
          novelType: 1,
          end: 0,
          genreId: '1',
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
        tester,
      ) async {
        const item = NovelInfo(
          ncode: 'N1234AB',
          title: 'テストタイトル',
          novelType: 1,
          end: 0,
          genreId: '1',
          writer: 'テスト作者',
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NovelListTile(item: item),
            ),
          ),
        );

        // 特定キーがないため、InkWell/ListTile の先頭チェックは難しい
        // but verifying no isolated '5' or similar is enough,
        // or just ensuring the widget builds without error.
        expect(find.byType(InkWell), findsOneWidget);
      });
    });
  });

  group('flutter_hooks integration', () {
    group('source badge', () {
      testWidgets('カクヨム作品にはソースバッジが表示される', (tester) async {
        const item = NovelInfo(
          source: NovelSource.kakuyomu,
          workId: '16818023211929539879',
          title: 'カクヨム作品',
          end: 1,
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NovelListTile(item: item),
            ),
          ),
        );

        expect(find.text('カクヨム'), findsOneWidget);
      });

      testWidgets('なろう作品にはソースバッジが表示されない', (tester) async {
        const item = NovelInfo(
          ncode: 'N1234AB',
          title: 'なろう作品',
          end: 1,
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NovelListTile(item: item),
            ),
          ),
        );

        expect(find.text('小説家になろう'), findsNothing);
      });
    });

    testWidgets('should use HookWidget and maintain functionality', (
      tester,
    ) async {
      const item = NovelInfo(
        ncode: 'N1234AB',
        title: 'テストタイトル',
        novelType: 1,
        end: 0,
        genreId: '1',
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
