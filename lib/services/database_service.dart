import 'package:novelty/database/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_service.g.dart';

@riverpod
DatabaseService databaseService(Ref ref) {
  return DatabaseService(ref.watch(appDatabaseProvider));
}

class DatabaseService {
  DatabaseService(AppDatabase db);
}
