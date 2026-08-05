import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/widgets/source_selector.dart';

void main() {
  group('SourceSelector', () {
    /// テスト用に SourceSelector をラップして生成するヘルパー。
    Widget buildSubject({
      NovelSource? selected = NovelSource.narou,
      String? allLabel,
      ValueChanged<NovelSource?>? onChanged,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SourceSelector(
            sources: NovelSource.values,
            selected: selected,
            onChanged: onChanged ?? (_) {},
            allLabel: allLabel,
          ),
        ),
      );
    }

    testWidgets('選択中のサイト名が表示される', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('小説家になろう'), findsOneWidget);
    });

    testWidgets('ドロップダウンを開くと全サイトが表示される', (tester) async {
      await tester.pumpWidget(buildSubject());

      await tester.tap(find.byType(DropdownButtonFormField<NovelSource?>));
      await tester.pumpAndSettle();

      // 開いたメニューには各サイトが表示される
      // (選択中の項目はボタン側にも表示されるため複数ヒットしうる)
      expect(find.text('小説家になろう'), findsWidgets);
      expect(find.text('カクヨム'), findsOneWidget);
    });

    testWidgets('サイトを選択すると onChanged が呼ばれる', (tester) async {
      NovelSource? changedSource = NovelSource.narou;
      var callCount = 0;

      await tester.pumpWidget(
        buildSubject(
          onChanged: (source) {
            changedSource = source;
            callCount++;
          },
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<NovelSource?>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('カクヨム').last);
      await tester.pumpAndSettle();

      expect(callCount, 1);
      expect(changedSource, NovelSource.kakuyomu);
    });

    testWidgets('allLabel を指定すると「すべて」項目が表示される', (tester) async {
      await tester.pumpWidget(buildSubject(allLabel: 'すべて'));

      await tester.tap(find.byType(DropdownButtonFormField<NovelSource?>));
      await tester.pumpAndSettle();

      expect(find.text('すべて'), findsOneWidget);
    });

    testWidgets('「すべて」を選択すると onChanged に null が渡される', (
      tester,
    ) async {
      NovelSource? changedSource = NovelSource.narou;
      var callCount = 0;

      await tester.pumpWidget(
        buildSubject(
          allLabel: 'すべて',
          onChanged: (source) {
            changedSource = source;
            callCount++;
          },
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<NovelSource?>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('すべて'));
      await tester.pumpAndSettle();

      expect(callCount, 1);
      expect(changedSource, isNull);
    });

    testWidgets('allLabel 未指定かつ selected が null の場合は何も選択されない', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject(selected: null));

      // どのサイト名もボタン表示としては出ない
      expect(find.text('小説家になろう'), findsNothing);
      expect(find.text('カクヨム'), findsNothing);
    });
  });
}
