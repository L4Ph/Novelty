import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
import 'package:novelty/widgets/network_fallback_snackbar.dart';

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
    // インポート適用(DBファイル置き換え)の要求を監視する。
    // Busy状態にpayloadがセットされたら、画面のアンマウントを待ってから
    // ファイル置き換えを実行する。
    ref.listen<DatabaseMaintenanceState>(databaseMaintenanceProvider, (
      previous,
      next,
    ) {
      final swap = next is DatabaseMaintenanceBusy ? next.importSwap : null;
      final prevSwap = previous is DatabaseMaintenanceBusy
          ? previous.importSwap
          : null;
      if (swap != null && !identical(swap, prevSwap)) {
        unawaited(_performImportSwap(ref, swap));
      }
    });

    final maintenance = ref.watch(databaseMaintenanceProvider);
    if (maintenance is DatabaseMaintenanceBusy &&
        maintenance.importSwap != null) {
      // DBファイル置き換え中は、DB関連プロバイダを一切監視しない
      // ブロッキング画面のみを表示する。
      // databaseInitializationProvider等を監視したまま
      // appDatabaseProviderをinvalidateすると即座に再生成されて
      // しまい、旧接続のクローズと新接続のオープンが競合するため。
      return MaterialApp(
        locale: appLocale,
        supportedLocales: appSupportedLocales,
        localizationsDelegates: appLocalizationsDelegates,
        theme: ThemeData(fontFamily: appUiFontFamily),
        home: DatabaseMaintenanceScreen(
          operationLabel: maintenance.operationLabel,
        ),
      );
    }

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
                  task: () => BackupService(db).exportDatabaseFileDirectly(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// インポート適用(DBファイルの置き換え)を実行する。
///
/// この時点で [DatabaseMaintenanceBusy] にpayloadがセット済みのため、
/// オーバーレイは配下の画面をアンマウントしている。画面のアンマウントに
/// よってDBへのストリーム購読が全てキャンセルされてから、
/// 接続のクローズとファイル置き換えを行う。
/// (pause状態の購読が残っているとDriftのclose()は完了しないため)
Future<void> _performImportSwap(
  WidgetRef ref,
  ImportSwapPayload payload,
) async {
  // フレームの終わりまで待ち、配下画面のアンマウントと
  // MyApp側のDBプロバイダ監視解除を完了させる
  await SchedulerBinding.instance.endOfFrame;

  // DBに依存する全プロバイダを破棄し、ストリーム購読を全て
  // キャンセルさせてから旧接続をクローズする。
  // keepAliveのストリームプロバイダ(lastReadEpisode等)は
  // 画面アンマウントだけでは破棄されず、購読がpause状態で残ると
  // Driftのclose()が完了しないため、この破棄が必須。
  // 破棄時のクローズはapplyImportSwap内のクローズと
  // closeAppDatabaseSafelyにより単一実行化される。
  final oldDb = ref.read(appDatabaseProvider);
  ref.invalidate(appDatabaseProvider);

  Object? error;
  try {
    await BackupService(oldDb).applyImportSwap(payload.pendingFilePath);
  } on Object catch (e) {
    error = e;
  }

  // 新しいDBインスタンスをビルドの外で生成しておく。
  // MyAppの再ビルド中に遅延再生成とその通知が走ると
  // 「setState during build」になるため(実測で確認)。
  // 生成だけではファイルは開かれず、実際のオープンは
  // databaseInitializationProvider経由で行われる。
  ref.read(appDatabaseProvider);

  // Idleへ戻すとMyAppがdatabaseInitializationProviderを再監視し、
  // 新しいDBインスタンスで開き直される(起動時と同一の再初期化経路)。
  // 失敗時はapplyImportSwap内で元のファイルに復元済み。
  // ビルド中の状態更新(setState during build)を避けるため、
  // フレーム完了後に結果をセットする。
  SchedulerBinding.instance.addPostFrameCallback((_) {
    finishImportSwap(
      ref,
      result: error == null
          ? const ImportSwapResult(success: true)
          : ImportSwapResult(success: false, error: error.toString()),
    );
  });
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
    if (maintenance.importSwap != null) {
      // DBファイルを置き換える間は配下の画面をアンマウントし、
      // DBへのストリーム購読を全てキャンセルさせる。
      // pause状態の購読が残っているとDriftのclose()が完了しないため、
      // 子を含めずブロッキング画面のみを返す。
      return DatabaseMaintenanceScreen(
        operationLabel: maintenance.operationLabel,
      );
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

/// インポート適用の結果を検知してスナックバーで通知するウィジェット。
///
/// 適用処理は画面全体のアンマウントを伴うため、結果の通知は
/// 再初期化後の画面ツリーで行う必要がある。マウント時に未消費の結果を
/// 拾い、マウント中の変更も監視して一度だけ表示して消費する。
class ImportSwapResultHandler extends ConsumerStatefulWidget {
  /// コンストラクタ。
  const ImportSwapResultHandler({required this.child, super.key});

  /// 配下に表示する画面。
  final Widget child;

  @override
  ConsumerState<ImportSwapResultHandler> createState() =>
      _ImportSwapResultHandlerState();
}

class _ImportSwapResultHandlerState
    extends ConsumerState<ImportSwapResultHandler> {
  @override
  void initState() {
    super.initState();
    // 再初期化の完了前に確定していた結果を拾う
    WidgetsBinding.instance.addPostFrameCallback((_) => _consumeResult());
  }

  void _consumeResult() {
    if (!mounted) return;
    final result = ref.read(importSwapResultProvider);
    if (result == null) return;
    ref.read(importSwapResultProvider.notifier).state = null;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.success
              ? 'データベースの復元が完了しました'
              : 'データベースの復元に失敗しました。'
                    '元のデータに復元済みです: ${result.error}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ImportSwapResult?>(importSwapResultProvider, (previous, next) {
      if (next != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _consumeResult());
      }
    });
    return widget.child;
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
            builder: (context, child) => ImportSwapResultHandler(
              child: DatabaseMaintenanceOverlay(
                child: NetworkFallbackSnackbar(child: child!),
              ),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
