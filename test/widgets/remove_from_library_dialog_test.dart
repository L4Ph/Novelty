import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/widgets/remove_from_library_dialog.dart';

void main() {
  /// ダイアログを開き、選択結果を記録するリストを返す。
  Future<List<RemoveFromLibraryAction?>> openDialog(
    WidgetTester tester,
  ) async {
    final results = <RemoveFromLibraryAction?>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              results.add(
                await showRemoveFromLibraryDialog(
                  context,
                  novelTitle: 'テスト作品',
                ),
              );
            },
            child: const Text('開く'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('開く'));
    await tester.pumpAndSettle();
    return results;
  }

  testWidgets('ダウンロード済みの話を削除するか確認する', (tester) async {
    final results = await openDialog(tester);

    expect(find.text('"テスト作品"をライブラリから削除しますか？'), findsOneWidget);
    expect(find.text('ダウンロード済みの話も削除しますか？'), findsOneWidget);

    await tester.tap(find.text('ダウンロードも削除'));
    await tester.pumpAndSettle();

    expect(results, [RemoveFromLibraryAction.deleteDownloads]);
  });

  testWidgets('ダウンロード済みの話を残す選択ができる', (tester) async {
    final results = await openDialog(tester);

    // 破壊的な選択肢を主ボタンにしない
    expect(
      find.widgetWithText(FilledButton, 'ライブラリからのみ外す'),
      findsOneWidget,
    );

    await tester.tap(find.text('ライブラリからのみ外す'));
    await tester.pumpAndSettle();

    expect(results, [RemoveFromLibraryAction.keepDownloads]);
  });

  testWidgets('キャンセルすると削除しない', (tester) async {
    final results = await openDialog(tester);

    await tester.tap(find.text('キャンセル'));
    await tester.pumpAndSettle();

    expect(results, [RemoveFromLibraryAction.cancel]);
  });
}
