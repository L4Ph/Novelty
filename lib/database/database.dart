import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:narou_parser/narou_parser.dart';
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

// テーブル定義
/// 小説情報を格納するテーブル
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

  /// 作品に��まれる要素に「ガールズラブ」が含まれる場合は1、それ以外は0
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

/// 小説の閲覧履歴を格納するテーブル
class History extends Table {
  /// 小説のncode
  TextColumn get ncode => text()();

  /// 小説のタイトル
  TextColumn get title => text().nullable()();

  /// 小説の著者
  TextColumn get writer => text().nullable()();

  /// 最後に閲覧したエピソード
  IntColumn get lastEpisode => integer().nullable()();

  /// 閲覧日時
  IntColumn get viewedAt => integer()();

  /// 更新日時
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {ncode};
}

/// キャッシュ済みエピソードを格納するテーブル
class CachedEpisodes extends Table {
  /// 小説のncode
  TextColumn get ncode => text()();

  /// エピソード番号
  IntColumn get episode => integer()();

  /// エピソードの内容
  /// JSON形式で保存される。空配列=失敗、中身あり=成功
  TextColumn get content => text().map(const ContentConverter())();

  /// キャッシュ日時
  IntColumn get cachedAt => integer()();

  /// キャッシュ時点の改稿日時
  TextColumn get revised => text().nullable()();

  @override
  Set<Column> get primaryKey => {ncode, episode};
}


/// ライブラリに追加された小説を格納するテーブル
class LibraryNovels extends Table {
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

  /// 連載小説のエピソード数 短編は常に1
  IntColumn get generalAllNo => integer().nullable()();

  /// 作品の更新日時
  TextColumn get novelUpdatedAt => text().nullable()();

  /// ライブラリに追加された日時
  /// UNIXタイムスタンプ形式で保存される
  IntColumn get addedAt => integer()();

  @override
  Set<Column> get primaryKey => {ncode};
}

@DriftDatabase(
  tables: [
    Novels,
    History,
    CachedEpisodes,
    LibraryNovels,
  ],
)
/// アプリケーションのデータベース
/// 小説情報、閲覧履歴、エピソード、キャッシュ済みエピソードを管理
class AppDatabase extends _$AppDatabase {
  /// コンストラクタ
  /// データベースの接続を初期化
  AppDatabase() : super(_openConnection());

  /// テスト用コンストラクタ
  /// インメモリデータベースを使用
  AppDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          await customStatement(
            'ALTER TABLE novels RENAME COLUMN poin_count TO point_count;',
          );
        }
        if (from <= 2) {
          // LibraryNovelsテーブルを作成
          await m.createTable(libraryNovels);

          // 既存のfav=1の小説をLibraryNovelsテーブルに移行
          await customStatement('''
            INSERT INTO library_novels (ncode, added_at)
            SELECT ncode, cached_at
            FROM novels
            WHERE fav = 1;
          ''');
        }
        if (from <= 3) {
          // Add the new columns
          await m.addColumn(libraryNovels, libraryNovels.title);
          await m.addColumn(libraryNovels, libraryNovels.writer);
          await m.addColumn(libraryNovels, libraryNovels.story);
          await m.addColumn(libraryNovels, libraryNovels.novelType);
          await m.addColumn(libraryNovels, libraryNovels.end);
          await m.addColumn(libraryNovels, libraryNovels.generalAllNo);
          await m.addColumn(libraryNovels, libraryNovels.novelUpdatedAt);

          // データをnovelsテーブルからコピー
          await customStatement('''
            UPDATE library_novels
            SET
              title = (SELECT title FROM novels WHERE novels.ncode = library_novels.ncode),
              writer = (SELECT writer FROM novels WHERE novels.ncode = library_novels.ncode),
              story = (SELECT story FROM novels WHERE novels.ncode = library_novels.ncode),
              novel_type = (SELECT novel_type FROM novels WHERE novels.ncode = library_novels.ncode),
              end = (SELECT end FROM novels WHERE novels.ncode = library_novels.ncode),
              general_all_no = (SELECT general_all_no FROM novels WHERE novels.ncode = library_novels.ncode),
              novel_updated_at = (SELECT novel_updated_at FROM novels WHERE novels.ncode = library_novels.ncode)
            WHERE EXISTS (SELECT 1 FROM novels WHERE novels.ncode = library_novels.ncode);
          ''');
        }
        if (from <= 4) {
          await m.addColumn(history, history.updatedAt);
          await customStatement(
            'UPDATE history SET updated_at = viewed_at;',
          );
        }
        if (from <= 5) {
          // DownloadedNovelsテーブルを作成（v10で削除される）
          await customStatement('''
            CREATE TABLE IF NOT EXISTS downloaded_novels (
              ncode TEXT NOT NULL PRIMARY KEY,
              download_status INTEGER NOT NULL,
              downloaded_at INTEGER NOT NULL,
              total_episodes INTEGER NOT NULL,
              downloaded_episodes INTEGER NOT NULL
            )
          ''');

          // DownloadedEpisodesテーブルからtitleカラムを削除するためのマイグレーション
          // 1. 新しい構造で一時テーブルを作成
          await customStatement('''
            CREATE TABLE downloaded_episodes_new (
              ncode TEXT NOT NULL,
              episode INTEGER NOT NULL,
              content TEXT NOT NULL,
              downloaded_at INTEGER NOT NULL,
              PRIMARY KEY(ncode, episode)
            )
          ''');

          // 2. データを一時テーブルにコピー
          await customStatement('''
            INSERT INTO downloaded_episodes_new (ncode, episode, content, downloaded_at)
            SELECT ncode, episode, content, downloaded_at FROM downloaded_episodes
          ''');

          // 3. 古いテーブルを削除
          await customStatement('DROP TABLE downloaded_episodes');

          // 4. 一時テーブルをリネーム
          await customStatement(
            'ALTER TABLE downloaded_episodes_new RENAME TO downloaded_episodes',
          );
        }
        if (from <= 6) {
          // novelsテーブルにgenreカラムを追加
          await m.addColumn(novels, novels.genre);
        }
        if (from <= 7) {
          // downloadedEpisodesテーブルにstatus, errorMessage, lastAttemptAtカラムを追加
          try {
             await customStatement('ALTER TABLE downloaded_episodes ADD COLUMN status INTEGER DEFAULT 2');
             await customStatement('ALTER TABLE downloaded_episodes ADD COLUMN error_message TEXT');
             await customStatement('ALTER TABLE downloaded_episodes ADD COLUMN last_attempt_at INTEGER');
          } catch (e) {
            // カラムが既に存在する場合などでエラーになる可能性があるが無視
            print('Migration error (from <= 7): $e');
          }
        }
        if (from <= 8) {
          // bookmarksテーブルを削除（使用されていないため）
          await customStatement('DROP TABLE IF EXISTS bookmarks');
        }
        if (from <= 9) {
          // downloaded_novelsテーブルを削除
          // ダウンロード状態はdownloaded_episodesから動的に計算するように変更
          await customStatement('DROP TABLE IF EXISTS downloaded_novels');
        }
        if (from <= 10) {
          // DownloadedEpisodes → CachedEpisodes にリネーム & スキーマ変更
          // 不要なカラムを削除し、revisedカラムを追加
          await customStatement('''
            CREATE TABLE cached_episodes (
              ncode TEXT NOT NULL,
              episode INTEGER NOT NULL,
              content TEXT NOT NULL,
              cached_at INTEGER NOT NULL,
              revised TEXT,
              PRIMARY KEY(ncode, episode)
            )
          ''');

          // データを移行 (status, errorMessage, lastAttemptAt は捨てる)
          // downloaded_at -> cached_at
          await customStatement('''
            INSERT INTO cached_episodes (ncode, episode, content, cached_at, revised)
            SELECT ncode, episode, content, downloaded_at, NULL FROM downloaded_episodes
          ''');

          await customStatement('DROP TABLE downloaded_episodes');

          // 未使用のEpisodesテーブルを削除
          await customStatement('DROP TABLE IF EXISTS episodes');
        }
      },
    );
  }

  /// 小説情報の取得
  Future<Novel?> getNovel(String ncode) {
    return (select(
          novels,
        )..where((t) => t.ncode.equals(ncode.toNormalizedNcode())))
        .getSingleOrNull();
  }

  /// ライブラリに小説を追加
  Future<int> addToLibrary(LibraryNovelsCompanion novel) {
    return into(libraryNovels).insert(
      novel.copyWith(ncode: drift.Value(novel.ncode.value.toLowerCase())),
      mode: InsertMode.insertOrIgnore,
    );
  }

  /// ライブラリから小説を削除
  Future<int> removeFromLibrary(String ncode) {
    return (delete(
      libraryNovels,
    )..where((t) => t.ncode.equals(ncode.toNormalizedNcode()))).go();
  }

  /// ライブラリの小説リストを取得（追加日時の降順）
  Future<List<LibraryNovel>> getLibraryNovels() {
    return (select(
      libraryNovels,
    )..orderBy([(t) => OrderingTerm.desc(t.addedAt)])).get();
  }

  /// ライブラリに登録された小説の詳細情報を取得(JOINクエリで最適化)
  Future<List<Novel>> getLibraryNovelsWithDetails() async {
    final query = select(libraryNovels).join([
      innerJoin(novels, novels.ncode.equalsExp(libraryNovels.ncode)),
    ])..orderBy([OrderingTerm.desc(libraryNovels.addedAt)]);

    final results = await query.get();
    return results.map((row) => row.readTable(novels)).toList();
  }

  /// ライブラリに登録された小説の詳細情報を監視(JOINクエリで最適化)
  Stream<List<Novel>> watchLibraryNovelsWithDetails() {
    final query = select(libraryNovels).join([
      innerJoin(novels, novels.ncode.equalsExp(libraryNovels.ncode)),
    ])..orderBy([OrderingTerm.desc(libraryNovels.addedAt)]);

    return query.watch().map(
      (rows) => rows.map((row) => row.readTable(novels)).toList(),
    );
  }

  /// 小説がライブラリに追加されているかを確認
  Future<bool> isInLibrary(String ncode) async {
    final result =
        await (select(
              libraryNovels,
            )..where((t) => t.ncode.equals(ncode.toNormalizedNcode())))
            .getSingleOrNull();
    return result != null;
  }

  /// ライブラリ登録状態の監視（新しいメソッド）
  Stream<bool> watchIsInLibrary(String ncode) {
    return (select(libraryNovels)
          ..where((t) => t.ncode.equals(ncode.toNormalizedNcode())))
        .watchSingleOrNull()
        .map((novel) => novel != null);
  }

  /// ライブラリ登録状態の監視（既存メソッドは残す - 削除予定）
  Stream<bool> watchIsFavorite(String ncode) {
    return (select(novels)
          ..where((t) => t.ncode.equals(ncode.toNormalizedNcode())))
        .watchSingleOrNull()
        .map((novel) => novel != null && novel.fav == 1);
  }

  /// 小説情報の保存
  Future<int> insertNovel(NovelsCompanion novel) {
    return into(novels).insert(
      novel.copyWith(ncode: drift.Value(novel.ncode.value.toLowerCase())),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// 小説情報の削除
  Future<int> deleteNovel(String ncode) {
    return (delete(
      novels,
    )..where((t) => t.ncode.equals(ncode.toNormalizedNcode()))).go();
  }

  /// 履歴の追加
  Future<int> addToHistory(HistoryCompanion history) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return into(this.history).insert(
      history.copyWith(
        ncode: drift.Value(history.ncode.value.toLowerCase()),
        viewedAt: drift.Value(now),
        updatedAt: drift.Value(now),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// 履歴の取得
  Future<List<HistoryData>> getHistory() {
    return (select(
      history,
    )..orderBy([(t) => OrderingTerm.desc(t.viewedAt)])).get();
  }

  /// 履歴の監視（リアルタイム更新）
  Stream<List<HistoryData>> watchHistory() {
    return (select(
      history,
    )..orderBy([(t) => OrderingTerm.desc(t.viewedAt)])).watch();
  }

  /// 履歴の削除
  Future<int> deleteHistory(String ncode) {
    return (delete(
      history,
    )..where((t) => t.ncode.equals(ncode.toNormalizedNcode()))).go();
  }

  /// 履歴の全削除
  Future<int> clearHistory() {
    return delete(history).go();
  }

  /// キャッシュ済みエピソードの保存
  Future<int> insertCachedEpisode(CachedEpisodesCompanion episode) {
    return into(cachedEpisodes).insert(
      episode.copyWith(ncode: drift.Value(episode.ncode.value.toLowerCase())),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// キャッシュ済みエピソードの取得
  Future<CachedEpisode?> getCachedEpisode(String ncode, int episode) {
    return (select(cachedEpisodes)..where(
          (t) =>
              t.ncode.equals(ncode.toNormalizedNcode()) &
              t.episode.equals(episode),
        ))
        .getSingleOrNull();
  }

  /// キャッシュ済みエピソードの監視
  Stream<CachedEpisode?> watchCachedEpisode(String ncode, int episode) {
    return (select(cachedEpisodes)..where(
          (t) =>
              t.ncode.equals(ncode.toNormalizedNcode()) &
              t.episode.equals(episode),
        ))
        .watchSingleOrNull();
  }

  /// キャッシュ済みエピソードの削除
  Future<int> deleteCachedEpisode(String ncode, int episode) {
    return (delete(
          cachedEpisodes,
        )..where(
          (t) =>
              t.ncode.equals(ncode.toNormalizedNcode()) &
              t.episode.equals(episode),
        ))
        .go();
  }

  /// 小説のダウンロード状態の集計情報を取得
  Future<NovelDownloadSummary?> getNovelDownloadSummary(String ncode) async {
    final normalizedNcode = ncode.toNormalizedNcode();

    // 小説情報からtotalEpisodesを取得
    final novel = await getNovel(normalizedNcode);
    if (novel?.generalAllNo == null) {
      return null;
    }
    final totalEpisodes = novel!.generalAllNo!;

    // キャッシュ済みエピソードを取得
    final episodes = await (select(cachedEpisodes)
          ..where((e) => e.ncode.equals(normalizedNcode)))
        .get();

    // contentの中身で成功/失敗を判定
    final successCount = episodes.where((e) => e.content.isNotEmpty).length;
    final failureCount = episodes.where((e) => e.content.isEmpty).length;

    return NovelDownloadSummary(
      ncode: normalizedNcode,
      successCount: successCount,
      failureCount: failureCount,
      totalEpisodes: totalEpisodes,
    );
  }

  /// 小説のダウンロード状態の集計情報を監視
  Stream<NovelDownloadSummary?> watchNovelDownloadSummary(String ncode) {
    final normalizedNcode = ncode.toNormalizedNcode();

    // CachedEpisodesの変更を監視
    return (select(cachedEpisodes)
          ..where((e) => e.ncode.equals(normalizedNcode)))
        .watch()
        .asyncMap((episodes) async {
      // 小説情報からtotalEpisodesを取得
      final novel = await getNovel(normalizedNcode);
      if (novel?.generalAllNo == null) {
        return null;
      }
      final totalEpisodes = novel!.generalAllNo!;

      // contentの中身で成功/失敗を判定
      final successCount = episodes.where((e) => e.content.isNotEmpty).length;
      final failureCount = episodes.where((e) => e.content.isEmpty).length;

      return NovelDownloadSummary(
        ncode: normalizedNcode,
        successCount: successCount,
        failureCount: failureCount,
        totalEpisodes: totalEpisodes,
      );
    });
  }


  /// ダウンロード中の小説を監視
  ///
  /// CachedEpisodesから集計し、ダウンロード中（status=1）の小説を取得。
  /// NovelsテーブルとLEFT JOINして小説情報も含める。
  Stream<List<NovelDownloadSummary>> watchDownloadingNovels() {
    // CachedEpisodesから異なるncodeのリストを取得
    return select(cachedEpisodes)
        .watch()
        .asyncMap((allEpisodes) async {
      // ncodeでグループ化
      final ncodeMap = <String, List<CachedEpisode>>{};
      for (final episode in allEpisodes) {
        ncodeMap.putIfAbsent(episode.ncode, () => []).add(episode);
      }

      // 各小説の集計情報を作成
      final summaries = <NovelDownloadSummary>[];
      for (final entry in ncodeMap.entries) {
        final ncode = entry.key;
        final episodes = entry.value;

        // 小説情報からtotalEpisodesを取得
        final novel = await getNovel(ncode);
        if (novel?.generalAllNo == null) continue;

        final totalEpisodes = novel!.generalAllNo!;
        final successCount = episodes.where((e) => e.content.isNotEmpty).length;
        final failureCount = episodes.where((e) => e.content.isEmpty).length;

        final summary = NovelDownloadSummary(
          ncode: ncode,
          successCount: successCount,
          failureCount: failureCount,
          totalEpisodes: totalEpisodes,
        );

        // ダウンロード中（status=1）のみ追加
        if (summary.downloadStatus == 1) {
          summaries.add(summary);
        }
      }

      return summaries;
    });
  }

  /// 完了済みダウンロード小説を監視
  ///
  /// CachedEpisodesから集計し、完了済み（status=2）の小説を取得。
  Stream<List<NovelDownloadSummary>> watchCompletedDownloads() {
    // CachedEpisodesから異なるncodeのリストを取得
    return select(cachedEpisodes)
        .watch()
        .asyncMap((allEpisodes) async {
      // ncodeでグループ化
      final ncodeMap = <String, List<CachedEpisode>>{};
      for (final episode in allEpisodes) {
        ncodeMap.putIfAbsent(episode.ncode, () => []).add(episode);
      }

      // 各小説の集計情報を作成
      final summaries = <NovelDownloadSummary>[];
      for (final entry in ncodeMap.entries) {
        final ncode = entry.key;
        final episodes = entry.value;

        // 小説情報からtotalEpisodesを取得
        final novel = await getNovel(ncode);
        if (novel?.generalAllNo == null) continue;

        final totalEpisodes = novel!.generalAllNo!;
        final successCount = episodes.where((e) => e.content.isNotEmpty).length;
        final failureCount = episodes.where((e) => e.content.isEmpty).length;

        final summary = NovelDownloadSummary(
          ncode: ncode,
          successCount: successCount,
          failureCount: failureCount,
          totalEpisodes: totalEpisodes,
        );

        // 完了済み（status=2）のみ追加
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

/// アプリケーションのデータベースプロバイダー
final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

/// 小説のライブラリを表示するためのプロバイダー。
///
/// JOINクエリを使用してN+1クエリ問題を回避している。
/// keepAlive: アプリ起動中ずっとStreamを保持し、画面遷移時の再ロードを防ぐ
final libraryNovelsProvider = StreamProvider<List<Novel>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  ref.keepAlive();
  return db.watchLibraryNovelsWithDetails();
});

/// 履歴データをリアルタイムで提供するプロバイダー
///
/// keepAlive: アプリ起動中ずっとStreamを保持し、画面遷移時の再ロードを防ぐ
final historyProvider = StreamProvider<List<HistoryData>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  ref.keepAlive();
  return db.watchHistory();
});

/// 現在時刻を提供するプロバイダー（テスト時にオーバーライド可能）
final currentTimeProvider = Provider<DateTime>((ref) => DateTime.now());

/// 日付でグルーピングされた履歴データをリアルタイムで提供するプロバイダー
///
/// keepAlive: アプリ起動中ずっとStreamを保持し、画面遷移時の再ロードを防ぐ
final groupedHistoryProvider = StreamProvider<List<HistoryGroup>>((ref) {
  // 現在の日時を取得
  final now = ref.watch(currentTimeProvider);

  // データベースのwatchHistory()を直接使用し、グルーピング処理を適用
  final db = ref.watch(appDatabaseProvider);
  ref.keepAlive();
  return db.watchHistory().map((historyItems) {
    return HistoryGrouping.groupByDate(historyItems, now);
  });
});
