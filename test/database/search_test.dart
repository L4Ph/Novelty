import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:narou_parser/narou_parser.dart';
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

  test('Search novels returns correct results', () async {
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

    // 実行と検証
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

  test('Search episodes returns correct results', () async {
    // 準備
    await db.insertNovel(
      NovelsCompanion.insert(
        source: NovelSource.narou,
        workId: 'n1234a',
        title: const Value('Test Novel'),
      ),
    );
    await db.addToLibrary(NovelSource.narou, 'n1234a');
    await db.upsertEpisodes([
      EpisodeListEntriesCompanion.insert(
        source: NovelSource.narou,
        workId: 'n1234a',
        episodeId: 1,
        subtitle: const Value('プロローグ'),
      ),
      EpisodeListEntriesCompanion.insert(
        source: NovelSource.narou,
        workId: 'n1234a',
        episodeId: 2,
        subtitle: const Value('旅立ち'),
      ),
    ]);

    // 本文を更新（updateEpisodeContent 経由で FTS も更新される）
    await db.updateEpisodeContent(
      source: NovelSource.narou,
      workId: 'n1234a',
      episodeId: 1,
      content: [
        NovelContentElement.plainText('昔々あるところに'),
      ],
      fetchedAt: 1234567890,
      subtitle: 'プロローグ',
      url: 'http://example.com/1',
    );

    await db.updateEpisodeContent(
      source: NovelSource.narou,
      workId: 'n1234a',
      episodeId: 2,
      content: [
        NovelContentElement.plainText('勇者は旅に出た'),
      ],
      fetchedAt: 1234567890,
      subtitle: '旅立ち',
      url: 'http://example.com/2',
    );

    // 実行と検証
    // サブタイトル検索
    final results1 = await db.searchEpisodes('プロローグ');
    expect(results1.length, 1);
    expect(results1.first.subtitle, 'プロローグ');

    // 本文検索
    final results2 = await db.searchEpisodes('勇者は'); // 3文字で試す
    expect(results2.length, 1);
    expect(results2.first.subtitle, '旅立ち');

    // 一致なし
    final results3 = await db.searchEpisodes('魔王');
    expect(results3.isEmpty, true);
  });

  test('サブタイトルが変更されても本文が同一でも検索インデックスが更新されること', () async {
    // 準備
    await db.insertNovel(
      NovelsCompanion.insert(
        source: NovelSource.narou,
        workId: 'n1234a',
        title: const Value('Test Novel'),
      ),
    );
    await db.addToLibrary(NovelSource.narou, 'n1234a');
    await db.upsertEpisodes([
      EpisodeListEntriesCompanion.insert(
        source: NovelSource.narou,
        workId: 'n1234a',
        episodeId: 1,
        subtitle: const Value('旧サブタイトル'),
      ),
    ]);

    // 本文を保存してインデックスを作成
    await db.updateEpisodeContent(
      source: NovelSource.narou,
      workId: 'n1234a',
      episodeId: 1,
      content: [
        NovelContentElement.plainText('本文はそのまま'),
      ],
      fetchedAt: 1234567890,
      subtitle: '旧サブタイトル',
      url: 'http://example.com/1',
    );
    expect((await db.searchEpisodes('旧サブタイトル')).length, 1);

    // サブタイトルのみ変更
    await db.updateEpisodeContent(
      source: NovelSource.narou,
      workId: 'n1234a',
      episodeId: 1,
      content: [
        NovelContentElement.plainText('本文はそのまま'),
      ],
      fetchedAt: 1234567891,
      subtitle: '新サブタイトル',
      url: 'http://example.com/1',
    );

    // 新サブタイトルで検索できるようになっていること
    final results = await db.searchEpisodes('新サブタイトル');
    expect(results.length, 1);
    expect(results.first.subtitle, '新サブタイトル');

    // 旧サブタイトルでは検索できないこと
    expect((await db.searchEpisodes('旧サブタイトル')).isEmpty, true);
  });

  test('Deleting novel removes from search index', () async {
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

    // 実行
    // AppDatabase にはまだ deleteNovel メソッドが無いが、
    // removeFromLibrary がカスケード削除するか?
    // 実際には removeFromLibrary は library_entries からしか削除しない。
    // 'novels' テーブルのトリガーを検証する必要がある。
    // テスト目的で customStatement を使用して削除するか、
    // deleteNovel メソッドを追加する。
    // カスケードするなら deleteHistory を使う? いや。

    // テスト用の削除ヘルパーを追加するか、customStatement を使用する。
    await db.customStatement(
      "DELETE FROM novels WHERE source = 'narou' AND work_id = ?",
      ['n1234a'],
    );

    // 検証
    expect((await db.searchNovels('Delete')).isEmpty, true);
  });

  test('Search only returns novels in library', () async {
    // 準備
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

    // 実行
    final results = await db.searchNovels('Novel');

    // 検証
    expect(results.length, 1);
    expect(results.first.workId, 'n1111a');
    expect(results.first.title, 'Library Novel');
  });

  test('Search filters out Bigram noise', () async {
    // 準備
    await db.insertNovel(
      NovelsCompanion.insert(
        source: NovelSource.narou,
        workId: 'n9999z',
        title: const Value('東京と京都'),
      ),
    );
    await db.addToLibrary(NovelSource.narou, 'n9999z');

    // Act
    final results = await db.searchNovels('東京都');

    // Assert
    expect(results.isEmpty, true);
  });
}
