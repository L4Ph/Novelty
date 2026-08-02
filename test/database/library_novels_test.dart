import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/sites/novel_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LibraryEntries テーブル', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase.memory();
    });

    tearDown(() async {
      await database.close();
    });

    Future<void> insertDummyNovel(String ncode) async {
      await database
          .into(database.novels)
          .insert(
            NovelsCompanion(
              source: const Value(NovelSource.narou),
              workId: Value(ncode),
              title: Value('Title $ncode'),
              writer: Value('Writer $ncode'),
            ),
          );
    }

    test('ライブラリ小説の追加ができること', () async {
      const ncode = 'n1234ab';
      await insertDummyNovel(ncode);

      await database.addToLibrary(NovelSource.narou, ncode);

      final novels = await database.getLibraryNovels();
      expect(novels.length, 1);
      expect(novels.first.workId, ncode);
    });

    test('ライブラリ小説の削除ができること', () async {
      const ncode = 'n1234ab';
      await insertDummyNovel(ncode);

      // 追加
      await database.addToLibrary(NovelSource.narou, ncode);

      // 削除
      await database.removeFromLibrary(NovelSource.narou, ncode);

      final novels = await database.getLibraryNovels();
      expect(novels.length, 0);
    });

    test('ライブラリ状態の確認ができること', () async {
      const ncode = 'n1234ab';
      await insertDummyNovel(ncode);

      // 初期状態では登録されていない
      expect(await database.isInLibrary(NovelSource.narou, ncode), false);

      // 追加
      await database.addToLibrary(NovelSource.narou, ncode);

      // 登録されている
      expect(await database.isInLibrary(NovelSource.narou, ncode), true);
    });

    test('ライブラリ状態の監視ができること', () async {
      const ncode = 'n1234ab';
      await insertDummyNovel(ncode);

      // 初期状態の監視
      final stream = database.watchIsInLibrary(NovelSource.narou, ncode);

      expect(await stream.first, false);

      // 追加
      await database.addToLibrary(NovelSource.narou, ncode);

      expect(await stream.first, true);
    });

    test('追加日時順でソートされること', () async {
      // 複数の小説を追加（時間をずらして）
      await insertDummyNovel('n1234ab');
      await database.addToLibrary(NovelSource.narou, 'n1234ab');
      await Future<void>.delayed(const Duration(milliseconds: 10));

      await insertDummyNovel('n5678cd');
      await database.addToLibrary(NovelSource.narou, 'n5678cd');
      await Future<void>.delayed(const Duration(milliseconds: 10));

      await insertDummyNovel('n9012ef');
      await database.addToLibrary(NovelSource.narou, 'n9012ef');

      final novels = await database.getLibraryNovels();

      // 最新追加順（降順）でソートされていることを確認
      expect(novels.length, 3);
      expect(novels[0].workId, 'n9012ef');
      expect(novels[1].workId, 'n5678cd');
      expect(novels[2].workId, 'n1234ab');
    });

    test('重複追加は無視されること', () async {
      const ncode = 'n1234ab';
      await insertDummyNovel(ncode);

      // 同じ小説を2回追加
      await database.addToLibrary(NovelSource.narou, ncode);
      await database.addToLibrary(NovelSource.narou, ncode);

      final novels = await database.getLibraryNovels();
      expect(novels.length, 1);
    });
  });
}
