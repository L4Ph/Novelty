import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/models/novel_content_element.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/widgets/novel_content.dart';
import 'package:novelty/widgets/novel_content_view.dart';
import 'package:tategaki/tategaki.dart';

/// テスト用のデフォルトAppSettingsインスタンス。
AppSettings get defaultTestSettings => const AppSettings(
  isVertical: false,
  fontSize: 16,
  novelDownloadPath: '/fake/path',
);

void main() {
  // ダミーの小説コンテンツデータ
  final testContent = <NovelContentElement>[
    NovelContentElement.plainText('これはテストの1行目です。'),
    NovelContentElement.plainText('これはテストの2行目です。'),
  ];

  // 各テストでウィジェットをポンプするためのヘルパー関数
  Future<void> pumpWidget(
    WidgetTester tester, {
    required AsyncValue<List<NovelContentElement>> contentValue,
    required AsyncValue<AppSettings> settingsValue,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NovelContentBody(
            ncode: 'n1234ab',
            episode: 1,
            content: contentValue,
            settings: settingsValue,
          ),
        ),
      ),
    );
  }

  testWidgets('設定とコンテンツがローディング中の場合、CircularProgressIndicatorが表示されること', (
    tester,
  ) async {
    await pumpWidget(
      tester,
      contentValue: const AsyncLoading(),
      settingsValue: const AsyncLoading(),
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('コンテンツがエラーの場合、エラーメッセージが表示されること', (tester) async {
    final exception = Exception('Content Error');
    await pumpWidget(
      tester,
      contentValue: AsyncValue.error(exception, StackTrace.empty),
      settingsValue: AsyncData(defaultTestSettings),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Error: $exception'), findsOneWidget);
  });

  testWidgets('設定がエラーの場合、エラーメッセージが表示されること', (tester) async {
    final exception = Exception('Settings Error');
    await pumpWidget(
      tester,
      contentValue: AsyncData(testContent),
      settingsValue: AsyncValue.error(exception, StackTrace.empty),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Error: $exception'), findsOneWidget);
  });

  testWidgets('データ取得成功時、横書き設定でNovelContentViewが表示されること', (tester) async {
    await pumpWidget(
      tester,
      contentValue: AsyncData(testContent),
      settingsValue: AsyncData(defaultTestSettings.copyWith(isVertical: false)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NovelContentView), findsOneWidget);
    expect(find.byType(TategakiText), findsNothing);

    final richText = tester.widget<RichText>(find.byType(RichText));
    final textSpan = richText.text as TextSpan;
    expect(textSpan.toPlainText(), 'これはテストの1行目です。これはテストの2行目です。');
  });

  testWidgets('データ取得成功時、縦書き設定でTategakiTextが表示されること', (tester) async {
    await pumpWidget(
      tester,
      contentValue: AsyncData(testContent),
      settingsValue: AsyncData(defaultTestSettings.copyWith(isVertical: true)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TategakiText), findsOneWidget);
    expect(find.byType(NovelContentView), findsNothing);
  });
}
