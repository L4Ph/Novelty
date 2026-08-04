import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/widgets/app_bar_source_dropdown.dart';

void main() {
  group('AppBarSourceDropdown', () {
    /// テスト用に AppBarSourceDropdown をラップして生成するヘルパー。
    Widget buildSubject({
      NovelSource? selected = NovelSource.narou,
      String? allLabel,
      ValueChanged<NovelSource?>? onChanged,
    }) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: AppBarSourceDropdown(
              sources: NovelSource.values,
              selected: selected,
              onChanged: onChanged ?? (_) {},
              allLabel: allLabel,
            ),
          ),
        ),
      );
    }

    testWidgets('選択中のサイト名とドロップダウン矢印が表示される', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('小説家になろう'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
      // 地球アイコンは使わない
      expect(find.byIcon(Icons.public), findsNothing);
    });

    testWidgets('サイトを切り替えるとonChangedが呼ばれる', (tester) async {
      NovelSource? changed;
      await tester.pumpWidget(buildSubject(onChanged: (s) => changed = s));

      await tester.tap(find.byKey(const Key('app_bar_source_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('カクヨム').last);
      await tester.pumpAndSettle();

      expect(changed, NovelSource.kakuyomu);
    });

    testWidgets('allLabel指定時は「すべて」(null)を選択できる', (tester) async {
      var called = false;
      NovelSource? changed = NovelSource.narou;
      await tester.pumpWidget(
        buildSubject(
          allLabel: 'すべて',
          onChanged: (s) {
            called = true;
            changed = s;
          },
        ),
      );

      await tester.tap(find.byKey(const Key('app_bar_source_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('すべて').last);
      await tester.pumpAndSettle();

      expect(called, isTrue);
      expect(changed, isNull);
    });
  });
}
