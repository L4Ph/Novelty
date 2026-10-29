import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/screens/library_page.dart';
import 'package:novelty/sites/novel_source.dart';

class _RecordingRepository extends Fake implements NovelRepository {
  final removed = <(NovelSource, String)>[];

  @override
  Future<void> removeFromLibrary(NovelSource source, String workId) async {
    removed.add((source, workId));
  }
}

Novel _novel({
  required String workId,
  required String title,
}) {
  return Novel(
    source: NovelSource.narou,
    workId: workId,
    title: title,
    writer: 'テスト作者',
    novelType: 1,
    end: 1,
    genreId: '101',
    isPrivate: false,
  );
}

Future<void> _pumpLibrary(
  WidgetTester tester, {
  required List<Novel> novels,
  required NovelRepository repository,
}) async {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        libraryNovelsProvider.overrideWith(
          (ref) => Stream<List<dynamic>>.value(<dynamic>[...novels]),
        ),
        novelRepositoryProvider.overrideWithValue(repository),
      ],
      child: const MaterialApp(
        home: LibraryPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LibraryPage の行メニュー', () {
    testWidgets('各行の右端にメニューがあり、削除を選ぶと確認ダイアログが出る', (tester) async {
      final repository = _RecordingRepository();
      await _pumpLibrary(
        tester,
        novels: [
          _novel(workId: 'n1111aa', title: '最初の小説'),
          _novel(workId: 'n2222bb', title: '次の小説'),
        ],
        repository: repository,
      );

      expect(find.byTooltip('メニュー'), findsNWidgets(2));
      expect(find.text('ライブラリから削除'), findsNothing);

      await tester.tap(find.byTooltip('メニュー').first);
      await tester.pumpAndSettle();

      expect(find.text('ライブラリから削除'), findsOneWidget);

      await tester.tap(find.text('ライブラリから削除'));
      await tester.pumpAndSettle();

      expect(find.text('削除の確認'), findsOneWidget);
      expect(find.text('"最初の小説"をライブラリから削除しますか？'), findsOneWidget);
      expect(repository.removed, isEmpty);
    });

    testWidgets('確認で削除するとライブラリから削除される', (tester) async {
      final repository = _RecordingRepository();
      await _pumpLibrary(
        tester,
        novels: [
          _novel(workId: 'n1111aa', title: '最初の小説'),
        ],
        repository: repository,
      );

      await tester.tap(find.byTooltip('メニュー'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ライブラリから削除'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('削除'));
      await tester.pumpAndSettle();

      expect(repository.removed, [(NovelSource.narou, 'n1111aa')]);
      expect(find.text('ライブラリから削除しました'), findsOneWidget);
      expect(find.text('削除の確認'), findsNothing);
    });

    testWidgets('確認をキャンセルしても削除されない', (tester) async {
      final repository = _RecordingRepository();
      await _pumpLibrary(
        tester,
        novels: [
          _novel(workId: 'n1111aa', title: '最初の小説'),
        ],
        repository: repository,
      );

      await tester.tap(find.byTooltip('メニュー'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ライブラリから削除'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('キャンセル'));
      await tester.pumpAndSettle();

      expect(repository.removed, isEmpty);
      expect(find.text('削除の確認'), findsNothing);
    });

    testWidgets('行を長押ししても削除確認は出ない', (tester) async {
      final repository = _RecordingRepository();
      await _pumpLibrary(
        tester,
        novels: [
          _novel(workId: 'n1111aa', title: '最初の小説'),
        ],
        repository: repository,
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('最初の小説')),
      );
      await tester.pump(const Duration(milliseconds: 800));

      expect(find.text('削除の確認'), findsNothing);
      expect(repository.removed, isEmpty);

      await gesture.cancel();
    });
  });
}
