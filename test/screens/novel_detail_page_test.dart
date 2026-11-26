import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/download_progress.dart';
import 'package:novelty/models/download_result.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/repositories/preferences_repository.dart';
import 'package:novelty/screens/novel_detail_page.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:tiny_state/tiny_state.dart';

import '../helpers/clipboard.dart';
import '../support/test_services.dart';
import 'novel_detail_page_test.mocks.dart';

@GenerateMocks([AppDatabase, NovelRepository])
/// Unmounts the page so drift's watched stream is cancelled first.
Future<void> unmountPage(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 1));
}

/// Pumps the detail page with the given repository and database state.
Future<void> pumpNovelDetail(
  WidgetTester tester, {
  required NovelSource source,
  required String workId,
  NovelInfo? novelInfo,
  List<Episode> episodes = const [],
  bool inLibrary = false,
  bool offline = false,
  int? lastReadEpisode,
  DownloadResult? downloadResult,
  AppDatabase? database,
}) async {
  final mockDb = database == null ? MockAppDatabase() : null;
  if (mockDb != null) {
    when(
      mockDb.watchIsInLibrary(source, workId),
    ).thenAnswer((_) => Stream.value(inLibrary));
  }
  final db = database ?? mockDb!;

  final repository = MockNovelRepository();
  final info =
      novelInfo ?? NovelInfo(source: source, workId: workId, title: '作品');
  when(repository.watchNovelInfo(source, workId)).thenAnswer(
    (_) => Stream.value(info),
  );
  when(repository.watchEpisodeList(source, workId, 1)).thenAnswer(
    (_) => Stream.value(episodes),
  );
  when(
    repository.watchDownloadProgress(source, workId),
  ).thenAnswer((_) => const Stream<DownloadProgress>.empty());
  when(
    repository.watchLastReadEpisode(source, workId),
  ).thenAnswer((_) => Stream.value(lastReadEpisode));

  final result = downloadResult;
  if (result != null) {
    when(repository.downloadNovelInfo(info)).thenAnswer((_) async => result);
  }

  // With a real database, delegate mutations to the real repository.
  if (database != null) {
    final real = NovelRepository(
      apiService: ApiService(),
      settings: SettingsController(
        PreferencesRepository(),
        initialState: const AsyncData(testSettings),
      ),
      db: database,
    );
    for (final deleteDownloads in [true, false]) {
      when(
        repository.removeFromLibrary(
          source,
          workId,
          deleteDownloads: deleteDownloads,
        ),
      ).thenAnswer(
        (_) => real.removeFromLibrary(
          source,
          workId,
          deleteDownloads: deleteDownloads,
        ),
      );
    }
    when(repository.addNovelInfoToLibrary(info)).thenAnswer(
      (_) => real.addNovelInfoToLibrary(info),
    );
  }

  await tester.pumpWidget(
    withServices(
      buildTestServices(
        db: db,
        repository: repository,
        settings: offline ? offlineTestSettings : testSettings,
      ),
      MaterialApp(
        home: NovelDetailPage(source: source, workId: workId),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NovelDetailPage', () {
    const testNcode = 'n1234ab';

    testWidgets('非公開作品のバナーが表示される', (tester) async {
      await pumpNovelDetail(
        tester,
        source: NovelSource.narou,
        workId: testNcode,
        novelInfo: const NovelInfo(
          workId: testNcode,
          ncode: testNcode,
          title: '非公開作品のタイトル',
          isPrivate: true,
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text(
          'この作品は非公開・削除されているため、'
          '新しいデータを取得できません。'
          'キャッシュから表示しています。',
        ),
        findsOneWidget,
      );
    });

    testWidgets('なろう作品でもソースバッジが表示される', (tester) async {
      await pumpNovelDetail(
        tester,
        source: NovelSource.narou,
        workId: testNcode,
        novelInfo: const NovelInfo(
          workId: testNcode,
          ncode: testNcode,
          title: 'バッジテスト小説',
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('小説家になろう'), findsOneWidget);
    });

    testWidgets('カクヨム作品でもソースバッジが表示される', (tester) async {
      const kakuyomuWorkId = '16818023211929539879';
      await pumpNovelDetail(
        tester,
        source: NovelSource.kakuyomu,
        workId: kakuyomuWorkId,
        novelInfo: const NovelInfo(
          source: NovelSource.kakuyomu,
          workId: kakuyomuWorkId,
          title: 'バッジテスト小説',
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('カクヨム'), findsOneWidget);
    });

    testWidgets('公開作品では非公開バナーが表示されない', (tester) async {
      await pumpNovelDetail(
        tester,
        source: NovelSource.narou,
        workId: testNcode,
        novelInfo: const NovelInfo(
          workId: testNcode,
          ncode: testNcode,
          title: '公開作品のタイトル',
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text(
          'この作品は非公開・削除されているため、'
          '新しいデータを取得できません。'
          'キャッシュから表示しています。',
        ),
        findsNothing,
      );
    });

    testWidgets('オフラインモード中は一括ダウンロードメニューが無効化される', (tester) async {
      await pumpNovelDetail(
        tester,
        source: NovelSource.narou,
        workId: testNcode,
        novelInfo: const NovelInfo(
          workId: testNcode,
          ncode: testNcode,
          title: 'オフライン小説',
        ),
        offline: true,
      );

      await tester.pumpAndSettle();

      // AppBarのポップアップメニューを開く
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      expect(find.text('一括ダウンロード'), findsOneWidget);

      // 無効化されているメニューをタップ
      await tester.tap(find.text('一括ダウンロード'));
      await tester.pumpAndSettle();

      expect(
        find.text('オフラインモード中はエピソードのダウンロード・削除ができません'),
        findsOneWidget,
      );
    });

    testWidgets('オフラインモード中でもライブラリ追加ボタンは有効', (tester) async {
      await pumpNovelDetail(
        tester,
        source: NovelSource.narou,
        workId: testNcode,
        novelInfo: const NovelInfo(
          workId: testNcode,
          ncode: testNcode,
          title: 'オフライン小説',
        ),
        offline: true,
      );

      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'ライブラリに追加'),
      );
      expect(button.enabled, isTrue);
    });

    testWidgets('共有アイコンをタップするとタイトルとURLがクリップボードにコピーされる', (
      tester,
    ) async {
      final clipboardMock = installClipboardMock(tester);
      addTearDown(clipboardMock.dispose);

      await pumpNovelDetail(
        tester,
        source: NovelSource.narou,
        workId: testNcode,
        novelInfo: const NovelInfo(
          workId: testNcode,
          ncode: testNcode,
          title: '共有テスト小説',
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.copy));
      await tester.pumpAndSettle();

      clipboardMock.expectCopiedText(
        '共有テスト小説\nhttps://ncode.syosetu.com/$testNcode/',
      );
      expect(find.text('コピーしました'), findsOneWidget);
    });

    testWidgets('カクヨム作品の共有ではkakuyomu.jpのURLがコピーされる', (
      tester,
    ) async {
      const kakuyomuWorkId = '16818023211929539879';
      final clipboardMock = installClipboardMock(tester);
      addTearDown(clipboardMock.dispose);

      await pumpNovelDetail(
        tester,
        source: NovelSource.kakuyomu,
        workId: kakuyomuWorkId,
        novelInfo: const NovelInfo(
          source: NovelSource.kakuyomu,
          workId: kakuyomuWorkId,
          title: 'カクヨム共有テスト小説',
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.copy));
      await tester.pumpAndSettle();

      clipboardMock.expectCopiedText(
        'カクヨム共有テスト小説\nhttps://kakuyomu.jp/works/$kakuyomuWorkId',
      );
      expect(find.text('コピーしました'), findsOneWidget);
    });

    testWidgets('カクヨム作品のエピソード一覧で話数が目次順連番で表示される', (
      tester,
    ) async {
      const kakuyomuWorkId = '1177354054891139802';
      const kakuyomuEpisodeId = '1177354054891141560';

      await pumpNovelDetail(
        tester,
        source: NovelSource.kakuyomu,
        workId: kakuyomuWorkId,
        novelInfo: const NovelInfo(
          source: NovelSource.kakuyomu,
          workId: kakuyomuWorkId,
          title: 'カクヨム話数テスト小説',
          generalAllNo: 3,
        ),
        episodes: const [
          Episode(
            source: NovelSource.kakuyomu,
            index: 1,
            subtitle: '第一話',
            url:
                'https://kakuyomu.jp/works/$kakuyomuWorkId/episodes/$kakuyomuEpisodeId',
          ),
          Episode(
            source: NovelSource.kakuyomu,
            index: 2,
            subtitle: '第二話',
            url:
                'https://kakuyomu.jp/works/$kakuyomuWorkId/episodes/1177354054891141561',
          ),
          Episode(
            source: NovelSource.kakuyomu,
            index: 3,
            subtitle: '第三話',
            url:
                'https://kakuyomu.jp/works/$kakuyomuWorkId/episodes/1177354054891141562',
          ),
        ],
      );

      await tester.pumpAndSettle();

      // 話数は作品IDではなく目次順の連番で表示される
      expect(find.text('第1話'), findsOneWidget);
      expect(find.text('第2話'), findsOneWidget);
      expect(find.text('第3話'), findsOneWidget);
      // 作品IDが話数として表示されないこと
      expect(find.text('第$kakuyomuWorkId話'), findsNothing);
    });

    Future<AppDatabase> pumpLibraryRegisteredPage(
      WidgetTester tester,
    ) async {
      final database = AppDatabase.memory();
      addTearDown(database.close);

      await database.insertNovel(
        const NovelInfo(ncode: testNcode, title: 'テスト作品').toDbCompanion(),
      );
      await database.addToLibrary(NovelSource.narou, testNcode);
      await database.updateEpisodeContent(
        source: NovelSource.narou,
        workId: testNcode,
        episodeId: 1,
        content: [const NovelContentElement.plainText('ダウンロード済みの本文')],
        fetchedAt: 1234567890,
        subtitle: '第1話',
      );

      await pumpNovelDetail(
        tester,
        source: NovelSource.narou,
        workId: testNcode,
        novelInfo: const NovelInfo(
          workId: testNcode,
          ncode: testNcode,
          title: 'テスト作品',
        ),
        inLibrary: true,
        downloadResult: const DownloadResult.success(
          needsLibraryAddition: true,
        ),
        database: database,
      );
      await tester.pumpAndSettle();
      return database;
    }

    testWidgets('ライブラリ登録済みの作品を外すときダウンロード削除を確認する', (tester) async {
      final database = await pumpLibraryRegisteredPage(tester);

      await tester.tap(
        find.widgetWithText(FilledButton, 'ライブラリ登録済み'),
      );
      await tester.pumpAndSettle();

      expect(find.text('ダウンロード済みの話も削除しますか？'), findsOneWidget);

      await tester.tap(find.text('ダウンロードも削除'));
      await tester.pumpAndSettle();

      expect(
        await database.isInLibrary(NovelSource.narou, testNcode),
        isFalse,
      );
      final episode = await database.getEpisodeData(
        NovelSource.narou,
        testNcode,
        1,
      );
      expect(episode!.content, isNull);

      await unmountPage(tester);
    });

    testWidgets('ダウンロード済みの話を残してライブラリから外せる', (tester) async {
      final database = await pumpLibraryRegisteredPage(tester);

      await tester.tap(
        find.widgetWithText(FilledButton, 'ライブラリ登録済み'),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('ライブラリからのみ外す'));
      await tester.pumpAndSettle();

      expect(
        await database.isInLibrary(NovelSource.narou, testNcode),
        isFalse,
      );
      final episode = await database.getEpisodeData(
        NovelSource.narou,
        testNcode,
        1,
      );
      expect(episode!.content, isNotNull);

      await unmountPage(tester);
    });

    testWidgets('キャンセルするとライブラリに残る', (tester) async {
      final database = await pumpLibraryRegisteredPage(tester);

      await tester.tap(
        find.widgetWithText(FilledButton, 'ライブラリ登録済み'),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('キャンセル'));
      await tester.pumpAndSettle();

      expect(
        await database.isInLibrary(NovelSource.narou, testNcode),
        isTrue,
      );
      await unmountPage(tester);
      final episode = await database.getEpisodeData(
        NovelSource.narou,
        testNcode,
        1,
      );
      expect(episode!.content, isNotNull);
    });

    testWidgets('ダウンロード完了後の「追加」で登録済みの作品は外れない', (tester) async {
      final database = await pumpLibraryRegisteredPage(tester);

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('一括ダウンロード'));
      await tester.pumpAndSettle();

      // ダウンロード完了によりライブラリ追加を促す SnackBar が出る
      await tester.tap(find.widgetWithText(SnackBarAction, '追加'));
      await tester.pumpAndSettle();

      expect(
        await database.isInLibrary(NovelSource.narou, testNcode),
        isTrue,
      );
      await unmountPage(tester);
      final episode = await database.getEpisodeData(
        NovelSource.narou,
        testNcode,
        1,
      );
      expect(episode!.content, isNotNull);
    });
  });
}
