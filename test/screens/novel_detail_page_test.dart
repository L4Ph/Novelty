import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/screens/novel_detail_page.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/settings_provider.dart';

import '../helpers/clipboard.dart';

/// テスト用のライブラリ状態Notifier
class FakeLibraryStatus extends LibraryStatus {
  @override
  Stream<bool> build(NovelSource source, String workId) => Stream.value(false);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NovelDetailPage', () {
    const testNcode = 'n1234ab';

    testWidgets('非公開作品のバナーが表示される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOfflineModeProvider.overrideWithValue(false),
            novelInfoWithCacheProvider.overrideWith(
              (ref, args) => Stream.value(
                NovelInfo(
                  source: args.$1,
                  workId: args.$2,
                  ncode: args.$2,
                  title: '非公開作品のタイトル',
                  isPrivate: true,
                ),
              ),
            ),
            episodeListProvider.overrideWith(
              (ref, args) => Stream.value(<Episode>[]),
            ),
            downloadProgressProvider.overrideWith(
              (ref, args) => Stream.value(null),
            ),
            libraryStatusProvider.overrideWith2((_) => FakeLibraryStatus()),
            lastReadEpisodeProvider.overrideWith(
              (ref, args) => Stream.value(null),
            ),
          ],
          child: const MaterialApp(
            home: NovelDetailPage(source: NovelSource.narou, workId: testNcode),
          ),
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
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOfflineModeProvider.overrideWithValue(false),
            novelInfoWithCacheProvider.overrideWith(
              (ref, args) => Stream.value(
                NovelInfo(
                  source: args.$1,
                  workId: args.$2,
                  ncode: args.$2,
                  title: 'バッジテスト小説',
                ),
              ),
            ),
            episodeListProvider.overrideWith(
              (ref, args) => Stream.value(<Episode>[]),
            ),
            downloadProgressProvider.overrideWith(
              (ref, args) => Stream.value(null),
            ),
            libraryStatusProvider.overrideWith2((_) => FakeLibraryStatus()),
            lastReadEpisodeProvider.overrideWith(
              (ref, args) => Stream.value(null),
            ),
          ],
          child: const MaterialApp(
            home: NovelDetailPage(source: NovelSource.narou, workId: testNcode),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('小説家になろう'), findsOneWidget);
    });

    testWidgets('カクヨム作品でもソースバッジが表示される', (tester) async {
      const kakuyomuWorkId = '16818023211929539879';
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOfflineModeProvider.overrideWithValue(false),
            novelInfoWithCacheProvider.overrideWith(
              (ref, args) => Stream.value(
                const NovelInfo(
                  source: NovelSource.kakuyomu,
                  workId: kakuyomuWorkId,
                  title: 'バッジテスト小説',
                ),
              ),
            ),
            episodeListProvider.overrideWith(
              (ref, args) => Stream.value(<Episode>[]),
            ),
            downloadProgressProvider.overrideWith(
              (ref, args) => Stream.value(null),
            ),
            libraryStatusProvider.overrideWith2((_) => FakeLibraryStatus()),
            lastReadEpisodeProvider.overrideWith(
              (ref, args) => Stream.value(null),
            ),
          ],
          child: const MaterialApp(
            home: NovelDetailPage(
              source: NovelSource.kakuyomu,
              workId: kakuyomuWorkId,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('カクヨム'), findsOneWidget);
    });

    testWidgets('公開作品では非公開バナーが表示されない', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOfflineModeProvider.overrideWithValue(false),
            novelInfoWithCacheProvider.overrideWith(
              (ref, args) => Stream.value(
                NovelInfo(
                  source: args.$1,
                  workId: args.$2,
                  ncode: args.$2,
                  title: '公開作品のタイトル',
                ),
              ),
            ),
            episodeListProvider.overrideWith(
              (ref, args) => Stream.value(<Episode>[]),
            ),
            downloadProgressProvider.overrideWith(
              (ref, args) => Stream.value(null),
            ),
            libraryStatusProvider.overrideWith2((_) => FakeLibraryStatus()),
            lastReadEpisodeProvider.overrideWith(
              (ref, args) => Stream.value(null),
            ),
          ],
          child: const MaterialApp(
            home: NovelDetailPage(source: NovelSource.narou, workId: testNcode),
          ),
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
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOfflineModeProvider.overrideWithValue(true),
            novelInfoWithCacheProvider.overrideWith(
              (ref, args) => Stream.value(
                NovelInfo(
                  source: args.$1,
                  workId: args.$2,
                  ncode: args.$2,
                  title: 'オフライン小説',
                ),
              ),
            ),
            episodeListProvider.overrideWith(
              (ref, args) => Stream.value(<Episode>[]),
            ),
            downloadProgressProvider.overrideWith(
              (ref, args) => Stream.value(null),
            ),
            libraryStatusProvider.overrideWith2((_) => FakeLibraryStatus()),
            lastReadEpisodeProvider.overrideWith(
              (ref, args) => Stream.value(null),
            ),
          ],
          child: const MaterialApp(
            home: NovelDetailPage(source: NovelSource.narou, workId: testNcode),
          ),
        ),
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
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOfflineModeProvider.overrideWithValue(true),
            novelInfoWithCacheProvider.overrideWith(
              (ref, args) => Stream.value(
                NovelInfo(
                  source: args.$1,
                  workId: args.$2,
                  ncode: args.$2,
                  title: 'オフライン小説',
                ),
              ),
            ),
            episodeListProvider.overrideWith(
              (ref, args) => Stream.value(<Episode>[]),
            ),
            downloadProgressProvider.overrideWith(
              (ref, args) => Stream.value(null),
            ),
            libraryStatusProvider.overrideWith2((_) => FakeLibraryStatus()),
            lastReadEpisodeProvider.overrideWith(
              (ref, args) => Stream.value(null),
            ),
          ],
          child: const MaterialApp(
            home: NovelDetailPage(source: NovelSource.narou, workId: testNcode),
          ),
        ),
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

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOfflineModeProvider.overrideWithValue(false),
            novelInfoWithCacheProvider.overrideWith(
              (ref, args) => Stream.value(
                NovelInfo(
                  source: args.$1,
                  workId: args.$2,
                  ncode: args.$2,
                  title: '共有テスト小説',
                ),
              ),
            ),
            episodeListProvider.overrideWith(
              (ref, args) => Stream.value(<Episode>[]),
            ),
            downloadProgressProvider.overrideWith(
              (ref, args) => Stream.value(null),
            ),
            libraryStatusProvider.overrideWith2((_) => FakeLibraryStatus()),
            lastReadEpisodeProvider.overrideWith(
              (ref, args) => Stream.value(null),
            ),
          ],
          child: const MaterialApp(
            home: NovelDetailPage(source: NovelSource.narou, workId: testNcode),
          ),
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

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOfflineModeProvider.overrideWithValue(false),
            novelInfoWithCacheProvider.overrideWith(
              (ref, args) => Stream.value(
                const NovelInfo(
                  source: NovelSource.kakuyomu,
                  workId: kakuyomuWorkId,
                  title: 'カクヨム共有テスト小説',
                ),
              ),
            ),
            episodeListProvider.overrideWith(
              (ref, args) => Stream.value(<Episode>[]),
            ),
            downloadProgressProvider.overrideWith(
              (ref, args) => Stream.value(null),
            ),
            libraryStatusProvider.overrideWith2((_) => FakeLibraryStatus()),
            lastReadEpisodeProvider.overrideWith(
              (ref, args) => Stream.value(null),
            ),
          ],
          child: const MaterialApp(
            home: NovelDetailPage(
              source: NovelSource.kakuyomu,
              workId: kakuyomuWorkId,
            ),
          ),
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

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOfflineModeProvider.overrideWithValue(false),
            novelInfoWithCacheProvider.overrideWith(
              (ref, args) => Stream.value(
                const NovelInfo(
                  source: NovelSource.kakuyomu,
                  workId: kakuyomuWorkId,
                  title: 'カクヨム話数テスト小説',
                  generalAllNo: 3,
                ),
              ),
            ),
            episodeListProvider.overrideWith(
              (ref, args) => Stream.value(
                const [
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
              ),
            ),
            downloadProgressProvider.overrideWith(
              (ref, args) => Stream.value(null),
            ),
            libraryStatusProvider.overrideWith2((_) => FakeLibraryStatus()),
            lastReadEpisodeProvider.overrideWith(
              (ref, args) => Stream.value(null),
            ),
          ],
          child: const MaterialApp(
            home: NovelDetailPage(
              source: NovelSource.kakuyomu,
              workId: kakuyomuWorkId,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 話数は作品IDではなく目次順の連番で表示される
      expect(find.text('第1話'), findsOneWidget);
      expect(find.text('第2話'), findsOneWidget);
      expect(find.text('第3話'), findsOneWidget);
      // 作品IDが話数として表示されないこと
      expect(find.text('第$kakuyomuWorkId話'), findsNothing);
    });
  });

  group('エピソード行のダウンロード操作', () {
    const workId = 'n1234ab';

    List<Episode> episodes({required bool firstDownloaded}) {
      return [
        Episode(
          index: 1,
          subtitle: '第一話',
          isDownloaded: firstDownloaded,
        ),
        const Episode(
          index: 2,
          subtitle: '第二話',
        ),
      ];
    }

    Future<void> pumpDetail(
      WidgetTester tester, {
      required bool offline,
      required List<Episode> episodeList,
      required NovelRepository repository,
    }) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOfflineModeProvider.overrideWithValue(offline),
            novelRepositoryProvider.overrideWithValue(repository),
            novelInfoWithCacheProvider.overrideWith(
              (ref, args) => Stream.value(
                NovelInfo(
                  source: args.$1,
                  workId: args.$2,
                  ncode: args.$2,
                  title: '操作テスト小説',
                  generalAllNo: episodeList.length,
                ),
              ),
            ),
            episodeListProvider.overrideWith(
              (ref, args) => Stream.value(episodeList),
            ),
            downloadProgressProvider.overrideWith(
              (ref, args) => Stream.value(null),
            ),
            libraryStatusProvider.overrideWith2((_) => FakeLibraryStatus()),
            lastReadEpisodeProvider.overrideWith(
              (ref, args) => Stream.value(null),
            ),
          ],
          child: const MaterialApp(
            home: NovelDetailPage(
              source: NovelSource.narou,
              workId: workId,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('未ダウンロードの話はダウンロードボタンを押すとその話を保存する', (tester) async {
      final repository = _RecordingRepository();
      await pumpDetail(
        tester,
        offline: false,
        episodeList: episodes(firstDownloaded: false),
        repository: repository,
      );

      expect(find.byTooltip('ダウンロード'), findsNWidgets(2));
      expect(find.byIcon(Icons.check_circle), findsNothing);

      await tester.tap(find.byTooltip('ダウンロード').first);
      await tester.pumpAndSettle();

      expect(repository.downloads, [1]);
      expect(repository.deletes, isEmpty);
      expect(find.text('ダウンロードしました'), findsOneWidget);
      expect(find.byType(BottomSheet), findsNothing);
    });

    testWidgets('ダウンロードに失敗したときは失敗を知らせる', (tester) async {
      final repository = _RecordingRepository()..downloadSucceeds = false;
      await pumpDetail(
        tester,
        offline: false,
        episodeList: episodes(firstDownloaded: false),
        repository: repository,
      );

      await tester.tap(find.byTooltip('ダウンロード').first);
      await tester.pumpAndSettle();

      expect(repository.downloads, [1]);
      expect(find.text('ダウンロードに失敗しました'), findsOneWidget);
    });

    testWidgets('ダウンロード済みの話は確認してから削除する', (tester) async {
      final repository = _RecordingRepository();
      await pumpDetail(
        tester,
        offline: false,
        episodeList: episodes(firstDownloaded: true),
        repository: repository,
      );

      expect(find.byTooltip('ダウンロードを削除'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      await tester.tap(find.byTooltip('ダウンロードを削除'));
      await tester.pumpAndSettle();

      expect(find.text('削除の確認'), findsOneWidget);
      expect(find.text('第1話のダウンロードを削除しますか？'), findsOneWidget);
      expect(repository.deletes, isEmpty);

      await tester.tap(find.text('削除'));
      await tester.pumpAndSettle();

      expect(repository.deletes, [1]);
      expect(find.text('削除しました'), findsOneWidget);
      expect(find.text('削除の確認'), findsNothing);
    });

    testWidgets('削除確認をキャンセルするとダウンロードは残る', (tester) async {
      final repository = _RecordingRepository();
      await pumpDetail(
        tester,
        offline: false,
        episodeList: episodes(firstDownloaded: true),
        repository: repository,
      );

      await tester.tap(find.byTooltip('ダウンロードを削除'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('キャンセル'));
      await tester.pumpAndSettle();

      expect(repository.deletes, isEmpty);
      expect(find.text('削除の確認'), findsNothing);
    });

    testWidgets('オフライン中はダウンロードできない', (tester) async {
      final repository = _RecordingRepository();
      await pumpDetail(
        tester,
        offline: true,
        episodeList: episodes(firstDownloaded: false),
        repository: repository,
      );

      await tester.tap(find.byTooltip('ダウンロード').first);
      await tester.pumpAndSettle();

      expect(repository.downloads, isEmpty);
      expect(
        find.text('オフラインモード中はエピソードのダウンロード・削除ができません'),
        findsOneWidget,
      );
    });

    testWidgets('オフライン中はダウンロード済みの話を削除できない', (tester) async {
      final repository = _RecordingRepository();
      await pumpDetail(
        tester,
        offline: true,
        episodeList: episodes(firstDownloaded: true),
        repository: repository,
      );

      await tester.tap(find.byTooltip('ダウンロードを削除'));
      await tester.pumpAndSettle();

      expect(repository.deletes, isEmpty);
      expect(find.text('削除の確認'), findsNothing);
      expect(
        find.text('オフラインモード中はエピソードのダウンロード・削除ができません'),
        findsOneWidget,
      );
    });

    testWidgets('エピソード行を長押ししても操作メニューは出ない', (tester) async {
      final repository = _RecordingRepository();
      await pumpDetail(
        tester,
        offline: false,
        episodeList: episodes(firstDownloaded: false),
        repository: repository,
      );

      for (final tile in tester.widgetList<ListTile>(find.byType(ListTile))) {
        expect(tile.onLongPress, isNull);
      }

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('第一話')),
      );
      await tester.pump(const Duration(milliseconds: 800));

      expect(find.byType(BottomSheet), findsNothing);
      expect(repository.downloads, isEmpty);
      expect(repository.deletes, isEmpty);

      await gesture.cancel();
    });
  });
}

class _RecordingRepository extends Fake implements NovelRepository {
  final downloads = <int>[];
  final deletes = <int>[];
  bool downloadSucceeds = true;

  @override
  Future<bool> downloadSingleEpisode(
    NovelSource source,
    String workId,
    int episode, {
    String? revised,
  }) async {
    downloads.add(episode);
    return downloadSucceeds;
  }

  @override
  Future<void> deleteDownloadedEpisode(
    NovelSource source,
    String workId,
    int episode,
  ) async {
    deletes.add(episode);
  }
}
