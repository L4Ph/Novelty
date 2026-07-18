import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/screens/novel_detail_page.dart';

/// テスト用のライブラリ状態Notifier
class FakeLibraryStatus extends LibraryStatus {
  @override
  Stream<bool> build(String ncode) => Stream.value(false);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NovelDetailPage', () {
    const testNcode = 'n1234ab';

    testWidgets('非公開作品のバナーが表示される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            novelInfoWithCacheProvider.overrideWith(
              (ref, ncode) => Stream.value(
                NovelInfo(
                  ncode: ncode,
                  title: '非公開作品のタイトル',
                  isPrivate: true,
                ),
              ),
            ),
            episodeListProvider.overrideWith(
              (ref, key) => Stream.value(<Episode>[]),
            ),
            downloadProgressProvider.overrideWith(
              (ref, ncode) => Stream.value(null),
            ),
            libraryStatusProvider.overrideWith(FakeLibraryStatus.new),
            lastReadEpisodeProvider.overrideWith(
              (ref, ncode) => Stream.value(null),
            ),
          ],
          child: const MaterialApp(
            home: NovelDetailPage(ncode: testNcode),
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
            novelInfoWithCacheProvider.overrideWith(
              (ref, ncode) => Stream.value(
                NovelInfo(
                  ncode: ncode,
                  title: '公開作品のタイトル',
                ),
              ),
            ),
            episodeListProvider.overrideWith(
              (ref, key) => Stream.value(<Episode>[]),
            ),
            downloadProgressProvider.overrideWith(
              (ref, ncode) => Stream.value(null),
            ),
            libraryStatusProvider.overrideWith(FakeLibraryStatus.new),
            lastReadEpisodeProvider.overrideWith(
              (ref, ncode) => Stream.value(null),
            ),
          ],
          child: const MaterialApp(
            home: NovelDetailPage(ncode: testNcode),
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
  });
}
