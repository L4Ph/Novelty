import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/database/database_initialization.dart';
import 'package:novelty/database/database_maintenance.dart';
import 'package:novelty/router/router.dart';
import 'package:novelty/screens/database_maintenance_screen.dart';
import 'package:novelty/screens/migration_progress_splash.dart';
import 'package:novelty/screens/migration_recovery_screen.dart';
import 'package:novelty/services/backup_service.dart';
import 'package:novelty/utils/font_family.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/widgets/offline_mode_banner.dart';

export 'package:novelty/database/database_initialization.dart';

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
        home: const DatabaseMaintenanceOverlay(
          child: MigrationProgressSplash(),
        ),
      ),
      error: (err, stack) {
        final db = ref.read(appDatabaseProvider);
        return MaterialApp(
          locale: appLocale,
          supportedLocales: appSupportedLocales,
          localizationsDelegates: appLocalizationsDelegates,
          theme: ThemeData(fontFamily: appUiFontFamily),
          home: DatabaseMaintenanceOverlay(
            child: MigrationRecoveryScreen(
              error: err,
              onRetry: () {
                ref.invalidate(appDatabaseProvider);
                ref.read(migrationRetryCounterProvider.notifier).state++;
              },
              onExportDatabase: () {
                return runWithDatabaseMaintenance(
                  ref,
                  label: 'データベースをエクスポートしています…',
                  task: () => BackupService(db).exportDatabaseToFile(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// DBを停止して行う保守操作の実行中に、
/// 配下の画面全体をブロッキング画面で覆うオーバーレイ。
///
/// [DatabaseMaintenanceBusy] の間は不透明なブロッキング画面を最前面に重ね、
/// 配下のUIへのタッチを物理的に遮断する。
/// 配下の画面は破棄されずに保持されるため、操作完了後の
/// フィードバック(ダイアログ等)をそのまま表示できる。
class DatabaseMaintenanceOverlay extends ConsumerWidget {
  /// コンストラクタ。
  const DatabaseMaintenanceOverlay({required this.child, super.key});

  /// 配下に表示する画面。
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maintenance = ref.watch(databaseMaintenanceProvider);
    if (maintenance is! DatabaseMaintenanceBusy) {
      return child;
    }
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: DatabaseMaintenanceScreen(
            operationLabel: maintenance.operationLabel,
          ),
        ),
      ],
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
            builder: (context, child) => DatabaseMaintenanceOverlay(
              child: OfflineModeBanner(child: child!),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
