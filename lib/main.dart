import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/router/router.dart';
import 'package:novelty/screens/migration_progress_splash.dart';
import 'package:novelty/screens/migration_recovery_screen.dart';
import 'package:novelty/services/backup_service.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:riverpod/legacy.dart' show StateProvider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

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

/// アプリケーションのエントリーポイント。
/// データベースの初期化状態に応じて、進捗スプラッシュ、リカバリー画面、
/// または通常のメイン画面を表示する。
class MyApp extends ConsumerWidget {
  /// コンストラクタ。
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbInit = ref.watch(databaseInitializationProvider);

    return dbInit.when(
      data: (_) => const _AppWithSettings(),
      loading: () => const MaterialApp(
        home: MigrationProgressSplash(),
      ),
      error: (err, stack) {
        final db = ref.read(appDatabaseProvider);
        return MaterialApp(
          home: MigrationRecoveryScreen(
            error: err,
            stackTrace: stack,
            onRetry: () {
              ref.invalidate(appDatabaseProvider);
              ref.read(migrationRetryCounterProvider.notifier).state++;
            },
            onExportDatabase: () async {
              await BackupService(db).exportDatabaseToFile();
            },
          ),
        );
      },
    );
  }
}

/// 設定を読み込み、テーマとルーターを適用したメインアプリ。
class _AppWithSettings extends ConsumerWidget {
  const _AppWithSettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return settings.when(
      data: (settings) => DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          final colorScheme =
              lightDynamic ??
              ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 179, 220, 226),
              );
          final darkColorSchema =
              darkDynamic ??
              ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 179, 220, 226),
              );

          return MaterialApp.router(
            title: 'Novelty',
            themeMode: settings.themeMode,
            theme: ThemeData(
              colorScheme: colorScheme,
              fontFamily: settings.fontFamily,
            ),
            darkTheme: ThemeData(
              colorScheme: darkColorSchema,
              fontFamily: settings.fontFamily,
            ),
            routerConfig: router,
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
