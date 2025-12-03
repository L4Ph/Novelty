import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_download_summary.dart';
import 'package:novelty/utils/history_grouping.dart';
import 'package:novelty/utils/ncode_utils.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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
    return json.encode(value.map((e) => e.toJson()).toList());
  }
}

/// 履歴データのDTOクラス
/// 旧Historyテーブルのデータクラスと互換性を持たせるために定義
class HistoryData {
  HistoryData({
    required this.ncode,
    required this.viewedAt,
    required this.updatedAt,
    this.title,
    this.writer,
    this.lastEpisode,
  });
  final String ncode;
  final String? title;
  final String? writer;
  final int? lastEpisode;
  final int viewedAt;
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
  int get schemaVersion => 12;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 12) {
          try {
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
          } catch (e, st) {
            // ignore: avoid_print
            print('Migration Error: $e');
            // ignore: avoid_print
            print('Migration StackTrace: $st');
            rethrow;
          }
        }
      },
    );
  }

  /// 小説情報の取得
  Future<Novel?> getNovel(String ncode) {
    return (select(novels)
          ..where((t) => t.ncode.equals(ncode.toNormalizedNcode())))
        .getSingleOrNull();
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
  Future<int> insertNovel(NovelsCompanion novel) {
    return into(novels).insert(
      novel.copyWith(ncode: drift.Value(novel.ncode.value.toLowerCase())),
      mode: InsertMode.insertOrReplace,
    );
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
  }

  /// エピソード本文の保存
  Future<void> updateEpisodeContent(EpisodeEntitiesCompanion episode) {
    return customStatement(
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

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'novelty.db'));
    return NativeDatabase.createInBackground(file);
  });
}

// ==================== Providers ====================

final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final libraryNovelsProvider = StreamProvider<List<Novel>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  ref.keepAlive();
  return db.watchLibraryNovels();
});

final historyProvider = StreamProvider<List<HistoryData>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  ref.keepAlive();
  return db.watchHistory();
});

final currentTimeProvider = Provider<DateTime>((ref) => DateTime.now());

final groupedHistoryProvider = StreamProvider<List<HistoryGroup>>((ref) {
  final now = ref.watch(currentTimeProvider);
  final db = ref.watch(appDatabaseProvider);
  ref.keepAlive();
  return db.watchHistory().map((historyItems) {
    return HistoryGrouping.groupByDate(historyItems, now);
  });
});
