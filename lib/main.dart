import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:novelty/app_services.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/database/database_maintenance.dart';
import 'package:novelty/providers/network_fallback_event_provider.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/repositories/preferences_repository.dart';
import 'package:novelty/router/app_router.dart';
import 'package:novelty/screens/database_maintenance_screen.dart';
import 'package:novelty/screens/migration_progress_splash.dart';
import 'package:novelty/screens/migration_recovery_screen.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/services/backup_service.dart';
import 'package:novelty/sites/novel_site_registry.dart';
import 'package:novelty/utils/font_family.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/widgets/network_fallback_snackbar.dart';
import 'package:tiny_state/tiny_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
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
///
/// すべての長寿命インスタンス（DB・設定・リポジトリ）を所有し、DBの
/// 初期化状態に応じて進捗スプラッシュ、リカバリー画面、メイン画面を出し分ける。
/// 配下へは [Scope] で [AppServices] を配る。
class MyApp extends StatefulWidget {
  /// コンストラクタ。
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _maintenance = DatabaseMaintenanceController();
  final _fallback = NetworkFallbackBus();
  final _prefs = PreferencesRepository();
  late final SettingsController _settings;
  late final ApiService _api;

  AppServices? _services;
  Async<void> _dbInit = const AsyncLoading();
  ImportSwapPayload? _handledSwap;

  @override
  void initState() {
    super.initState();
    _settings = SettingsController(_prefs);
    _api = ApiService();
    _maintenance.addListener(_onMaintenanceChanged);
    unawaited(_settings.load());
    unawaited(_openDatabase());
  }

  @override
  void dispose() {
    _maintenance
      ..removeListener(_onMaintenanceChanged)
      ..dispose();
    _fallback.dispose();
    _settings.dispose();
    _api.close();
    final services = _services;
    if (services != null) {
      services.repository.dispose();
      unawaited(closeAppDatabaseSafely(services.db));
    }
    super.dispose();
  }

  /// 新しいDBを開き、そのDBに結びついたサービス一式を組み立てる。
  ///
  /// 置き換え時もこの経路を通るので、画面は常に開いている接続のリポジトリを
  /// 受け取る。
  Future<void> _openDatabase() async {
    final db = AppDatabase();
    final services = AppServices(
      db: db,
      api: _api,
      prefs: _prefs,
      settings: _settings,
      repository: NovelRepository(
        apiService: _api,
        settings: _settings,
        db: db,
        fallback: _fallback,
        sites: defaultNovelSiteRegistry,
      ),
      maintenance: _maintenance,
      fallback: _fallback,
      sites: defaultNovelSiteRegistry,
      now: DateTime.now,
    );
    setState(() {
      _services = services;
      _dbInit = const AsyncLoading();
    });

    try {
      await db.doWhenOpened((_) async {});
      if (!mounted) return;
      setState(() => _dbInit = const AsyncData(null));
    } on Object catch (error, stackTrace) {
      if (!mounted) return;
      setState(() => _dbInit = AsyncError(error, stackTrace));
    }
  }

  void _onMaintenanceChanged() {
    final state = _maintenance.state;
    final swap = state is DatabaseMaintenanceBusy ? state.importSwap : null;
    if (swap == null || identical(swap, _handledSwap)) return;
    _handledSwap = swap;
    unawaited(_performImportSwap(swap));
  }

  /// インポート適用(DBファイルの置き換え)を実行する。
  ///
  /// 状態が [DatabaseMaintenanceBusy] にpayload付きで変わった時点で、次の
  /// フレームでは配下の画面がアンマウントされ、DBへのストリーム購読が
  /// 全てキャンセルされる。購読の解除を待ってから接続を閉じ、ファイルを
  /// 置き換えて新しい接続を開く。
  /// (pause状態の購読が残っているとDriftのclose()は完了しない)
  Future<void> _performImportSwap(ImportSwapPayload payload) async {
    await SchedulerBinding.instance.endOfFrame;

    final old = _services;
    Object? error;
    if (old != null) {
      await closeAppDatabaseSafely(old.db);
      old.repository.dispose();
      try {
        await BackupService(old.db).applyImportSwap(payload.pendingFilePath);
      } on Object catch (e) {
        error = e;
      }
    }

    await _openDatabase();

    // フレーム完了後に結果をセットする（ビルド中の通知を避ける）。
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Screens on the stacks belong to the database that was just replaced.
      appRouter.reset();
      _maintenance.finishImportSwap(
        result: error == null
            ? const ImportSwapResult(success: true)
            : ImportSwapResult(success: false, error: error.toString()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_settings, _maintenance]),
      builder: (context, _) {
        final maintenance = _maintenance.state;
        if (maintenance is DatabaseMaintenanceBusy &&
            maintenance.importSwap != null) {
          // DBファイル置き換え中は、DB関連の購読を一切作らない
          // ブロッキング画面のみを表示する。
          return _startupApp(
            home: DatabaseMaintenanceScreen(
              operationLabel: maintenance.operationLabel,
            ),
          );
        }

        return _dbInit.when(
          data: (_) => Scope(
            services: <Type, Object>{AppServices: _services!},
            child: _AppWithSettings(services: _services!),
          ),
          loading: () => _startupApp(
            home: DatabaseMaintenanceOverlay(
              maintenance: _maintenance,
              child: const MigrationProgressSplash(),
            ),
          ),
          error: (error, stackTrace) => _startupApp(
            home: DatabaseMaintenanceOverlay(
              maintenance: _maintenance,
              child: MigrationRecoveryScreen(
                error: error,
                onRetry: () {
                  final services = _services;
                  if (services != null) {
                    unawaited(closeAppDatabaseSafely(services.db));
                    services.repository.dispose();
                  }
                  unawaited(_openDatabase());
                },
                onExportDatabase: () {
                  final services = _services;
                  if (services == null) return Future<String?>.value();
                  return _maintenance.run(
                    label: 'データベースをエクスポートしています…',
                    task: () => BackupService(
                      services.db,
                    ).exportDatabaseFileDirectly(),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 設定を読み込み、テーマとルーターを適用したメインアプリ。
class _AppWithSettings extends StatelessWidget {
  const _AppWithSettings({required this.services});

  final AppServices services;

  @override
  Widget build(BuildContext context) {
    return services.settings.state.when(
      data: (settings) => MaterialApp.router(
        title: 'Novelty',
        locale: appLocale,
        supportedLocales: appSupportedLocales,
        localizationsDelegates: appLocalizationsDelegates,
        themeMode: settings.themeMode,
        theme: appTheme(Brightness.light),
        darkTheme: appTheme(Brightness.dark),
        routerConfig: appRouterConfig,
        builder: (context, child) => ImportSwapResultHandler(
          maintenance: services.maintenance,
          child: DatabaseMaintenanceOverlay(
            maintenance: services.maintenance,
            child: NetworkFallbackSnackbar(
              bus: services.fallback,
              child: child!,
            ),
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stackTrace) => Center(child: Text('Error: $err')),
    );
  }
}

/// Startup and maintenance screens, shown before settings are readable.
/// They follow the OS brightness so they don't flash the light palette
/// on a dark device before the main screen mounts.
Widget _startupApp({required Widget home}) => MaterialApp(
  locale: appLocale,
  supportedLocales: appSupportedLocales,
  localizationsDelegates: appLocalizationsDelegates,
  theme: appTheme(Brightness.light),
  darkTheme: appTheme(Brightness.dark),
  home: home,
);

/// DBを停止して行う保守操作の実行中に、
/// 配下の画面全体をブロッキング画面で覆うオーバーレイ。
///
/// [DatabaseMaintenanceBusy] の間は不透明なブロッキング画面を最前面に重ね、
/// 配下のUIへのタッチを物理的に遮断する。
/// 配下の画面は破棄されずに保持されるため、操作完了後の
/// フィードバック(ダイアログ等)をそのまま表示できる。
class DatabaseMaintenanceOverlay extends StatelessWidget {
  /// コンストラクタ。
  const DatabaseMaintenanceOverlay({
    required this.maintenance,
    required this.child,
    super.key,
  });

  /// 実行状態の取得元。
  final DatabaseMaintenanceController maintenance;

  /// 配下に表示する画面。
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: maintenance,
      builder: (context, _) {
        final state = maintenance.state;
        if (state is! DatabaseMaintenanceBusy) {
          return child;
        }
        if (state.importSwap != null) {
          // DBファイルを置き換える間は配下の画面をアンマウントし、
          // DBへのストリーム購読を全てキャンセルさせる。
          // pause状態の購読が残っているとDriftのclose()が完了しないため、
          // 子を含めずブロッキング画面のみを返す。
          return DatabaseMaintenanceScreen(
            operationLabel: state.operationLabel,
          );
        }
        return Stack(
          children: [
            child,
            Positioned.fill(
              child: DatabaseMaintenanceScreen(
                operationLabel: state.operationLabel,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// インポート適用の結果を検知してスナックバーで通知するウィジェット。
///
/// 適用処理は画面全体のアンマウントを伴うため、結果の通知は
/// 再初期化後の画面ツリーで行う必要がある。マウント時に未消費の結果を
/// 拾い、マウント中の変更も監視して一度だけ表示して消費する。
class ImportSwapResultHandler extends StatefulWidget {
  /// コンストラクタ。
  const ImportSwapResultHandler({
    required this.maintenance,
    required this.child,
    super.key,
  });

  /// 結果の取得元。
  final DatabaseMaintenanceController maintenance;

  /// 配下に表示する画面。
  final Widget child;

  @override
  State<ImportSwapResultHandler> createState() =>
      _ImportSwapResultHandlerState();
}

class _ImportSwapResultHandlerState extends State<ImportSwapResultHandler> {
  @override
  void initState() {
    super.initState();
    // 再初期化の完了前に確定していた結果を拾う
    WidgetsBinding.instance.addPostFrameCallback((_) => _consumeResult());
    widget.maintenance.addListener(_onMaintenanceChanged);
  }

  @override
  void dispose() {
    widget.maintenance.removeListener(_onMaintenanceChanged);
    super.dispose();
  }

  void _onMaintenanceChanged() {
    if (widget.maintenance.importSwapResult == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _consumeResult());
  }

  void _consumeResult() {
    if (!mounted) return;
    final result = widget.maintenance.takeImportSwapResult();
    if (result == null) return;
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
  Widget build(BuildContext context) => widget.child;
}

/// Seed color for the UI palette. Changing it swaps every color in the app.
const _seedColor = Color(0xFF006972);

/// Builds the app theme for the given brightness.
ThemeData appTheme(Brightness brightness) => ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: brightness,
  ),
  fontFamily: appUiFontFamily,
);
