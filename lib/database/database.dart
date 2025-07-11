import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:novelty/models/novel_content_element.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

@riverpod
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}

class ContentConverter extends TypeConverter<List<NovelContentElement>, String> {
  const ContentConverter();

  @override
  List<NovelContentElement> fromSql(String fromDb) {
    if (fromDb.isEmpty) {
      return [];
    }
    final List<dynamic> decoded = json.decode(fromDb) as List;
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
class Novels extends Table {
  TextColumn get ncode => text()();
  TextColumn get title => text().nullable()();
  TextColumn get writer => text().nullable()();
  TextColumn get story => text().nullable()();
  IntColumn get novelType => integer().nullable()();
  IntColumn get end => integer().nullable()();
  IntColumn get isr15 => integer().nullable()();
  IntColumn get isbl => integer().nullable()();
  IntColumn get isgl => integer().nullable()();
  IntColumn get iszankoku => integer().nullable()();
  IntColumn get istensei => integer().nullable()();
  IntColumn get istenni => integer().nullable()();
  TextColumn get keyword => text().nullable()();
  IntColumn get generalFirstup => integer().nullable()();
  IntColumn get generalLastup => integer().nullable()();
  IntColumn get globalPoint => integer().nullable()();
  IntColumn get fav => integer().nullable()();
  IntColumn get reviewCount => integer().nullable()();
  IntColumn get rateCount => integer().nullable()();
  IntColumn get allPoint => integer().nullable()();
  IntColumn get poinCount => integer().nullable()();
  IntColumn get weeklyPoint => integer().nullable()();
  IntColumn get monthlyPoint => integer().nullable()();
  IntColumn get quarterPoint => integer().nullable()();
  IntColumn get yearlyPoint => integer().nullable()();
  IntColumn get generalAllNo => integer().nullable()();
  TextColumn get novelUpdatedAt => text().nullable()();
  IntColumn get cachedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {ncode};
}

class History extends Table {
  TextColumn get ncode => text()();
  TextColumn get title => text().nullable()();
  TextColumn get writer => text().nullable()();
  IntColumn get lastEpisode => integer().nullable()();
  IntColumn get viewedAt => integer()();

  @override
  Set<Column> get primaryKey => {ncode};
}

class Episodes extends Table {
  TextColumn get ncode => text()();
  IntColumn get episode => integer()();
  TextColumn get title => text().nullable()();
  TextColumn get content => text().nullable()();
  IntColumn get cachedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {ncode, episode};
}

class DownloadedEpisodes extends Table {
  TextColumn get ncode => text()();
  IntColumn get episode => integer()();
  TextColumn get title => text().nullable()();
  TextColumn get content => text().map(const ContentConverter())();
  IntColumn get downloadedAt => integer()();

  @override
  Set<Column> get primaryKey => {ncode, episode};
}

class Bookmarks extends Table {
  TextColumn get ncode => text()();
  IntColumn get episode => integer()();
  IntColumn get position => integer()();
  TextColumn get content => text().nullable()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {ncode, episode, position};
}

@DriftDatabase(
  tables: [Novels, History, Episodes, DownloadedEpisodes, Bookmarks],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // マイグレーション処理
      },
    );
  }

  // 小説情報の取得
  Future<Novel?> getNovel(String ncode) {
    return (select(
      novels,
    )..where((t) => t.ncode.equals(ncode)))
        .getSingleOrNull();
  }

  // ライブラリ登録状態の監視
  Stream<bool> watchIsFavorite(String ncode) {
    return (select(novels)..where((t) => t.ncode.equals(ncode)))
        .watchSingleOrNull()
        .map((novel) => novel != null && novel.fav == 1);
  }

  // 小説情報の保存
  Future<int> insertNovel(NovelsCompanion novel) {
    return into(novels).insert(
      novel,
      mode: InsertMode.insertOrReplace,
    );
  }

  // 小説情報の削除
  Future<int> deleteNovel(String ncode) {
    return (delete(novels)..where((t) => t.ncode.equals(ncode))).go();
  }

  // 履歴の追加
  Future<int> addToHistory(HistoryCompanion history) {
    return into(this.history).insert(
      history,
      mode: InsertMode.insertOrReplace,
    );
  }

  // 履歴の取得
  Future<List<HistoryData>> getHistory() {
    return (select(
      history,
    )..orderBy([(t) => OrderingTerm.desc(t.viewedAt)])).get();
  }

  // 履歴の削除
  Future<int> deleteHistory(String ncode) {
    return (delete(history)..where((t) => t.ncode.equals(ncode))).go();
  }

  // 履���の全削除
  Future<int> clearHistory() {
    return delete(history).go();
  }

  // エピソードの保存
  Future<int> insertEpisode(EpisodesCompanion episode) {
    return into(episodes).insert(
      episode,
      mode: InsertMode.insertOrReplace,
    );
  }

  // エピソードの取得
  Future<Episode?> getEpisode(String ncode, int episode) {
    return (select(episodes)
          ..where((t) => t.ncode.equals(ncode) & t.episode.equals(episode)))
        .getSingleOrNull();
  }

  // ダウンロード済みエピソードの保存
  Future<int> insertDownloadedEpisode(DownloadedEpisodesCompanion episode) {
    return into(downloadedEpisodes).insert(
      episode,
      mode: InsertMode.insertOrReplace,
    );
  }

  // ダウンロード済みエピソードの取得
  Future<DownloadedEpisode?> getDownloadedEpisode(String ncode, int episode) {
    return (select(downloadedEpisodes)
          ..where((t) => t.ncode.equals(ncode) & t.episode.equals(episode)))
        .getSingleOrNull();
  }

  // ダウンロード済みエピソードの削除
  Future<int> deleteDownloadedEpisode(String ncode, int episode) {
    return (delete(downloadedEpisodes)
          ..where((t) => t.ncode.equals(ncode) & t.episode.equals(episode)))
        .go();
  }

  // ブックマークの追加
  Future<int> addBookmark(BookmarksCompanion bookmark) {
    return into(bookmarks).insert(
      bookmark,
      mode: InsertMode.insertOrReplace,
    );
  }

  // ブックマークの取得
  Future<List<Bookmark>> getBookmarks(String ncode) {
    return (select(bookmarks)
          ..where((t) => t.ncode.equals(ncode))
          ..orderBy([(t) => OrderingTerm.asc(t.episode)]))
        .get();
  }

  // ブックマークの削除
  Future<int> deleteBookmark(String ncode, int episode, int position) {
    return (delete(bookmarks)
          ..where(
            (t) =>
                t.ncode.equals(ncode) &
                t.episode.equals(episode) &
                t.position.equals(position),
          ))
        .go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'novelty.db'));
    return NativeDatabase.createInBackground(file);
  });
}
