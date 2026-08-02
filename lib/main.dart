import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/router/router.dart';
import 'package:novelty/screens/migration_progress_splash.dart';
import 'package:novelty/screens/migration_recovery_screen.dart';
import 'package:novelty/services/backup_service.dart';
import 'package:novelty/utils/font_family.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/widgets/offline_mode_banner.dart';
import 'package:riverpod/legacy.dart' show StateProvider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// アプリ全体で固定するロケール。
/// 日本語(日本)に固定し、OSのロケールに関わらず
/// 日本語環境として動作させる。
const appLocale = Locale('ja', 'JP');

/// アプリ全体でサポートするロケール。
/// 日本語(日本)のみをサポートし、OSのロケールに関わらず
/// 日本語環境として動作させることで、CJKフォントの
/// 中国語グリフへのフォールバックを防ぐ。
const appSupportedLocales = <Locale>[appLocale];

/// アプリ全体で使用するローカライゼーションデリゲート。
const appLocalizationsDelegates = <LocalizationsDelegate<dynamic>>[
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

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
      loading: () => MaterialApp(
        locale: appLocale,
        supportedLocales: appSupportedLocales,
        localizationsDelegates: appLocalizationsDelegates,
        theme: ThemeData(fontFamily: appUiFontFamily),
        home: const MigrationProgressSplash(),
      ),
      error: (err, stack) {
        final db = ref.read(appDatabaseProvider);
        return MaterialApp(
          locale: appLocale,
          supportedLocales: appSupportedLocales,
          localizationsDelegates: appLocalizationsDelegates,
          theme: ThemeData(fontFamily: appUiFontFamily),
          home: MigrationRecoveryScreen(
            error: err,
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
            locale: appLocale,
            supportedLocales: appSupportedLocales,
            localizationsDelegates: appLocalizationsDelegates,
            themeMode: settings.themeMode,
            theme: ThemeData(
              colorScheme: colorScheme,
              fontFamily: appUiFontFamily,
            ),
            darkTheme: ThemeData(
              colorScheme: darkColorSchema,
              fontFamily: appUiFontFamily,
            ),
            routerConfig: router,
            builder: (context, child) => OfflineModeBanner(child: child!),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
