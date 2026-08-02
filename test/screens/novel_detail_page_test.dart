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
  });
}
