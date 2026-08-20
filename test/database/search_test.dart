import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/sites/novel_source.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.memory();
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> addToLibraryAt(String workId, int addedAt) async {
    await db
        .into(db.libraryEntries)
        .insert(
          LibraryEntriesCompanion.insert(
            source: NovelSource.narou,
            workId: workId,
            addedAt: addedAt,
          ),
        );
  }

  test('タイトル・作者・あらすじのいずれかに部分一致すればヒットする', () async {
    // 準備
    await db.insertNovel(
      NovelsCompanion.insert(
        source: NovelSource.narou,
        workId: 'n1234a',
        title: const Value('転生したらスライムだった件'),
        writer: const Value('伏瀬'),
        story: const Value('スライムに転生してしまった。'),
      ),
    );
    await db.addToLibrary(NovelSource.narou, 'n1234a');
    await db.insertNovel(
      NovelsCompanion.insert(
        source: NovelSource.narou,
        workId: 'n5678b',
        title: const Value('無職転生'),
        writer: const Value('理不尽な孫の手'),
        story: const Value('異世界に行きたい。'),
      ),
    );
    await db.addToLibrary(NovelSource.narou, 'n5678b');

    // タイトル検索
    final results1 = await db.searchNovels('スライム');
    expect(results1.length, 1);
    expect(results1.first.title, '転生したらスライムだった件');

    // 作者検索
    final results2 = await db.searchNovels('孫の手');
    expect(results2.length, 1);
    expect(results2.first.title, '無職転生');

    // あらすじ検索
    final results3 = await db.searchNovels('異世界');
    expect(results3.length, 1);
    expect(results3.first.title, '無職転生');

    // 一致なし
    final results4 = await db.searchNovels('ドラゴン');
    expect(results4.isEmpty, true);
  });

  test('クエリを分割せず部分一致する 東京都は東京と京都にヒットしない', () async {
    await db.insertNovel(
      NovelsCompanion.insert(
        source: NovelSource.narou,
        workId: 'n9999z',
        title: const Value('東京と京都'),
        writer: const Value('作者'),
        story: const Value('あらすじ'),
      ),
    );
    await db.addToLibrary(NovelSource.narou, 'n9999z');

    // クエリ全体で部分一致するため、連続する「東京都」は「東京と京都」に含まれずヒットしない
    final results = await db.searchNovels('東京都');
    expect(results.isEmpty, true);
  });

  test('検索結果はライブラリ追加日時の新しい順に並ぶ', () async {
    // 追加日時を明示して 3件 登録する（n0001a が最も古く、n0003c が最新）
    const seeds = [('n0001a', 1000), ('n0002b', 2000), ('n0003c', 3000)];
    for (final (id, addedAt) in seeds) {
      await db.insertNovel(
        NovelsCompanion.insert(
          source: NovelSource.narou,
          workId: id,
          title: const Value('ヒーロー物語'),
          writer: const Value('作者'),
          story: const Value('ヒーローが現れる'),
        ),
      );
      await addToLibraryAt(id, addedAt);
    }

    final results = await db.searchNovels('ヒーロー');
    expect(
      results.map((n) => n.workId).toList(),
      ['n0003c', 'n0002b', 'n0001a'],
    );
  });

  test('Deleting novel removes from search results', () async {
    // 準備
    await db.insertNovel(
      NovelsCompanion.insert(
        source: NovelSource.narou,
        workId: 'n1234a',
        title: const Value('Delete Me'),
      ),
    );
    await db.addToLibrary(NovelSource.narou, 'n1234a');

    // 存在することを確認
    expect((await db.searchNovels('Delete')).length, 1);

    // 実行: novels テーブルから行を削除（ライブラリ検索は JOIN なので対象外になる）
    await db.customStatement(
      "DELETE FROM novels WHERE source = 'narou' AND work_id = ?",
      ['n1234a'],
    );

    // 検証
    expect((await db.searchNovels('Delete')).isEmpty, true);
  });

  test('Search only returns novels in library', () async {
    // ライブラリ内の小説
    await db.insertNovel(
      NovelsCompanion.insert(
        source: NovelSource.narou,
        workId: 'n1111a',
        title: const Value('Library Novel'),
      ),
    );
    await db.addToLibrary(NovelSource.narou, 'n1111a');

    // ライブラリ外の小説
    await db.insertNovel(
      NovelsCompanion.insert(
        source: NovelSource.narou,
        workId: 'n2222b',
        title: const Value('Non-Library Novel'),
      ),
    );

    final results = await db.searchNovels('Novel');

    expect(results.length, 1);
    expect(results.first.workId, 'n1111a');
    expect(results.first.title, 'Library Novel');
  });

  test('LIKE の特殊文字 (% と _) はエスケープされ文字通りに検索される', () async {
    // 準備: 100% を含む小説と、100 を含むが % を含まない小説を用意する
    await db.insertNovel(
      NovelsCompanion.insert(
        source: NovelSource.narou,
        workId: 'n1234a',
        title: const Value('進捗100%達成'),
        writer: const Value('作者'),
        story: const Value('あらすじ'),
      ),
    );
    await db.addToLibrary(NovelSource.narou, 'n1234a');
    await db.insertNovel(
      NovelsCompanion.insert(
        source: NovelSource.narou,
        workId: 'n5678b',
        title: const Value('進捗100万台'),
        writer: const Value('作者'),
        story: const Value('あらすじ'),
      ),
    );
    await db.addToLibrary(NovelSource.narou, 'n5678b');

    // % をワイルドカードとして解釈せず、文字通り「100%」を含むものだけにヒットする
    final results = await db.searchNovels('100%');
    expect(results.length, 1);
    expect(results.first.workId, 'n1234a');
  });

  test('空文字のクエリでは空リストを返す', () async {
    await db.insertNovel(
      NovelsCompanion.insert(
        source: NovelSource.narou,
        workId: 'n1234a',
        title: const Value('タイトル'),
      ),
    );
    await db.addToLibrary(NovelSource.narou, 'n1234a');

    expect(await db.searchNovels(''), isEmpty);
    expect(await db.searchNovels('   '), isEmpty);
  });
}
