import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_download_summary.dart';
import 'package:novelty/utils/ncode_utils.dart';
import 'package:novelty/utils/search_tokenizer.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

export 'database_providers.dart';

part 'database.g.dart';

/// 小説のコンテンツをデータベースに保存するための変換クラス
class ContentConverter
    extends TypeConverter<List<NovelContentElement>, String> {
  /// コンストラクタ
  const ContentConverter();

  @override
  List<NovelContentElement> fromSql(String fromDb) {
    if (fromDb.isEmpty) {
      return [];
    }
    final decoded = json.decode(fromDb) as List;
    return decoded
        .map(
          (dynamic e) =>
              NovelContentElement.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  String toSql(List<NovelContentElement> value) {
    return value.toJsonString();
  }
}

/// 履歴データのDTOクラス
/// 旧Historyテーブルのデータクラスと互換性を持たせるために定義
@immutable
class HistoryData {
  /// コンストラクタ
  const HistoryData({
    required this.ncode,
    required this.viewedAt,
    required this.updatedAt,
    this.title,
    this.writer,
    this.lastEpisode,
  });

  /// 小説のNコード
  final String ncode;

  /// タイトル
  final String? title;

  /// 作者名
  final String? writer;

  /// 最後に読んだエピソード番号
  final int? lastEpisode;

  /// 閲覧日時（UNIXタイムスタンプ）
  final int viewedAt;

  /// 更新日時（UNIXタイムスタンプ）
  final int updatedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryData &&
          runtimeType == other.runtimeType &&
          ncode == other.ncode &&
          title == other.title &&
          writer == other.writer &&
          lastEpisode == other.lastEpisode &&
          viewedAt == other.viewedAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      ncode.hashCode ^
      title.hashCode ^
      writer.hashCode ^
      lastEpisode.hashCode ^
      viewedAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() {
    return 'HistoryData(ncode: $ncode, title: $title, writer: $writer, lastEpisode: $lastEpisode, viewedAt: $viewedAt, updatedAt: $updatedAt)';
  }
}

// テーブル定義
/// 小説情報を格納するテーブル（マスターテーブル）
class Novels extends Table {
  /// 小説のncode
  TextColumn get ncode => text()();

  /// 小説のタイトル
  TextColumn get title => text().nullable()();

  /// 小説の著者
  TextColumn get writer => text().nullable()();

  /// 小説のあらすじ
  TextColumn get story => text().nullable()();

  /// 小説の種別
  /// 0: 短編 1: 連載中
  IntColumn get novelType => integer().nullable()();

  /// 小説の状態
  /// 0: 短編 or 完結済 1: 連載中
  IntColumn get end => integer().nullable()();

  /// ジャンル
  IntColumn get genre => integer().nullable()();

  /// 作品に含まれる要素に「R15」が含まれる場合は1、それ以外は0
  IntColumn get isr15 => integer().nullable()();

  /// 作品に含まれる要素に「ボーイズラブ」が含まれる場合は1、それ以外は0
  IntColumn get isbl => integer().nullable()();

  /// 作品に含まれる要素に「ガールズラブ」が含まれる場合は1、それ以外は0
  IntColumn get isgl => integer().nullable()();

  /// 作品に含まれる要素に「残酷な描写あり」が含まれる場合は1、それ以外は0
  IntColumn get iszankoku => integer().nullable()();

  /// 作品に含まれる要素に「異世界転生」が含まれる場合は1、それ以外は0
  IntColumn get istensei => integer().nullable()();

  /// 作品に含まれる要素に「異世界転移」が含まれる場合は1、それ以外は0
  IntColumn get istenni => integer().nullable()();

  /// キーワード
  TextColumn get keyword => text().nullable()();

  /// 初回掲載日 YYYY-MM-DD HH:MM:SS
  IntColumn get generalFirstup => integer().nullable()();

  /// 最終掲載日 YYYY-MM-DD HH:MM:SS
  IntColumn get generalLastup => integer().nullable()();

  /// 総合評価ポイント (ブックマーク数×2)+評価ポイントで算出
  IntColumn get globalPoint => integer().nullable()();

  /// Noveltyのライブラリに登録されているかどうか
  /// 1: 登録済み、0: 未登録
  /// DEPRECATED: LibraryEntriesテーブルを使用するため、このカラムは使用しない
  IntColumn get fav => integer().nullable()();

  /// レビュー数
  IntColumn get reviewCount => integer().nullable()();

  /// レビューの平均評価(?)
  IntColumn get rateCount => integer().nullable()();

  /// 評価ポイント
  IntColumn get allPoint => integer().nullable()();

  /// ポイント数(何の用途か不明)
  IntColumn get pointCount => integer().nullable()();

  /// 日間ポイント
  IntColumn get dailyPoint => integer().nullable()();

  /// 週間ポイント
  IntColumn get weeklyPoint => integer().nullable()();

  /// 月間ポイント
  IntColumn get monthlyPoint => integer().nullable()();

  /// 四半期ポイント
  IntColumn get quarterPoint => integer().nullable()();

  /// 年間ポイント
  IntColumn get yearlyPoint => integer().nullable()();

  /// 連載小説のエピソード数 短編は常に1
  IntColumn get generalAllNo => integer().nullable()();

  /// 作品の更新日時
  TextColumn get novelUpdatedAt => text().nullable()();

  /// キャッシュ日時(?)
  IntColumn get cachedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {ncode};
}

/// ライブラリ登録情報を格納するテーブル（正規化済み）
class LibraryEntries extends Table {
  /// 小説のncode (外部キー)
  TextColumn get ncode => text().references(Novels, #ncode)();

  /// ライブラリに追加された日時
  /// UNIXタイムスタンプ形式で保存される
  IntColumn get addedAt => integer()();

  @override
  Set<Column> get primaryKey => {ncode};
}

/// 閲覧履歴を格納するテーブル（正規化済み）
class ReadingHistory extends Table {
  /// 小説のncode (外部キー)
  TextColumn get ncode => text().references(Novels, #ncode)();

  /// 最後に閲覧したエピソード番号
  IntColumn get lastEpisodeId => integer().nullable()();

  /// 閲覧日時
  IntColumn get viewedAt => integer()();

  /// 更新日時
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {ncode};
}

/// エピソード情報を格納するテーブル（メタデータ + コンテンツ）
/// Domain ModelのEpisodeと名前が被るため、Entityを明示
@DataClassName('EpisodeRow')
class EpisodeEntities extends Table {
  @override
  String get tableName => 'episodes';

  /// 小説のncode (外部キー)
  TextColumn get ncode => text().references(Novels, #ncode)();

  /// エピソード番号
  IntColumn get episodeId => integer()();

  /// サブタイトル（目次用）
  TextColumn get subtitle => text().nullable()();

  /// URL
  TextColumn get url => text().nullable()();

  /// 掲載日（APIのupdate）
  TextColumn get publishedAt => text().nullable()();

  /// 改稿日（APIのrevised）
  TextColumn get revisedAt => text().nullable()();

  /// エピソードの内容（キャッシュ）
  /// JSON形式で保存される。空配列=失敗、中身あり=成功、NULL=未取得
  TextColumn get content => text().map(const ContentConverter()).nullable()();

  /// コンテンツ取得日時
  IntColumn get fetchedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {ncode, episodeId};
}

@DriftDatabase(
  tables: [
    Novels,
    LibraryEntries,
    ReadingHistory,
    EpisodeEntities,
  ],
)
/// アプリケーションのデータベース
class AppDatabase extends _$AppDatabase {
  /// コンストラクタ
  AppDatabase() : super(_openConnection());

  /// テスト用コンストラクタ
  AppDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 14;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _createFtsTables();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 12) {
          // Ensure new tables are fresh (in case of previous failed migration)
          await customStatement('DROP TABLE IF EXISTS episodes');
          await customStatement('DROP TABLE IF EXISTS library_entries');
          await customStatement('DROP TABLE IF EXISTS reading_history');

          // 1. Create new tables
          await m.createTable(novels);
          await m.createTable(libraryEntries);
          await m.createTable(readingHistory);
          await m.createTable(episodeEntities);

          // 2. Migrate LibraryNovels -> LibraryEntries & Novels
          await customStatement('''
              INSERT OR IGNORE INTO novels (
                ncode, title, writer, story, novel_type, "end", general_all_no, novel_updated_at
              )
              SELECT 
                ncode, title, writer, story, novel_type, "end", general_all_no, novel_updated_at
              FROM library_novels;
            ''');

          await customStatement('''
              INSERT OR IGNORE INTO library_entries (ncode, added_at)
              SELECT ncode, added_at FROM library_novels;
            ''');

          // 3. Migrate History -> ReadingHistory & Novels
          await customStatement('''
              INSERT OR IGNORE INTO novels (ncode, cached_at)
              SELECT ncode, viewed_at FROM history;
            ''');

          await customStatement('''
              INSERT INTO reading_history (ncode, last_episode_id, viewed_at, updated_at)
              SELECT ncode, last_episode, viewed_at, updated_at FROM history;
            ''');

          // 4. Migrate CachedEpisodes -> Episodes

          // Check if cached_episodes table exists
          final cachedEpisodesResult = await customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='cached_episodes'",
          ).get();

          if (cachedEpisodesResult.isNotEmpty) {
            await customStatement('''
                INSERT INTO episodes (ncode, episode_id, content, fetched_at, revised_at)
                SELECT ncode, episode, content, cached_at, revised FROM cached_episodes;
              ''');
          }

          // 5. Drop old tables
          await customStatement('DROP TABLE IF EXISTS library_novels');
          await customStatement('DROP TABLE IF EXISTS history');
          await customStatement('DROP TABLE IF EXISTS cached_episodes');
        }

        if (from < 13) {
          // Version 13 migration (Triggers based FTS) - skipped or overwritten by 14
        }

        if (from < 14) {
          // Re-create FTS tables with default tokenizer (simple) instead of trigram
          // and populate them manually (since we removed triggers)
          await customStatement('DROP TABLE IF EXISTS novels_search');
          await customStatement('DROP TABLE IF EXISTS episodes_search');

          await _createFtsTables();
          await _populateFtsTables();
        }
      },
    );
  }

  Future<void> _createFtsTables() async {
    // Novels FTS (default tokenizer)
    await customStatement('''
      CREATE VIRTUAL TABLE IF NOT EXISTS novels_search USING fts5(
        ncode UNINDEXED,
        title,
        writer,
        story
      );
    ''');

    // Episodes FTS (default tokenizer)
    await customStatement('''
      CREATE VIRTUAL TABLE IF NOT EXISTS episodes_search USING fts5(
        ncode UNINDEXED,
        episode_id UNINDEXED,
        subtitle,
        content
      );
    ''');

    // No triggers here anymore
  }

  Future<void> _populateFtsTables() async {
    // Populate Novels FTS
    final allNovels = await select(novels).get();
    for (final novel in allNovels) {
      await _updateNovelSearchIndex(novel);
    }

    // Populate Episodes FTS
    final allEpisodes = await select(episodeEntities).get();
    for (final episode in allEpisodes) {
      if (episode.content != null) {
        await _updateEpisodeSearchIndex(episode);
      }
    }
  }

  /// 小説の検索インデックスを更新
  Future<void> _updateNovelSearchIndex(Novel novel) async {
    final tokenizedTitle = SearchTokenizer.tokenize(novel.title ?? '');
    final tokenizedWriter = SearchTokenizer.tokenize(novel.writer ?? '');
    final tokenizedStory = SearchTokenizer.tokenize(novel.story ?? '');

    await customStatement(
      '''
      INSERT OR REPLACE INTO novels_search(rowid, ncode, title, writer, story)
      VALUES (
        (SELECT rowid FROM novels_search WHERE ncode = ?),
        ?, ?, ?, ?
      )
      ''',
      [
        novel.ncode,
        novel.ncode,
        tokenizedTitle,
        tokenizedWriter,
        tokenizedStory,
      ],
    );
  }

  /// エピソードの検索インデックスを更新
  Future<void> _updateEpisodeSearchIndex(EpisodeRow episode) async {
    if (episode.content == null) return;

    final tokenizedSubtitle = SearchTokenizer.tokenize(episode.subtitle ?? '');

    // Extract text content from JSON
    final contentList = episode.content!;
    final buffer = StringBuffer();
    for (final element in contentList) {
      if (element is PlainText) {
        buffer.write(element.text);
      } else if (element is RubyText) {
        buffer.write(element.base);
      }
    }
    final tokenizedContent = SearchTokenizer.tokenize(buffer.toString());

    await customStatement(
      '''
      INSERT OR REPLACE INTO episodes_search(rowid, ncode, episode_id, subtitle, content)
      VALUES (
        (SELECT rowid FROM episodes_search WHERE ncode = ? AND episode_id = ?),
        ?, ?, ?, ?
      )
      ''',
      [
        episode.ncode,
        episode.episodeId,
        episode.ncode,
        episode.episodeId,
        tokenizedSubtitle,
        tokenizedContent,
      ],
    );
  }

  /// 小説の検索インデックスから削除
  // ignore: unused_element
  Future<void> _deleteNovelSearchIndex(String ncode) async {
    await customStatement(
      'DELETE FROM novels_search WHERE ncode = ?',
      [ncode],
    );
  }

  /// エピソードの検索インデックスから削除
  // ignore: unused_element
  Future<void> _deleteEpisodeSearchIndex(String ncode, int episodeId) async {
    await customStatement(
      'DELETE FROM episodes_search WHERE ncode = ? AND episode_id = ?',
      [ncode, episodeId],
    );
  }

  /// 小説情報の取得
  Future<Novel?> getNovel(String ncode) {
    return (select(novels)
          ..where((t) => t.ncode.equals(ncode.toNormalizedNcode())))
        .getSingleOrNull();
  }

  /// 小説の検索
  Future<List<Novel>> searchNovels(String query) async {
    final tokenizedQuery = SearchTokenizer.tokenize(query);
    if (tokenizedQuery.isEmpty) return [];

    final results = await customSelect(
      '''
      SELECT n.* FROM novels n
      JOIN novels_search ns ON n.ncode = ns.ncode
      JOIN library_entries le ON n.ncode = le.ncode
      WHERE ns.novels_search MATCH ?
      ORDER BY ns.rank
      ''',
      variables: [Variable.withString(tokenizedQuery)],
      readsFrom: {novels, libraryEntries},
    ).get();

    return results.map((row) => novels.map(row.data)).where((novel) {
      return (novel.title?.contains(query) ?? false) ||
          (novel.writer?.contains(query) ?? false) ||
          (novel.story?.contains(query) ?? false);
    }).toList();
  }

  /// エピソードの検索
  Future<List<EpisodeSearchResult>> searchEpisodes(String query) async {
    final tokenizedQuery = SearchTokenizer.tokenize(query);
    if (tokenizedQuery.isEmpty) return [];

    final results = await customSelect(
      '''
      SELECT 
        e.ncode,
        e.episode_id,
        e.subtitle,
        e.content,
        n.title as novel_title
      FROM episodes e
      JOIN novels n ON e.ncode = n.ncode
      JOIN library_entries le ON e.ncode = le.ncode
      JOIN episodes_search es ON e.ncode = es.ncode AND e.episode_id = es.episode_id
      WHERE es.episodes_search MATCH ?
      ORDER BY es.rank
      LIMIT 100
      ''',
      variables: [Variable.withString(tokenizedQuery)],
      readsFrom: {episodeEntities, novels, libraryEntries},
    ).get();

    return results
        .where((row) {
          final subtitle = row.read<String?>('subtitle') ?? '';
          if (subtitle.contains(query)) return true;

          final contentJson = row.read<String?>('content');
          if (contentJson == null) return false;

          // Parse content to check for exact match
          try {
            final contentList = const ContentConverter().fromSql(contentJson);
            for (final element in contentList) {
              if (element is PlainText) {
                if (element.text.contains(query)) return true;
              } else if (element is RubyText) {
                if (element.base.contains(query)) return true;
              }
            }
          } on Exception catch (_) {
            // Ignore parsing errors
          }
          return false;
        })
        .map((row) {
          return EpisodeSearchResult(
            ncode: row.read<String>('ncode'),
            episodeId: row.read<int>('episode_id'),
            subtitle: row.read<String?>('subtitle') ?? '',
            novelTitle: row.read<String?>('novel_title') ?? '',
          );
        })
        .toList();
  }

  /// ライブラリに小説を追加
  Future<int> addToLibrary(String ncode) {
    final normalized = ncode.toNormalizedNcode();
    return into(libraryEntries).insert(
      LibraryEntriesCompanion(
        ncode: drift.Value(normalized),
        addedAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  /// ライブラリから小説を削除
  Future<int> removeFromLibrary(String ncode) {
    return (delete(
      libraryEntries,
    )..where((t) => t.ncode.equals(ncode.toNormalizedNcode()))).go();
  }

  /// ライブラリの小説リストを取得（追加日時の降順）
  Future<List<Novel>> getLibraryNovels() async {
    final query = select(libraryEntries).join([
      innerJoin(novels, novels.ncode.equalsExp(libraryEntries.ncode)),
    ])..orderBy([OrderingTerm.desc(libraryEntries.addedAt)]);

    final results = await query.get();
    return results.map((row) => row.readTable(novels)).toList();
  }

  /// ライブラリの小説リストを監視（JOIN）
  Stream<List<Novel>> watchLibraryNovels() {
    final query = select(libraryEntries).join([
      innerJoin(novels, novels.ncode.equalsExp(libraryEntries.ncode)),
    ])..orderBy([OrderingTerm.desc(libraryEntries.addedAt)]);

    return query.watch().map(
      (rows) => rows.map((row) => row.readTable(novels)).toList(),
    );
  }

  /// 小説がライブラリに追加されているかを確認
  Future<bool> isInLibrary(String ncode) async {
    final result =
        await (select(libraryEntries)
              ..where((t) => t.ncode.equals(ncode.toNormalizedNcode())))
            .getSingleOrNull();
    return result != null;
  }

  /// ライブラリ登録状態の監視
  Stream<bool> watchIsInLibrary(String ncode) {
    return (select(libraryEntries)
          ..where((t) => t.ncode.equals(ncode.toNormalizedNcode())))
        .watchSingleOrNull()
        .map((entry) => entry != null);
  }

  /// 小説情報の保存
  Future<int> insertNovel(NovelsCompanion novel) async {
    // FTS更新が必要かどうかを判定するために既存データを取得
    final existingNovel = await getNovel(novel.ncode.value);

    final id = await into(novels).insert(
      novel.copyWith(ncode: drift.Value(novel.ncode.value.toLowerCase())),
      mode: InsertMode.insertOrReplace,
    );

    // Update Search Index
    // タイトル、著者、あらすじが変更された場合のみインデックスを更新
    var shouldUpdateIndex = true;
    if (existingNovel != null) {
      if (existingNovel.title == novel.title.value &&
          existingNovel.writer == novel.writer.value &&
          existingNovel.story == novel.story.value) {
        shouldUpdateIndex = false;
      }
    }

    if (shouldUpdateIndex) {
      final insertedNovel = await getNovel(novel.ncode.value);
      if (insertedNovel != null) {
        await _updateNovelSearchIndex(insertedNovel);
      }
    }

    return id;
  }

  /// 履歴の追加
  Future<int> addToHistory(ReadingHistoryCompanion history) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return into(readingHistory).insert(
      history.copyWith(
        ncode: drift.Value(history.ncode.value.toLowerCase()),
        viewedAt: drift.Value(now),
        updatedAt: drift.Value(now),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// 履歴の取得（JOIN）
  Future<List<HistoryData>> getHistory() async {
    final query = select(readingHistory).join([
      innerJoin(novels, novels.ncode.equalsExp(readingHistory.ncode)),
    ])..orderBy([OrderingTerm.desc(readingHistory.viewedAt)]);

    final results = await query.get();

    return results.map((row) {
      final novel = row.readTable(novels);
      final history = row.readTable(readingHistory);

      return HistoryData(
        ncode: novel.ncode,
        title: novel.title,
        writer: novel.writer,
        lastEpisode: history.lastEpisodeId,
        viewedAt: history.viewedAt,
        updatedAt: history.updatedAt,
      );
    }).toList();
  }

  /// 履歴の監視（JOIN）
  Stream<List<HistoryData>> watchHistory() {
    final query = select(readingHistory).join([
      innerJoin(novels, novels.ncode.equalsExp(readingHistory.ncode)),
    ])..orderBy([OrderingTerm.desc(readingHistory.viewedAt)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final novel = row.readTable(novels);
        final history = row.readTable(readingHistory);
        return HistoryData(
          ncode: novel.ncode,
          title: novel.title,
          writer: novel.writer,
          lastEpisode: history.lastEpisodeId,
          viewedAt: history.viewedAt,
          updatedAt: history.updatedAt,
        );
      }).toList();
    });
  }

  /// 履歴の削除
  Future<int> deleteHistory(String ncode) {
    return (delete(
      readingHistory,
    )..where((t) => t.ncode.equals(ncode.toNormalizedNcode()))).go();
  }

  /// 履歴の全削除
  Future<int> clearHistory() {
    return delete(readingHistory).go();
  }

  /// エピソード情報（目次）の保存
  Future<void> upsertEpisodes(
    List<EpisodeEntitiesCompanion> newEpisodes,
  ) async {
    if (newEpisodes.isEmpty) return;

    // 最適化: 不要なFTS更新を避けるため、既存のサブタイトルを事前に取得する。
    // このメソッドは通常、単一の小説のエピソードリストに対して呼び出されるため、
    // 既存データを効率的に取得できる。
    final ncode = newEpisodes.first.ncode.value;
    final existingRows = await (select(
      episodeEntities,
    )..where((t) => t.ncode.equals(ncode))).get();

    final existingSubtitles = {
      for (final row in existingRows) row.episodeId: row.subtitle,
    };

    await batch((batch) {
      for (final episode in newEpisodes) {
        batch.customStatement(
          '''
          INSERT INTO episodes (ncode, episode_id, subtitle, url, published_at, revised_at)
          VALUES (?, ?, ?, ?, ?, ?)
          ON CONFLICT(ncode, episode_id) DO UPDATE SET
            subtitle = excluded.subtitle,
            url = excluded.url,
            published_at = excluded.published_at,
            revised_at = excluded.revised_at;
        ''',
          [
            episode.ncode.value,
            episode.episodeId.value,
            episode.subtitle.value,
            episode.url.value,
            episode.publishedAt.value,
            episode.revisedAt.value,
          ],
        );
      }
    });

    // サブタイトルの検索インデックスを更新
    // 既存のエピソードで、サブタイトルが実際に変更された場合のみ更新するように最適化。
    // 新規エピソードの場合、contentはnull（このメソッドはメタデータのみ更新するため）なので、
    // いずれにせよ_updateEpisodeSearchIndexはスキップされるため、DBクエリを節約できる。
    for (final episode in newEpisodes) {
      final epId = episode.episodeId.value;
      final newSubtitle = episode.subtitle.value;

      // エピソードが存在し、かつサブタイトルが変更された場合のみ更新

      if (existingSubtitles.containsKey(epId)) {
        final oldSubtitle = existingSubtitles[epId];
        if (oldSubtitle != newSubtitle) {
          final row = await getEpisodeData(
            episode.ncode.value,
            epId,
          );
          if (row != null) {
            await _updateEpisodeSearchIndex(row);
          }
        }
      }
    }
  }

  /// エピソード本文の保存
  Future<void> updateEpisodeContent(EpisodeEntitiesCompanion episode) async {
    // FTS更新が必要かどうかを判定するために既存データを取得
    final existingRow = await getEpisodeData(
      episode.ncode.value,
      episode.episodeId.value,
    );

    await customStatement(
      '''
      INSERT INTO episodes (ncode, episode_id, content, fetched_at, subtitle, url)
      VALUES (?, ?, ?, ?, ?, ?)
      ON CONFLICT(ncode, episode_id) DO UPDATE SET
        content = excluded.content,
        fetched_at = excluded.fetched_at;
    ''',
      [
        episode.ncode.value,
        episode.episodeId.value,
        const ContentConverter().toSql(episode.content.value!),
        episode.fetchedAt.value,
        episode.subtitle.value,
        episode.url.value,
      ],
    );

    // Update Search Index
    // コンテンツが変更された場合のみインデックスを更新
    var shouldUpdateIndex = true;
    if (existingRow != null &&
        existingRow.content != null &&
        episode.content.value != null) {
      // リストの内容を比較
      if (listEquals(existingRow.content, episode.content.value)) {
        shouldUpdateIndex = false;
      }
    }

    if (shouldUpdateIndex) {
      final row = await getEpisodeData(
        episode.ncode.value,
        episode.episodeId.value,
      );
      if (row != null) {
        await _updateEpisodeSearchIndex(row);
      }
    }
  }

  // ...

  /// 特定エピソードの生データ（Entity）を取得
  Future<EpisodeRow?> getEpisodeData(String ncode, int episodeId) {
    return (select(episodeEntities)..where(
          (t) =>
              t.ncode.equals(ncode.toNormalizedNcode()) &
              t.episodeId.equals(episodeId),
        ))
        .getSingleOrNull();
  }

  /// エピソード一覧を取得
  Future<List<Episode>> getEpisodes(String ncode) async {
    final rows =
        await (select(episodeEntities)
              ..where((t) => t.ncode.equals(ncode.toNormalizedNcode()))
              ..orderBy([(t) => OrderingTerm(expression: t.episodeId)]))
            .get();

    return rows
        .map(
          (row) => Episode(
            ncode: row.ncode,
            index: row.episodeId,
            subtitle: row.subtitle,
            url: row.url,
            update: row.publishedAt,
            revised: row.revisedAt,
          ),
        )
        .toList();
  }

  /// 指定範囲のエピソード一覧を取得
  Future<List<Episode>> getEpisodesRange(
    String ncode,
    int start,
    int end,
  ) async {
    final rows =
        await (select(episodeEntities)
              ..where(
                (t) =>
                    t.ncode.equals(ncode.toNormalizedNcode()) &
                    t.episodeId.isBetweenValues(start, end),
              )
              ..orderBy([(t) => OrderingTerm(expression: t.episodeId)]))
            .get();

    return rows
        .map(
          (row) => Episode(
            ncode: row.ncode,
            index: row.episodeId,
            subtitle: row.subtitle,
            url: row.url,
            update: row.publishedAt,
            revised: row.revisedAt,
          ),
        )
        .toList();
  }

  /// 特定エピソードのEntityを監視
  Stream<EpisodeRow?> watchEpisodeEntity(String ncode, int episodeId) {
    return (select(episodeEntities)..where(
          (t) =>
              t.ncode.equals(ncode.toNormalizedNcode()) &
              t.episodeId.equals(episodeId),
        ))
        .watchSingleOrNull();
  }

  /// 小説のダウンロード状態の集計情報を取得
  Future<NovelDownloadSummary?> getNovelDownloadSummary(String ncode) async {
    final normalizedNcode = ncode.toNormalizedNcode();
    final novel = await getNovel(normalizedNcode);
    if (novel?.generalAllNo == null) {
      return null;
    }
    final totalEpisodes = novel!.generalAllNo!;

    final savedEpisodes =
        await (select(episodeEntities)..where(
              (e) => e.ncode.equals(normalizedNcode) & e.content.isNotNull(),
            ))
            .get();

    final successCount = savedEpisodes.length;
    final failureCount = savedEpisodes.where((e) => e.content!.isEmpty).length;
    final realSuccessCount = successCount - failureCount;

    return NovelDownloadSummary(
      ncode: normalizedNcode,
      successCount: realSuccessCount,
      failureCount: failureCount,
      totalEpisodes: totalEpisodes,
    );
  }

  /// 小説のダウンロード状態の集計情報を監視
  Stream<NovelDownloadSummary?> watchNovelDownloadSummary(String ncode) {
    final normalizedNcode = ncode.toNormalizedNcode();

    return (select(episodeEntities)
          ..where((e) => e.ncode.equals(normalizedNcode)))
        .watch()
        .asyncMap((allEpisodes) async {
          final novel = await getNovel(normalizedNcode);
          if (novel?.generalAllNo == null) {
            return null;
          }
          final totalEpisodes = novel!.generalAllNo!;

          final savedEpisodes = allEpisodes
              .where((e) => e.content != null)
              .toList();
          final successCount = savedEpisodes.length;
          final failureCount = savedEpisodes
              .where((e) => e.content!.isEmpty)
              .length;
          final realSuccessCount = successCount - failureCount;

          return NovelDownloadSummary(
            ncode: normalizedNcode,
            successCount: realSuccessCount,
            failureCount: failureCount,
            totalEpisodes: totalEpisodes,
          );
        });
  }

  /// ダウンロード中の小説を監視
  Stream<List<NovelDownloadSummary>> watchDownloadingNovels() {
    return select(episodeEntities).watch().asyncMap((allEpisodes) async {
      final ncodeMap = <String, List<EpisodeRow>>{};
      for (final episode in allEpisodes) {
        if (episode.content != null) {
          ncodeMap.putIfAbsent(episode.ncode, () => []).add(episode);
        }
      }

      final summaries = <NovelDownloadSummary>[];
      for (final entry in ncodeMap.entries) {
        final ncode = entry.key;
        final savedEpisodes = entry.value;

        final novel = await getNovel(ncode);
        if (novel?.generalAllNo == null) continue;

        final totalEpisodes = novel!.generalAllNo!;
        final successCount = savedEpisodes.length;
        final failureCount = savedEpisodes
            .where((e) => e.content!.isEmpty)
            .length;
        final realSuccessCount = successCount - failureCount;

        final summary = NovelDownloadSummary(
          ncode: ncode,
          successCount: realSuccessCount,
          failureCount: failureCount,
          totalEpisodes: totalEpisodes,
        );

        if (summary.downloadStatus == 1) {
          summaries.add(summary);
        }
      }
      return summaries;
    });
  }

  /// 完了済みダウンロード小説を監視
  Stream<List<NovelDownloadSummary>> watchCompletedDownloads() {
    return select(episodeEntities).watch().asyncMap((allEpisodes) async {
      final ncodeMap = <String, List<EpisodeRow>>{};
      for (final episode in allEpisodes) {
        if (episode.content != null) {
          ncodeMap.putIfAbsent(episode.ncode, () => []).add(episode);
        }
      }

      final summaries = <NovelDownloadSummary>[];
      for (final entry in ncodeMap.entries) {
        final ncode = entry.key;
        final savedEpisodes = entry.value;

        final novel = await getNovel(ncode);
        if (novel?.generalAllNo == null) continue;

        final totalEpisodes = novel!.generalAllNo!;
        final successCount = savedEpisodes.length;
        final failureCount = savedEpisodes
            .where((e) => e.content!.isEmpty)
            .length;
        final realSuccessCount = successCount - failureCount;

        final summary = NovelDownloadSummary(
          ncode: ncode,
          successCount: realSuccessCount,
          failureCount: failureCount,
          totalEpisodes: totalEpisodes,
        );

        if (summary.downloadStatus == 2) {
          summaries.add(summary);
        }
      }
      return summaries;
    });
  }
}

/// エピソード検索結果のDTO
class EpisodeSearchResult {
  /// コンストラクタ
  EpisodeSearchResult({
    required this.ncode,
    required this.episodeId,
    required this.subtitle,
    required this.novelTitle,
  });

  /// 小説のNコード
  final String ncode;

  /// エピソード番号
  final int episodeId;

  /// サブタイトル
  final String subtitle;

  /// 小説のタイトル
  final String novelTitle;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'novelty.db'));
    return NativeDatabase.createInBackground(file);
  });
}

// ==================== Providers Moved to database_providers.dart ====================
