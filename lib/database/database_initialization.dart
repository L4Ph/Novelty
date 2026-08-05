import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:riverpod/legacy.dart' show StateProvider;

/// マイグレーションリトライ回数を管理するプロバイダー。
final StateProvider<int> migrationRetryCounterProvider = StateProvider<int>(
  (ref) => 0,
);

/// データベースの初期化（マイグレーション含む）を管理する FutureProvider。
final FutureProvider<AppDatabase> databaseInitializationProvider =
    FutureProvider<AppDatabase>((ref) async {
      ref.watch(migrationRetryCounterProvider);
      final db = ref.watch(appDatabaseProvider);
      await db.doWhenOpened((_) async {});
      return db;
    });
