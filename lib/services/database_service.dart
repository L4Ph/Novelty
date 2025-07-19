import 'package:novelty/database/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_service.g.dart';

@riverpod
/// データベースサービスのプロバイダー。
DatabaseService databaseService(Ref ref) {
  return DatabaseService(ref.watch(appDatabaseProvider));
}

/// データベースサービスクラス。
/// データベースへのアクセスを提供
class DatabaseService {
  /// コンストラクタ。
  DatabaseService(this.db);

  /// データベースのインスタンス。
  final AppDatabase db;

  /// 履歴を削除する。
  Future<int> deleteHistory(String ncode) {
    return db.deleteHistory(ncode);
  }
}
