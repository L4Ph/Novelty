import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/screens/library_page.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LibraryPage のライブラリ削除', () {
    late AppDatabase database;

    const workId = 'n1234ab';

    setUp(() async {
      database = AppDatabase.memory();
      await database.insertNovel(
        const NovelInfo(ncode: workId, title: 'テスト作品').toDbCompanion(),
      );
      await database.addToLibrary(NovelSource.narou, workId);
      await database.updateEpisodeContent(
        source: NovelSource.narou,
        workId: workId,
        episodeId: 1,
        content: [const NovelContentElement.plainText('ダウンロード済みの本文')],
        fetchedAt: 1234567890,
        subtitle: '第1話',
      );
    });

    tearDown(() async {
      await database.close();
    });

    Future<void> pumpLibraryPage(WidgetTester tester) async {
      // drift の監視ストリームはテスト終了時に pending timer を残すため、
      // 一覧はスナップショットを流し込む。
      final novels = await database.getLibraryNovels();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(database),
            libraryNovelsProvider.overrideWith(
              (ref) => Stream.value(novels),
            ),
            settingsProvider.overrideWith(FakeSettings.new),
            isOfflineModeProvider.overrideWithValue(false),
          ],
          child: const MaterialApp(home: LibraryPage()),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('長押しするとダウンロード済みの話を削除するか確認する', (tester) async {
      await pumpLibraryPage(tester);

      await tester.longPress(find.text('テスト作品'));
      await tester.pumpAndSettle();

      expect(find.text('"テスト作品"をライブラリから削除しますか？'), findsOneWidget);
      expect(find.text('ダウンロード済みの話も削除しますか？'), findsOneWidget);
    });

    testWidgets('ダウンロード済みの話も削除してライブラリから外せる', (tester) async {
      await pumpLibraryPage(tester);

      await tester.longPress(find.text('テスト作品'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('ダウンロードも削除'));
      await tester.pumpAndSettle();

      expect(await database.isInLibrary(NovelSource.narou, workId), isFalse);

      final episode = await database.getEpisodeData(
        NovelSource.narou,
        workId,
        1,
      );
      expect(episode!.content, isNull);
    });

    testWidgets('ダウンロード済みの話を残してライブラリから外せる', (tester) async {
      await pumpLibraryPage(tester);

      await tester.longPress(find.text('テスト作品'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('ライブラリからのみ外す'));
      await tester.pumpAndSettle();

      expect(await database.isInLibrary(NovelSource.narou, workId), isFalse);

      final episode = await database.getEpisodeData(
        NovelSource.narou,
        workId,
        1,
      );
      expect(episode!.content, isNotNull);
    });

    testWidgets('キャンセルするとライブラリに残る', (tester) async {
      await pumpLibraryPage(tester);

      await tester.longPress(find.text('テスト作品'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('キャンセル'));
      await tester.pumpAndSettle();

      expect(await database.isInLibrary(NovelSource.narou, workId), isTrue);

      final episode = await database.getEpisodeData(
        NovelSource.narou,
        workId,
        1,
      );
      expect(episode!.content, isNotNull);
    });
  });
}

/// テスト用の設定Notifier
class FakeSettings extends Settings {
  @override
  Future<AppSettings> build() async {
    return const AppSettings(
      fontSize: 16,
      isVertical: false,
      themeMode: ThemeMode.system,
      lineHeight: 1.5,
      isIncognito: false,
      isPageFlip: false,
      isRubyEnabled: true,
    );
  }
}
