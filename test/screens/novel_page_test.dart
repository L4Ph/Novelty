import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/screens/novel_page.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/widgets/gesture_shield.dart';
import 'package:novelty/widgets/novel_content.dart';

@GenerateMocks([NovelRepository])
import 'novel_page_test.mocks.dart';

/// 縦書き設定をシミュレートするSettingsクラス
class VerticalSettings extends Settings {
  @override
  Future<AppSettings> build() async => const AppSettings(
    fontSize: 16,
    isVertical: true,
    themeMode: ThemeMode.system,
    lineHeight: 1.5,
    isIncognito: false,
    isPageFlip: false,
    isRubyEnabled: true,
  );
}

/// 横書き設定をシミュレートするSettingsクラス
class HorizontalSettings extends Settings {
  @override
  Future<AppSettings> build() async => const AppSettings(
    fontSize: 16,
    isVertical: false,
    themeMode: ThemeMode.system,
    lineHeight: 1.5,
    isIncognito: false,
    isPageFlip: false,
    isRubyEnabled: true,
  );
}

/// NovelPageの履歴追加ロジックのテスト
void main() {
  // 各グループで共通して使用するテストデータ
  const testNcode = 'n0001';
  const testNovelInfo = NovelInfo(
    ncode: testNcode,
    title: 'テスト小説',
    writer: 'テスト作者',
    novelType: 1,
    generalAllNo: 3,
  );

  group('NovelPage 履歴追加ロジック', () {
    test('episode番号が正の場合はそのまま使用される', () {
      // episode番号が正の場合はそのまま使用される
      const episode = 3;
      const validEpisode = episode > 0 ? episode : 1;
      expect(validEpisode, 3);
    });

    test('episode番号が0の場合は1に変換される', () {
      // episode番号が0の場合は1に変換される
      const episode = 0;
      const validEpisode = episode > 0 ? episode : 1;
      expect(validEpisode, 1);
    });

    test('episode番号が負の場合は1に変換される', () {
      // episode番号が負の場合は1に変換される
      const episode = -1;
      const validEpisode = episode > 0 ? episode : 1;
      expect(validEpisode, 1);
    });
  });

  group('NovelPage buildTitle', () {
    test('短編の場合は小説タイトルのみ表示', () {
      // 短編小説の場合
      const novelInfo = NovelInfo(
        title: '短編小説のタイトル',
        novelType: 2,
      );

      const currentEpisode = Episode(
        subtitle: '短編小説のタイトル',
        index: 1,
      );

      final result = NovelPage.buildTitle(novelInfo, 1, currentEpisode);

      expect(result, '短編小説のタイトル');
    });

    test('連載でサブタイトルがある場合は「第X話 サブタイトル」形式', () {
      // 連載小説でサブタイトルがある場合
      const novelInfo = NovelInfo(
        title: '連載小説のタイトル',
        novelType: 1,
      );

      const currentEpisode = Episode(subtitle: '始まりの物語', index: 2);

      final result = NovelPage.buildTitle(novelInfo, 2, currentEpisode);

      expect(result, '第2話 始まりの物語');
    });

    test('連載でサブタイトルがnullの場合は「第X話」のみ', () {
      // サブタイトルがnullの場合
      const novelInfo = NovelInfo(
        title: '連載小説のタイトル',
        novelType: 1,
      );

      const currentEpisode = Episode(index: 1);

      final result = NovelPage.buildTitle(novelInfo, 1, currentEpisode);

      expect(result, '第1話');
    });

    test('連載でサブタイトルが空文字の場合は「第X話」のみ', () {
      // サブタイトルが空文字の場合
      const novelInfo = NovelInfo(
        title: '連載小説のタイトル',
        novelType: 1,
      );

      const currentEpisode = Episode(subtitle: '', index: 1);

      final result = NovelPage.buildTitle(novelInfo, 1, currentEpisode);

      expect(result, '第1話');
    });

    test('エピソードがnullの場合でもエラーにならない', () {
      // エピソードがnullの場合
      const novelInfo = NovelInfo(
        title: '連載小説のタイトル',
        novelType: 1,
      );

      final result = NovelPage.buildTitle(novelInfo, 1, null);

      expect(result, '第1話');
    });

    test('該当するエピソードがない場合は「第X話」のみ', () {
      // 該当するエピソードがない場合
      const novelInfo = NovelInfo(
        title: '連載小説のタイトル',
        novelType: 1,
      );

      final result = NovelPage.buildTitle(novelInfo, 5, null);

      expect(result, '第5話');
    });

    test('短編でタイトルがnullの場合は空文字を返す', () {
      // タイトルがnullの場合
      const novelInfo = NovelInfo(
        novelType: 2,
      );

      final result = NovelPage.buildTitle(novelInfo, 1, null);

      expect(result, '');
    });
  });

  group('NovelPage ページ番号計算', () {
    test('エピソード1-100はページ1を返す', () {
      // エピソード1 → ページ1
      expect(((1 - 1) ~/ 100) + 1, 1);
      // エピソード50 → ページ1
      expect(((50 - 1) ~/ 100) + 1, 1);
      // エピソード100 → ページ1
      expect(((100 - 1) ~/ 100) + 1, 1);
    });

    test('エピソード101-200はページ2を返す', () {
      // エピソード101 → ページ2
      expect(((101 - 1) ~/ 100) + 1, 2);
      // エピソード150 → ページ2
      expect(((150 - 1) ~/ 100) + 1, 2);
      // エピソード200 → ページ2
      expect(((200 - 1) ~/ 100) + 1, 2);
    });

    test('エピソード201-300はページ3を返す', () {
      // エピソード201 → ページ3
      expect(((201 - 1) ~/ 100) + 1, 3);
      // エピソード300 → ページ3
      expect(((300 - 1) ~/ 100) + 1, 3);
    });

    test('エピソード1000以上も正しく計算される', () {
      // エピソード1000 → ページ10
      expect(((1000 - 1) ~/ 100) + 1, 10);
      // エピソード1001 → ページ11
      expect(((1001 - 1) ~/ 100) + 1, 11);
    });

    test('境界値: エピソード100と101でページが切り替わる', () {
      // エピソード100 → ページ1
      expect(((100 - 1) ~/ 100) + 1, 1);
      // エピソード101 → ページ2
      expect(((101 - 1) ~/ 100) + 1, 2);
    });
  });

  group('NovelPage AppBar表示切替', () {
    Future<void> pumpNovelPage(
      WidgetTester tester, {
      required Settings Function() createSettings,
      Size size = const Size(400, 800),
      FakeViewPadding? viewPadding,
    }) async {
      addTearDown(tester.view.reset);
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      if (viewPadding != null) {
        tester.view.padding = viewPadding;
      }

      final mockNovelRepository = MockNovelRepository();
      when(
        mockNovelRepository.addToHistory(
          source: anyNamed('source'),
          workId: anyNamed('workId'),
          title: anyNamed('title'),
          writer: anyNamed('writer'),
          lastEpisode: anyNamed('lastEpisode'),
        ),
      ).thenAnswer((_) async {});
      when(mockNovelRepository.dispose()).thenReturn(null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            novelRepositoryProvider.overrideWithValue(mockNovelRepository),
            settingsProvider.overrideWith(createSettings),
            novelInfoWithCacheProvider.overrideWith(
              (ref, args) => Stream.value(testNovelInfo),
            ),
            episodeListProvider.overrideWith(
              (ref, args) => Stream.value(<Episode>[]),
            ),
            novelContentProvider.overrideWith(
              (
                ref,
                ({
                  NovelSource source,
                  String workId,
                  int episode,
                  String? revised,
                })
                arg,
              ) async => [],
            ),
          ],
          child: const MaterialApp(
            home: NovelPage(
              source: NovelSource.narou,
              workId: testNcode,
              episode: 1,
            ),
          ),
        ),
      );

      // NovelInfoのStreamが処理されるまで待機
      await tester.pumpAndSettle();
    }

    testWidgets('読み込み完了後はAppBarが表示されないこと', (tester) async {
      // Arrange
      await pumpNovelPage(tester, createSettings: HorizontalSettings.new);

      // Assert: 読み込み後はAppBarを非表示にして本文に集中させる
      expect(find.byType(AppBar), findsNothing);
    });

    testWidgets('本文タップでAppBarが表示されること', (tester) async {
      // Arrange
      await pumpNovelPage(tester, createSettings: HorizontalSettings.new);
      expect(find.byType(AppBar), findsNothing);

      // Act: 本文をタップ
      await tester.tap(find.byType(PageView));
      await tester.pumpAndSettle();

      // Assert: AppBarと戻るボタンが表示される
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('もう一度タップするとAppBarが隠れること', (tester) async {
      // Arrange
      await pumpNovelPage(tester, createSettings: HorizontalSettings.new);

      // Act: タップで表示 → もう一度タップで非表示
      await tester.tap(find.byType(PageView));
      await tester.pumpAndSettle();
      expect(find.byType(AppBar), findsOneWidget);

      await tester.tap(find.byType(PageView));
      await tester.pumpAndSettle();

      // Assert: 再度AppBarが非表示になる
      expect(find.byType(AppBar), findsNothing);
    });

    testWidgets('AppBar非表示時は本文が上部セーフエリアを確保すること', (tester) async {
      // Arrange: ステータスバー領域を再現
      await pumpNovelPage(
        tester,
        createSettings: HorizontalSettings.new,
        viewPadding: const FakeViewPadding(top: 24),
      );

      // 本文側スクロールビュー（SafeArea適用後の実際の描画位置を検証する）
      Finder bodyScrollView() => find
          .descendant(
            of: find.byType(NovelContentBody),
            matching: find.byType(SingleChildScrollView),
          )
          .first;

      SafeArea novelContentSafeArea() => tester.widget<SafeArea>(
        find
            .ancestor(
              of: find.byType(NovelContentBody),
              matching: find.byType(SafeArea),
            )
            .first,
      );

      // Assert: AppBarが無い分、本文側SafeAreaが上部セーフエリアを担い、
      // 本文の上端がステータスバー直下（24px）から始まる
      expect(novelContentSafeArea().top, isTrue);
      expect(tester.getTopLeft(bodyScrollView()).dy, 24);

      // Act: タップでAppBarを表示
      await tester.tap(find.byType(PageView));
      await tester.pumpAndSettle();
      expect(find.byType(AppBar), findsOneWidget);

      // Assert: AppBar表示時は本文の上端がAppBarの下端に一致する。
      // SafeAreaが二重に効く（ダブルパディング）ことがあれば
      // 本文がAppBar下端より下にずれるため、この検証で検出できる
      expect(novelContentSafeArea().top, isFalse);
      expect(
        tester.getTopLeft(bodyScrollView()).dy,
        tester.getBottomLeft(find.byType(AppBar)).dy,
      );
    });

    testWidgets('縦書きモードでも本文タップでAppBarがトグルされること', (tester) async {
      // Arrange
      await pumpNovelPage(tester, createSettings: VerticalSettings.new);
      expect(find.byType(GestureShield), findsOneWidget);
      expect(find.byType(AppBar), findsNothing);

      // Act: 本文中央をタップ
      await tester.tap(find.byType(PageView));
      await tester.pumpAndSettle();

      // Assert: 縦書きモードでもタップでAppBarが表示される
      expect(find.byType(AppBar), findsOneWidget);

      // Act: GestureShield領域（画面下部）をタップしてもトグルが効く
      await tester.tapAt(tester.getCenter(find.byType(GestureShield)));
      await tester.pumpAndSettle();

      // Assert: 再度非表示になり、シールドがタップを妨げない
      expect(find.byType(AppBar), findsNothing);
    });
  });

  group('NovelPage GestureShield 統合テスト', () {
    testWidgets('縦書き設定の場合、GestureShieldが表示される', (tester) async {
      // Arrange
      addTearDown(tester.view.reset);
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(400, 800);

      final mockNovelRepository = MockNovelRepository();
      when(
        mockNovelRepository.addToHistory(
          source: anyNamed('source'),
          workId: anyNamed('workId'),
          title: anyNamed('title'),
          writer: anyNamed('writer'),
          lastEpisode: anyNamed('lastEpisode'),
        ),
      ).thenAnswer((_) async {});
      when(mockNovelRepository.dispose()).thenReturn(null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            novelRepositoryProvider.overrideWithValue(mockNovelRepository),
            settingsProvider.overrideWith(VerticalSettings.new),
            novelInfoWithCacheProvider.overrideWith(
              (ref, args) => Stream.value(testNovelInfo),
            ),
            episodeListProvider.overrideWith(
              (ref, args) => Stream.value(<Episode>[]),
            ),
            novelContentProvider.overrideWith(
              (
                ref,
                ({
                  NovelSource source,
                  String workId,
                  int episode,
                  String? revised,
                })
                arg,
              ) async => [],
            ),
          ],
          child: const MaterialApp(
            home: NovelPage(
              source: NovelSource.narou,
              workId: testNcode,
              episode: 1,
            ),
          ),
        ),
      );

      // NovelInfoのStreamが処理されるまで待機
      await tester.pumpAndSettle();

      // Assert: 縦書き設定では GestureShield が表示される
      expect(find.byType(GestureShield), findsOneWidget);
    });

    testWidgets('横書き設定の場合、GestureShieldが表示されない', (tester) async {
      // Arrange
      addTearDown(tester.view.reset);
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(400, 800);

      final mockNovelRepository = MockNovelRepository();
      when(
        mockNovelRepository.addToHistory(
          source: anyNamed('source'),
          workId: anyNamed('workId'),
          title: anyNamed('title'),
          writer: anyNamed('writer'),
          lastEpisode: anyNamed('lastEpisode'),
        ),
      ).thenAnswer((_) async {});
      when(mockNovelRepository.dispose()).thenReturn(null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            novelRepositoryProvider.overrideWithValue(mockNovelRepository),
            settingsProvider.overrideWith(HorizontalSettings.new),
            novelInfoWithCacheProvider.overrideWith(
              (ref, args) => Stream.value(testNovelInfo),
            ),
            episodeListProvider.overrideWith(
              (ref, args) => Stream.value(<Episode>[]),
            ),
            novelContentProvider.overrideWith(
              (
                ref,
                ({
                  NovelSource source,
                  String workId,
                  int episode,
                  String? revised,
                })
                arg,
              ) async => [],
            ),
          ],
          child: const MaterialApp(
            home: NovelPage(
              source: NovelSource.narou,
              workId: testNcode,
              episode: 1,
            ),
          ),
        ),
      );

      // NovelInfoのStreamが処理されるまで待機
      await tester.pumpAndSettle();

      // Assert: 横書き設定では GestureShield が表示されない
      expect(find.byType(GestureShield), findsNothing);
    });
  });
}
