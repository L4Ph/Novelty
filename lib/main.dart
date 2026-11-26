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

/// The locale the app is pinned to.
/// Japanese (Japan) regardless of the OS locale, so the app always
/// behaves as a Japanese environment.
const appLocale = Locale('ja', 'JP');

/// The locales the app supports.
/// Japanese (Japan) only, regardless of the OS locale, so CJK text does
/// not fall back to Chinese glyphs.

const appSupportedLocales = <Locale>[appLocale];

/// The localisation delegates the app uses.
const appLocalizationsDelegates = <LocalizationsDelegate<dynamic>>[
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

/// The application entry point.
///
/// Owns every long-lived instance (database, settings, repository) and picks
/// between the progress splash, the recovery screen and the main screen from
/// the database state. Hands [AppServices] down through a [Scope].
class MyApp extends StatefulWidget {
  /// Creates the app.
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

  /// Opens a new database and builds the service bundle bound to it.
  ///
  /// The import swap takes this path too, so a screen only ever receives a
  /// repository over a connection that is still open.
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

  /// Replaces the database file.
  ///
  /// By the time the state turns into [DatabaseMaintenanceBusy] with a payload,
  /// the next frame unmounts every screen below and cancels their stream
  /// subscriptions. The connection is closed only after that, and the file is
  /// swapped before the new connection is opened.
  /// (Drift's close() never completes while a paused subscription is attached.)
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

    // Set the result after the frame so nothing notifies mid-build.
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
          // While the file is being replaced, build no subscription at all:
          // only the blocking screen is shown.
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

/// The main app once settings are readable: theme and router.
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
      error: (err, stackTrace) => _startupApp(
        home: Center(child: Text('Error: $err')),
      ),
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

/// Covers the screens below while a database maintenance operation runs.
///
/// While [DatabaseMaintenanceBusy], an opaque screen sits on top and blocks
/// touches. The screens below are kept, so feedback for the finished
/// operation (dialogs and the like) can still be shown.

class DatabaseMaintenanceOverlay extends StatelessWidget {
  /// Creates the overlay.
  const DatabaseMaintenanceOverlay({
    required this.maintenance,
    required this.child,
    super.key,
  });

  /// Where the state is read from.
  final DatabaseMaintenanceController maintenance;

  /// The screen to show below.
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
          // Unmount the screens below while the file is being replaced, so
          // every stream subscription is cancelled. Drift's close() never
          // completes while a paused subscription is attached, so only the
          // blocking screen is returned here.
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

/// Reports the result of an import swap in a snackbar.
///
/// The swap unmounts the whole tree, so the result can only be reported by
/// the tree rebuilt afterwards. On mount it picks up an unconsumed result and
/// also watches for one arriving later, showing it once.
class ImportSwapResultHandler extends StatefulWidget {
  /// Creates the handler.
  const ImportSwapResultHandler({
    required this.maintenance,
    required this.child,
    super.key,
  });

  /// Where the result is read from.
  final DatabaseMaintenanceController maintenance;

  /// The screen to show below.
  final Widget child;

  @override
  State<ImportSwapResultHandler> createState() =>
      _ImportSwapResultHandlerState();
}

class _ImportSwapResultHandlerState extends State<ImportSwapResultHandler> {
  @override
  void initState() {
    super.initState();
    // Pick up a result that was already decided before this tree mounted.
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
