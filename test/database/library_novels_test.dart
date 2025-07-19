import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/database/database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('LibraryNovels テーブル', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase.memory();
    });

    tearDown(() async {
      await database.close();
    });

    test('ライブラリ小説の追加ができること', () async {
      const ncode = 'n1234ab';
      final addedAt = DateTime.now().millisecondsSinceEpoch;

      await database.addToLibrary(
        LibraryNovelsCompanion(
          ncode: const Value(ncode),
          addedAt: Value(addedAt),
        ),
      );

      final novels = await database.getLibraryNovels();
      expect(novels.length, 1);
      expect(novels.first.ncode, ncode);
      expect(novels.first.addedAt, addedAt);
    });

    test('ライブラリ小説の削除ができること', () async {
      const ncode = 'n1234ab';
      final addedAt = DateTime.now().millisecondsSinceEpoch;

      // 追加
      await database.addToLibrary(
        LibraryNovelsCompanion(
          ncode: const Value(ncode),
          addedAt: Value(addedAt),
        ),
      );

      // 削除
      await database.removeFromLibrary(ncode);

      final novels = await database.getLibraryNovels();
      expect(novels.length, 0);
    });

    test('ライブラリ状態の確認ができること', () async {
      const ncode = 'n1234ab';
      final addedAt = DateTime.now().millisecondsSinceEpoch;

      // 初期状態では登録されていない
      expect(await database.isInLibrary(ncode), false);

      // 追加
      await database.addToLibrary(
        LibraryNovelsCompanion(
          ncode: const Value(ncode),
          addedAt: Value(addedAt),
        ),
      );

      // 登録されている
      expect(await database.isInLibrary(ncode), true);
    });

    test('ライブラリ状態の監視ができること', () async {
      const ncode = 'n1234ab';
      final addedAt = DateTime.now().millisecondsSinceEpoch;

      // 初期状態の監視
      final stream = database.watchIsInLibrary(ncode);
      
      expect(await stream.first, false);

      // 追加
      await database.addToLibrary(
        LibraryNovelsCompanion(
          ncode: const Value(ncode),
          addedAt: Value(addedAt),
        ),
      );

      expect(await stream.first, true);
    });

    test('追加日時順でソートされること', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      
      // 複数の小説を追加（時間をずらして）
      await database.addToLibrary(
        LibraryNovelsCompanion(
          ncode: const Value('n1234ab'),
          addedAt: Value(now),
        ),
      );
      
      await database.addToLibrary(
        LibraryNovelsCompanion(
          ncode: const Value('n5678cd'),
          addedAt: Value(now + 1000),
        ),
      );
      
      await database.addToLibrary(
        LibraryNovelsCompanion(
          ncode: const Value('n9012ef'),
          addedAt: Value(now + 2000),
        ),
      );

      final novels = await database.getLibraryNovels();
      
      // 最新追加順（降順）でソートされていることを確認
      expect(novels.length, 3);
      expect(novels[0].ncode, 'n9012ef');
      expect(novels[1].ncode, 'n5678cd');
      expect(novels[2].ncode, 'n1234ab');
    });

    test('重複追加は無視されること', () async {
      const ncode = 'n1234ab';
      final addedAt = DateTime.now().millisecondsSinceEpoch;

      // 同じ小説を2回追加
      await database.addToLibrary(
        LibraryNovelsCompanion(
          ncode: const Value(ncode),
          addedAt: Value(addedAt),
        ),
      );
      
      await database.addToLibrary(
        LibraryNovelsCompanion(
          ncode: const Value(ncode),
          addedAt: Value(addedAt + 1000),
        ),
      );

      final novels = await database.getLibraryNovels();
      expect(novels.length, 1);
      // 最初の追加日時が保持されることを確認
      expect(novels.first.addedAt, addedAt);
    });
  });
}
