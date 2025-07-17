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
  // ignore: avoid_unused_constructor_parameters
  DatabaseService(AppDatabase db);
}
