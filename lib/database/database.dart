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
/// アプリケーションのデータベース
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}

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

  @override
  Set<Column> get primaryKey => {ncode};
}

/// 小説のエピソードを格納するテーブル
class Episodes extends Table {
  /// 小説のncode
  TextColumn get ncode => text()();

  /// エピソード番号
  IntColumn get episode => integer()();

  /// エピソードのタイトル
  TextColumn get title => text().nullable()();

  /// エピソードの内容
  TextColumn get content => text().nullable()();

  /// キャッシュした日時
  IntColumn get cachedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {ncode, episode};
}

/// ダウンロード済みエピソードを格納するテーブル
class DownloadedEpisodes extends Table {
  /// 小説のncode
  TextColumn get ncode => text()();

  /// エピソード番号
  IntColumn get episode => integer()();

  /// エピソードのタイトル
  TextColumn get title => text().nullable()();

  /// エピソードの内容
  /// JSON形式で保存される
  TextColumn get content => text().map(const ContentConverter())();

  /// ダウンロード日時
  IntColumn get downloadedAt => integer()();

  @override
  Set<Column> get primaryKey => {ncode, episode};
}

/// ブックマークを格納するテーブル(使用されていない?)
class Bookmarks extends Table {
  /// 小説のncode
  TextColumn get ncode => text()();

  /// エピソード番号
  IntColumn get episode => integer()();

  /// ブックマークの位置
  IntColumn get position => integer()();

  /// ブックマークの内容
  TextColumn get content => text().nullable()();

  /// ブックマークの作成日時
  /// UNIXタイムスタンプ形式で保存される
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {ncode, episode, position};
}

@DriftDatabase(
  tables: [Novels, History, Episodes, DownloadedEpisodes, Bookmarks],
)
/// アプリケーションのデータベース
/// 小説情報、閲覧履歴、エピソード、ダウンロード済みエピソード、ブックマークを管理
class AppDatabase extends _$AppDatabase {
  /// コンストラクタ
  /// データベースの接続を初期化
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

  /// 小説情報の取得
  Future<Novel?> getNovel(String ncode) {
    return (select(
      novels,
    )..where((t) => t.ncode.equals(ncode))).getSingleOrNull();
  }

  /// ライブラリ登録状態の監視
  Stream<bool> watchIsFavorite(String ncode) {
    return (select(novels)..where((t) => t.ncode.equals(ncode)))
        .watchSingleOrNull()
        .map((novel) => novel != null && novel.fav == 1);
  }

  /// 小説情報の保存
  Future<int> insertNovel(NovelsCompanion novel) {
    return into(novels).insert(
      novel,
      mode: InsertMode.insertOrReplace,
    );
  }

  /// 小説情報の削除
  Future<int> deleteNovel(String ncode) {
    return (delete(novels)..where((t) => t.ncode.equals(ncode))).go();
  }

  /// 履歴の追加
  Future<int> addToHistory(HistoryCompanion history) {
    return into(this.history).insert(
      history,
      mode: InsertMode.insertOrReplace,
    );
  }

  /// 履歴の取得
  Future<List<HistoryData>> getHistory() {
    return (select(
      history,
    )..orderBy([(t) => OrderingTerm.desc(t.viewedAt)])).get();
  }

  /// 履歴の削除
  Future<int> deleteHistory(String ncode) {
    return (delete(history)..where((t) => t.ncode.equals(ncode))).go();
  }

  /// 履歴の全削除
  Future<int> clearHistory() {
    return delete(history).go();
  }

  /// エピソードの保存
  Future<int> insertEpisode(EpisodesCompanion episode) {
    return into(episodes).insert(
      episode,
      mode: InsertMode.insertOrReplace,
    );
  }

  /// エピソードの取得
  Future<Episode?> getEpisode(String ncode, int episode) {
    return (select(episodes)
          ..where((t) => t.ncode.equals(ncode) & t.episode.equals(episode)))
        .getSingleOrNull();
  }

  /// ダウンロード済みエピソードの保存
  Future<int> insertDownloadedEpisode(DownloadedEpisodesCompanion episode) {
    return into(downloadedEpisodes).insert(
      episode,
      mode: InsertMode.insertOrReplace,
    );
  }

  /// ダウンロード済みエピソードの取得
  Future<DownloadedEpisode?> getDownloadedEpisode(String ncode, int episode) {
    return (select(downloadedEpisodes)
          ..where((t) => t.ncode.equals(ncode) & t.episode.equals(episode)))
        .getSingleOrNull();
  }

  /// ダウンロード済みエピソードの削除
  Future<int> deleteDownloadedEpisode(String ncode, int episode) {
    return (delete(
      downloadedEpisodes,
    )..where((t) => t.ncode.equals(ncode) & t.episode.equals(episode))).go();
  }

  /// ブックマークの追加
  Future<int> addBookmark(BookmarksCompanion bookmark) {
    return into(bookmarks).insert(
      bookmark,
      mode: InsertMode.insertOrReplace,
    );
  }

  /// ブックマークの取得
  Future<List<Bookmark>> getBookmarks(String ncode) {
    return (select(bookmarks)
          ..where((t) => t.ncode.equals(ncode))
          ..orderBy([(t) => OrderingTerm.asc(t.episode)]))
        .get();
  }

  /// ブックマークの削除
  Future<int> deleteBookmark(String ncode, int episode, int position) {
    return (delete(bookmarks)..where(
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
