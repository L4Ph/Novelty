import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/database/database.dart';

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
              ncode: Value(ncode),
              title: Value('Title $ncode'),
              writer: Value('Writer $ncode'),
            ),
          );
    }

    test('ライブラリ小説の追加ができること', () async {
      const ncode = 'n1234ab';
      await insertDummyNovel(ncode);

      await database.addToLibrary(ncode);

      final novels = await database.getLibraryNovels();
      expect(novels.length, 1);
      expect(novels.first.ncode, ncode);
    });

    test('ライブラリ小説の削除ができること', () async {
      const ncode = 'n1234ab';
      await insertDummyNovel(ncode);

      // 追加
      await database.addToLibrary(ncode);

      // 削除
      await database.removeFromLibrary(ncode);

      final novels = await database.getLibraryNovels();
      expect(novels.length, 0);
    });

    test('ライブラリ状態の確認ができること', () async {
      const ncode = 'n1234ab';
      await insertDummyNovel(ncode);

      // 初期状態では登録されていない
      expect(await database.isInLibrary(ncode), false);

      // 追加
      await database.addToLibrary(ncode);

      // 登録されている
      expect(await database.isInLibrary(ncode), true);
    });

    test('ライブラリ状態の監視ができること', () async {
      const ncode = 'n1234ab';
      await insertDummyNovel(ncode);

      // 初期状態の監視
      final stream = database.watchIsInLibrary(ncode);

      expect(await stream.first, false);

      // 追加
      await database.addToLibrary(ncode);

      expect(await stream.first, true);
    });

    test('追加日時順でソートされること', () async {
      // 複数の小説を追加（時間をずらして）
      await insertDummyNovel('n1234ab');
      await database.addToLibrary('n1234ab');
      await Future<void>.delayed(const Duration(milliseconds: 10));

      await insertDummyNovel('n5678cd');
      await database.addToLibrary('n5678cd');
      await Future<void>.delayed(const Duration(milliseconds: 10));

      await insertDummyNovel('n9012ef');
      await database.addToLibrary('n9012ef');

      final novels = await database.getLibraryNovels();

      // 最新追加順（降順）でソートされていることを確認
      expect(novels.length, 3);
      expect(novels[0].ncode, 'n9012ef');
      expect(novels[1].ncode, 'n5678cd');
      expect(novels[2].ncode, 'n1234ab');
    });

    test('重複追加は無視されること', () async {
      const ncode = 'n1234ab';
      await insertDummyNovel(ncode);

      // 同じ小説を2回追加
      await database.addToLibrary(ncode);
      await database.addToLibrary(ncode);

      final novels = await database.getLibraryNovels();
      expect(novels.length, 1);
    });
  });
}
