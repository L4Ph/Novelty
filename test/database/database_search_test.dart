import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/database/database.dart';

void main() {
  group('searchLibraryNovels', () {
    late AppDatabase db;

    setUp(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test('空の検索クエリでライブラリ内の全ての小説を返す', () async {
      // テストデータを挿入
      await db.insertNovel(
        NovelsCompanion.insert(
          ncode: 'n1234ab',
          title: const drift.Value('テスト小説1'),
          writer: const drift.Value('テスト作者1'),
          fav: const drift.Value(1),
        ),
      );
      await db.insertNovel(
        NovelsCompanion.insert(
          ncode: 'n5678cd',
          title: const drift.Value('テスト小説2'),
          writer: const drift.Value('テスト作者2'),
          fav: const drift.Value(1),
        ),
      );
      await db.insertNovel(
        NovelsCompanion.insert(
          ncode: 'n9012ef',
          title: const drift.Value('テスト小説3'),
          writer: const drift.Value('テスト作者3'),
          fav: const drift.Value(0), // ライブラリに登録されていない
        ),
      );

      final results = await db.searchLibraryNovels('');
      
      expect(results.length, equals(2));
      expect(results.map((n) => n.ncode), containsAll(['n1234ab', 'n5678cd']));
    });

    test('タイトルで検索できる', () async {
      await db.insertNovel(
        NovelsCompanion.insert(
          ncode: 'n1234ab',
          title: const drift.Value('異世界転生物語'),
          writer: const drift.Value('作者A'),
          fav: const drift.Value(1),
        ),
      );
      await db.insertNovel(
        NovelsCompanion.insert(
          ncode: 'n5678cd',
          title: const drift.Value('現代ファンタジー'),
          writer: const drift.Value('作者B'),
          fav: const drift.Value(1),
        ),
      );

      final results = await db.searchLibraryNovels('異世界');
      
      expect(results.length, equals(1));
      expect(results.first.ncode, equals('n1234ab'));
      expect(results.first.title, equals('異世界転生物語'));
    });

    test('著者名で検索できる', () async {
      await db.insertNovel(
        NovelsCompanion.insert(
          ncode: 'n1234ab',
          title: const drift.Value('小説A'),
          writer: const drift.Value('田中太郎'),
          fav: const drift.Value(1),
        ),
      );
      await db.insertNovel(
        NovelsCompanion.insert(
          ncode: 'n5678cd',
          title: const drift.Value('小説B'),
          writer: const drift.Value('佐藤花子'),
          fav: const drift.Value(1),
        ),
      );

      final results = await db.searchLibraryNovels('田中');
      
      expect(results.length, equals(1));
      expect(results.first.ncode, equals('n1234ab'));
      expect(results.first.writer, equals('田中太郎'));
    });

    test('大文字小文字を区別しない検索', () async {
      await db.insertNovel(
        NovelsCompanion.insert(
          ncode: 'n1234ab',
          title: const drift.Value('Fantasy Adventure'),
          writer: const drift.Value('Writer'),
          fav: const drift.Value(1),
        ),
      );

      final results = await db.searchLibraryNovels('fantasy');
      
      expect(results.length, equals(1));
      expect(results.first.title, equals('Fantasy Adventure'));
    });

    test('検索結果がない場合、空のリストを返す', () async {
      await db.insertNovel(
        NovelsCompanion.insert(
          ncode: 'n1234ab',
          title: const drift.Value('テスト小説'),
          writer: const drift.Value('テスト作者'),
          fav: const drift.Value(1),
        ),
      );

      final results = await db.searchLibraryNovels('存在しないキーワード');
      
      expect(results, isEmpty);
    });

    test('ライブラリに登録されていない小説は検索結果に含まれない', () async {
      await db.insertNovel(
        NovelsCompanion.insert(
          ncode: 'n1234ab',
          title: const drift.Value('ライブラリ登録済み'),
          writer: const drift.Value('作者A'),
          fav: const drift.Value(1),
        ),
      );
      await db.insertNovel(
        NovelsCompanion.insert(
          ncode: 'n5678cd',
          title: const drift.Value('ライブラリ未登録'),
          writer: const drift.Value('作者B'),
          fav: const drift.Value(0),
        ),
      );

      final results = await db.searchLibraryNovels('ライブラリ');
      
      expect(results.length, equals(1));
      expect(results.first.ncode, equals('n1234ab'));
    });
  });
}