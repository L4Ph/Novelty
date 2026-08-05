import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/widgets/search_modal.dart';

/// [SearchModal] をテスト用にラップする。
Widget _buildModal({
  NovelSearchQuery initialQuery = const NovelSearchQuery(
    source: NovelSource.kakuyomu,
  ),
  ValueChanged<NovelSearchQuery>? onSearch,
}) {
  return ProviderScope(
    child: MaterialApp(
      home: Scaffold(
        body: SearchModal(
          initialQuery: initialQuery,
          onSearch: onSearch ?? (_) {},
        ),
      ),
    ),
  );
}

void main() {
  group('SearchModal カクヨム検索条件', () {
    testWidgets('カクヨム選択時は連載状態・文字数のドロップダウンを表示する', (tester) async {
      await tester.pumpWidget(_buildModal());
      await tester.pumpAndSettle();

      expect(find.text('連載状態'), findsOneWidget);
      expect(find.text('文字数'), findsOneWidget);
    });

    testWidgets('なろう選択時は連載状態・文字数のドロップダウンを表示しない', (tester) async {
      await tester.pumpWidget(
        _buildModal(
          initialQuery: const NovelSearchQuery(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('連載状態'), findsNothing);
      expect(find.text('文字数'), findsNothing);
    });

    testWidgets('連載状態「連載中」を選択するとserialStatusがrunningになる', (
      tester,
    ) async {
      NovelSearchQuery? searched;
      await tester.pumpWidget(
        _buildModal(onSearch: (q) => searched = q),
      );
      await tester.pumpAndSettle();

      // 連載状態ドロップダウンを開く
      await tester.tap(find.byKey(const Key('kakuyomu_serial_status')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('連載中').last);
      await tester.pumpAndSettle();

      // 検索ボタンを押す
      await tester.tap(find.byKey(const Key('search_button')));
      await tester.pumpAndSettle();

      expect(searched?.serialStatus, 'running');
    });

    testWidgets('連載状態「完結」を選択するとserialStatusがcompletedになる', (
      tester,
    ) async {
      NovelSearchQuery? searched;
      await tester.pumpWidget(
        _buildModal(onSearch: (q) => searched = q),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('kakuyomu_serial_status')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('完結').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('search_button')));
      await tester.pumpAndSettle();

      expect(searched?.serialStatus, 'completed');
    });

    testWidgets('文字数範囲を選択するとtotalCharacterCountRangeに反映される', (
      tester,
    ) async {
      NovelSearchQuery? searched;
      await tester.pumpWidget(
        _buildModal(onSearch: (q) => searched = q),
      );
      await tester.pumpAndSettle();

      // 表示領域外の可能性があるためスクロールして表示させる
      await tester.ensureVisible(
        find.byKey(const Key('kakuyomu_char_count_range')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('kakuyomu_char_count_range')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2万〜10万字').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('search_button')));
      await tester.pumpAndSettle();

      expect(searched?.totalCharacterCountRange, '20000-100000');
    });

    testWidgets('ジャンルを選択するとgenreIdに反映される', (tester) async {
      NovelSearchQuery? searched;
      await tester.pumpWidget(
        _buildModal(onSearch: (q) => searched = q),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('kakuyomu_genre')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ファンタジー').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('search_button')));
      await tester.pumpAndSettle();

      expect(searched?.genreId, ['FANTASY']);
    });
  });
}
