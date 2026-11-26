import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/sites/novel_site.dart';
import 'package:novelty/widgets/ranking_filter_sheet.dart';

const _genres = [
  GenreMaster(id: '101', name: 'ファンタジー〔異世界〕'),
  GenreMaster(id: '201', name: 'ローファンタジー〔恋愛〕'),
];

/// Pumps the sheet and returns a getter for the last submitted filter.
Future<({bool showOnlyOngoing, String? selectedGenreId})? Function()> pumpSheet(
  WidgetTester tester,
) async {
  ({bool showOnlyOngoing, String? selectedGenreId})? applied;
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: RankingFilterSheet(
          genres: _genres,
          initialShowOnlyOngoing: false,
          initialSelectedGenreId: '101',
          onApply: ({required showOnlyOngoing, required selectedGenreId}) {
            applied = (
              showOnlyOngoing: showOnlyOngoing,
              selectedGenreId: selectedGenreId,
            );
          },
        ),
      ),
    ),
  );
  return () => applied;
}

void main() {
  testWidgets('ジャンルチップをタップすると選択状態が塗り替わる', (tester) async {
    await pumpSheet(tester);

    FilterChip chipFor(String label) => tester.widget<FilterChip>(
      find.widgetWithText(FilterChip, label),
    );

    expect(chipFor('ファンタジー〔異世界〕').selected, isTrue);

    await tester.tap(find.widgetWithText(FilterChip, 'ローファンタジー〔恋愛〕'));
    await tester.pump();

    expect(chipFor('ローファンタジー〔恋愛〕').selected, isTrue);
    expect(chipFor('ファンタジー〔異世界〕').selected, isFalse);
  });

  testWidgets('リセットするとチップの選択が外れる', (tester) async {
    await pumpSheet(tester);

    await tester.tap(find.text('リセット'));
    await tester.pump();

    final chips = tester.widgetList<FilterChip>(find.byType(FilterChip));
    expect(chips.every((chip) => !chip.selected), isTrue);
  });

  testWidgets('リセット後の適用は空の条件を返す', (tester) async {
    final applied = await pumpSheet(tester);

    await tester.tap(find.text('リセット'));
    await tester.pump();
    await tester.tap(find.text('適用'));
    await tester.pump();

    final result = applied()!;
    expect(result.showOnlyOngoing, isFalse);
    expect(result.selectedGenreId, isNull);
  });
}
